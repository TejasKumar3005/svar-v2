import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svar_new/core/utils/image_constant.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/custom_button.dart';

class ExerciseVocabulary extends StatefulWidget {
  final String word;
  final String imageUrl;

  const ExerciseVocabulary({
    Key? key,
    required this.word,
    required this.imageUrl,
  }) : super(key: key);

  @override
  ExerciseVocabularyState createState() => ExerciseVocabularyState();

  static Widget builder(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>?;
    if (obj == null || obj.length <= 3) {
      // Return error widget if arguments are invalid
      return Scaffold(
        body: Center(
          child: Text(
            'Invalid exercise data',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;

    if (startExerciseIndex >= data_pro.todaysExercises.length) {
      return Scaffold(
        body: Center(
          child: Text(
            'Exercise not found',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    // Use sample data when parent_mode is true (default state)
    String word = data["word"] ?? "Unknown Word";
    String imageUrl = data["url"] ?? "";

    // For parent mode preview, use sample data
    // Since parent_mode is initially true in the widget, we use sample data by default
    // The actual data will be used when parent_mode becomes false

    return ExerciseVocabulary(
      word: word,
      imageUrl: imageUrl,
    );
  }
}

class ExerciseVocabularyState extends State<ExerciseVocabulary> {
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  bool? userAnswer; // null = not answered, true = right, false = wrong

  // New state variables for next exercise functionality
  bool exerciseCompleted = false;
  bool hasMoreExercises = false;
  int currentExerciseIndex = 0;

  bool parent_mode = true;

  @override
  void initState() {
    super.initState();
    initTTS();

    // Initialize exercise data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeExerciseData();
    });

    // Play TTS automatically when page loads
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        String wordToSpeak = parent_mode ? "clothes" : widget.word;
        speakHindi(wordToSpeak);
      }
    });
  }

  void _initializeExerciseData() {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>?;
    if (obj == null || obj.length <= 3) return;

    currentExerciseIndex = obj[3] as int;

    // Check if there are more exercises left for today
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    _checkForMoreExercises(data_pro);
  }

  void _checkForMoreExercises(ExerciseProvider data_pro) {
    // Get the current exercise's date
    if (currentExerciseIndex >= data_pro.todaysExercises.length) return;

    Map<String, dynamic> currentExercise =
        data_pro.todaysExercises[currentExerciseIndex];
    String exerciseDate = currentExercise['date'] ?? '';

    if (exerciseDate.isEmpty) return;

    // Filter exercises to only include exercises from the same date as current exercise
    List<Map<String, dynamic>> sameDateExercises = data_pro.todaysExercises
        .where((exercise) => exercise['date'] == exerciseDate)
        .toList();

    // Find the current exercise's position in the same date filtered list
    int currentIndexInSameDateExercises = sameDateExercises.indexWhere(
        (exercise) =>
            data_pro.todaysExercises.indexOf(exercise) == currentExerciseIndex);

    if (currentIndexInSameDateExercises != -1) {
      // Check if any exercises after current one are incomplete (completedAt is null)
      hasMoreExercises = sameDateExercises
          .skip(currentIndexInSameDateExercises + 1)
          .any((exercise) => exercise['completedAt'] == null);
    }

    print("Exercise date: $exerciseDate");
    print("Has more exercises for this date: $hasMoreExercises");
  }

  Future<void> initTTS() async {
    if (kIsWeb) {
      await flutterTts.setLanguage("hi-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
    } else {
      await flutterTts.setLanguage("hi-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
    }

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() => isSpeaking = false);
      }
    });

    flutterTts.setErrorHandler((dynamic message) {
      if (mounted) {
        setState(() => isSpeaking = false);
        print("TTS Error: $message");
      }
    });
  }

  Future<void> speakHindi(String text) async {
    if (text.isEmpty) return;
    if (isSpeaking) {
      await flutterTts.stop();
      if (mounted) {
        setState(() => isSpeaking = false);
      }
      return;
    }
    try {
      if (mounted) {
        setState(() => isSpeaking = true);
      }
      await flutterTts.speak(text);
    } catch (e) {
      print("Error speaking: $e");
      if (mounted) {
        setState(() => isSpeaking = false);
        showErrorSnackBar("Error in text to speech: $e");
      }
    }
  }

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Oh Snap!',
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void handleAnswer(bool isCorrect) {
    if (!mounted) return;

    setState(() {
      userAnswer = isCorrect;
      exerciseCompleted = true;
    });

    // Get exercise data with null safety
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>?;
    if (obj == null || obj.length <= 3) {
      showErrorSnackBar("Invalid exercise data");
      return;
    }

    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;

    if (startExerciseIndex >= data_pro.todaysExercises.length) {
      showErrorSnackBar("Exercise index out of range");
      return;
    }

    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    // Check if user is still authenticated
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      showErrorSnackBar("User not authenticated");
      return;
    }

    // Update exercise data with user's performance
    try {
      if (!parent_mode) {
        UserData(uid: currentUser.uid).updateExerciseData(
          euid: data["uid"],
          date: data["date"],
          performance: {
            "correct_attempt": isCorrect,
            "completed": true,
            "time": DateTime.now().toString(),
          },
        );
      }
      // If user marked it as correct, increment level
      if (isCorrect && !parent_mode) {
        data_pro.incrementLevel(startExerciseIndex);
      }

    } catch (e) {
      print("Error updating exercise data: $e");
      showErrorSnackBar("Failed to save progress: $e");
    }

    // Only auto-navigate if there are no more exercises for today
    if (!hasMoreExercises) {
      Future.delayed(Duration(milliseconds: 1000), () {
        if (mounted && !parent_mode)  {
          Navigator.pop(context);
        }
      });
    }
  }

  void _moveToNextExercise() {
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);

    // Get the current exercise's date
    if (currentExerciseIndex >= data_pro.todaysExercises.length) return;

    Map<String, dynamic> currentExercise =
        data_pro.todaysExercises[currentExerciseIndex];
    String exerciseDate = currentExercise['date'] ?? '';

    if (exerciseDate.isEmpty) return;

    // Find next incomplete exercise for the same date
    int nextExerciseIndex = -1;
    for (int i = currentExerciseIndex + 1;
        i < data_pro.todaysExercises.length;
        i++) {
      if (data_pro.todaysExercises[i]['date'] == exerciseDate &&
          data_pro.todaysExercises[i]['completedAt'] == null) {
        nextExerciseIndex = i;
        break;
      }
    }

    if (nextExerciseIndex != -1) {
      // Navigate to the next exercise
      Map<String, dynamic> nextExercise =
          data_pro.todaysExercises[nextExerciseIndex];
      String exerciseType = nextExercise["exerciseType"];

      // Pop current screen first
      Navigator.pop(context);

      // Navigate to appropriate exercise type
      navigateToExerciseType(exerciseType, nextExerciseIndex, context);
    } else {
      // No more exercises, just pop
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    // Use sample data when parent_mode is true
    String displayWord = widget.word;
    String displayImageUrl = widget.imageUrl;

    if (parent_mode) {
      displayWord = "clothes";
      displayImageUrl =
          "https://svarbucket.s3.amazonaws.com/new_clothes/images/akg_20250606_053303_5f49e6ce.png";
    }

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgGroup7),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: DisciAppBar(context, parent_mode: parent_mode),
            ),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image Container
                  GestureDetector(
                    onTap: () async {
                      await speakHindi(displayWord);
                    },
                    child: Container(
                      width:
                          isSmallScreen ? size.width * 0.7 : size.width * 0.4,
                      height:
                          isSmallScreen ? size.width * 0.7 : size.width * 0.4,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          displayImageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.error_outline,
                                size: 50,
                                color: Colors.red[300],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Word Display
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      displayWord,
                      style: GoogleFonts.inter(
                        fontSize: isSmallScreen ? 32 : 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Listen Again Button
                  ElevatedButton.icon(
                    onPressed: userAnswer == null
                        ? () async {
                            await speakHindi(displayWord);
                          }
                        : null,
                    icon: Icon(
                      isSpeaking ? Icons.stop : Icons.volume_up,
                      color: Colors.white,
                      size: 28,
                    ),
                    label: Text(
                      isSpeaking ? "Stop" : "Listen Again",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSpeaking ? Colors.red[600] : Colors.blue[600],
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Instructions
                  if (userAnswer == null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue[200]!, width: 1),
                      ),
                      child: Text(
                        "Did you understand the word correctly?",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  SizedBox(height: 20),

                  // Right/Wrong Buttons
                  if (userAnswer == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Wrong Button
                        ElevatedButton.icon(
                          onPressed: () => handleAnswer(false),
                          icon:
                              Icon(Icons.close, color: Colors.white, size: 24),
                          label: Text(
                            "WRONG",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        // Right Button
                        ElevatedButton.icon(
                          onPressed: () => handleAnswer(true),
                          icon:
                              Icon(Icons.check, color: Colors.white, size: 24),
                          label: Text(
                            "RIGHT",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),

                  // Show result after user selects
                  if (userAnswer != null)
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: userAnswer! ? Colors.green[50] : Colors.red[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: userAnswer!
                              ? Colors.green[300]!
                              : Colors.red[300]!,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            userAnswer! ? Icons.check_circle : Icons.cancel,
                            color: userAnswer!
                                ? Colors.green[600]
                                : Colors.red[600],
                            size: 48,
                          ),
                          SizedBox(height: 10),
                          Text(
                            userAnswer! ? "Great job!" : "Keep practicing!",
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: userAnswer!
                                  ? Colors.green[700]
                                  : Colors.red[700],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            hasMoreExercises
                                ? "Tap Next to continue"
                                : "Moving to next exercise...",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Next button - positioned on the right side when exercise is completed and there are more exercises
            if (exerciseCompleted && hasMoreExercises && !parent_mode)
              Positioned(
                                      bottom: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.03,
                                      right: 20,
                                      child: AnimatedScale(
                                        scale:
                                          1,
                                        duration:
                                            Duration(milliseconds: 500),
                                        child: CustomButton(
                                          width: 150,
                                          child:  Text(
          "Next",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        ),
                                          type: ButtonType.Next, onPressed: _moveToNextExercise)
                                      ),
                                    ),

            if (parent_mode) ...[
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.03,
                right: 20,
                child: AnimatedScale(
                  scale: 1.0,
                  duration: Duration(milliseconds: 500),
                  child: CustomButton(
                      width: 150,
                      type: ButtonType.Continue,
                      onPressed: () {
                        setState(() {
                          parent_mode = false;
                        });
                      }),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up TTS properly
    flutterTts.stop();
    flutterTts.setCompletionHandler(() {});
    flutterTts.setErrorHandler((dynamic message) {});
    super.dispose();
  }
}
