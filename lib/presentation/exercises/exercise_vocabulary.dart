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
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
    return ExerciseVocabulary(
      word: data["word"],
      imageUrl: data["url"],
    );
  }
}

class ExerciseVocabularyState extends State<ExerciseVocabulary> {
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    initTTS();
    // Play TTS automatically when page loads
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        speakHindi(widget.word);
      }
    });
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
      setState(() => isSpeaking = false);
    });

    flutterTts.setErrorHandler((message) {
      setState(() => isSpeaking = false);
      print("TTS Error: $message");
    });
  }

  Future<void> speakHindi(String text) async {
    if (text.isEmpty) return;
    if (isSpeaking) {
      await flutterTts.stop();
      setState(() => isSpeaking = false);
      return;
    }
    try {
      setState(() => isSpeaking = true);
      await flutterTts.speak(text);
    } catch (e) {
      print("Error speaking: $e");
      setState(() => isSpeaking = false);
      showErrorSnackBar("Error in text to speech: $e");
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

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
              child: DisciAppBar(context),
            ),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image Container
                  GestureDetector(
                    onTap: () async {
                      await speakHindi(widget.word);
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
                          widget.imageUrl,
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
                      widget.word,
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
                    onPressed: () async {
                      await speakHindi(widget.word);
                    },
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

                  SizedBox(height: 20),

                  // Next Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Get exercise data
                      var obj = ModalRoute.of(context)?.settings.arguments
                          as List<dynamic>;
                      var data_pro =
                          Provider.of<ExerciseProvider>(context, listen: false);
                      int startExerciseIndex = obj[3] as int;
                      Map<String, dynamic> data =
                          data_pro.todaysExercises[startExerciseIndex];

                      // Update exercise data
                      UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                          .updateExerciseData(
                        euid: data["uid"],
                        date: data["date"],
                        performance: {
                          "completed": true,
                          "time": DateTime.now().toString(),
                        },
                      );

                      // Increment level and navigate back
                      data_pro.incrementLevel(startExerciseIndex);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    label: Text(
                      "NEXT",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
