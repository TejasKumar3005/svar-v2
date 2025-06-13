import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart' hide LinearGradient, Image;

class ExerciseDiscrimination extends StatefulWidget {
  const ExerciseDiscrimination({
    Key? key,
  }) : super(key: key);

  @override
  State<ExerciseDiscrimination> createState() => _DiscriminationState();

  static Widget builder(BuildContext context) {
    return const ExerciseDiscrimination();
  }
}

class _DiscriminationState extends State<ExerciseDiscrimination>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AudioWidgetState> _childKey = GlobalKey<AudioWidgetState>();
  late UserData userData;
  int selectedOption = -1;
  List<double> samples = [];
  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;
  bool isPlaying = false;
  late AudioPlayer _player;

  // Animation controller for feedback
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int currentIndex = 0;
  double currentProgress = 0.0;
  List<double> total_length = [];

  // New state variables for next exercise functionality
  bool exerciseCompleted = false;
  bool hasMoreExercises = false;
  int currentExerciseIndex = 0;

  bool parent_mode = true;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _player = AudioPlayer();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Portrait orientation setup
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
  }

  void getAudioProgress() {
    setState(() {
      currentProgress = _childKey.currentState!.progress.value;
    });
  }

  void _onRiveInit(Artboard artboard) async {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 2');

    if (controller != null) {
      artboard.addController(controller);
      riveController = controller;
      _correctTrigger = controller.findInput<bool>('correct') as SMITrigger;
      _incorrectTrigger = controller.findInput<bool>('incorrect') as SMITrigger;
    }
  }

  void _triggerAnimation(bool isCorrect) {
    print("isCorrect: $isCorrect");
    if (isCorrect) {
      if (_correctTrigger != null) {
        print("correctTrigger: is fired");
        _correctTrigger!.fire();
        setState(() {
          exerciseCompleted = true;
        });

        // Only auto-navigate if there are no more exercises for today
        if (!hasMoreExercises) {
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted && !parent_mode) {
              Navigator.pop(context);
            }
          });
        }
      }
    } else {
      if (_incorrectTrigger != null) {
        _incorrectTrigger!.fire();
      }
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    currentExerciseIndex = obj[3] as int;

    // Check if there are more exercises left for today
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    _checkForMoreExercises(data_pro);

    String type = obj[0] as String;
    print("Type: $type");
    String text = type == "OddOne"
        ? "Listen to the sounds. Which one sounds different from the others?"
        : type == "MaleFemale"
            ? "Listen to the voice carefully. Can you tell which one is male and which one is female?"
            : type == "DiffHalf"
                ? "Listen closely. Tap the button as soon as the sound changes."
                : "You will hear two sounds. Are they the same or different?";
    String audioFile = type == "OddOne"
        ? "v8.wav"
        : type == "MaleFemale"
            ? "v2.wav"
            : type == "DiffHalf"
                ? "v3.wav"
                : "v5.wav";
    // Future.delayed(const Duration(seconds: 3), () async {
    //   await _player.play(AssetSource("assets/audio/bgm/$audioFile"));
    // });
  }

  /// Checks if there are any remaining incomplete exercises for today after the current exercise
  ///
  /// This method:
  /// 1. Gets today's date in YYYY-MM-DD format
  /// 2. Filters the exercise list to only include today's exercises
  /// 3. Finds the current exercise's position in today's filtered list
  /// 4. Checks if there are any incomplete exercises after the current one
  /// 5. Updates the hasMoreExercises flag accordingly
  ///
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

  @override
  void dispose() {
    _animationController.dispose();
    _player.dispose(); // Dispose audio player to prevent memory leak
    super.dispose();
  }

  int level = 0;

  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
    level = obj[3] as int;
    Object data = obj[1] as Object;
    dynamic dtcontainer = obj[2] as dynamic;

    // Use sample data when parent_mode is true
    if (parent_mode) {
      switch (type) {
        case "DiffSounds":
          data = sampleDiffSounds;
          break;
        case "OddOne":
          data = sampleOddOne;
          break;
        case "DiffHalf":
          data = sampleDiffHalf;
          break;
        case "MaleFemale":
          data = sampleMaleFemale;
          break;
        default:
          // Keep original data if no sample available
          data = obj[1] as Object;
          break;
      }
    }

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // Replace gradient with background image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/quiz_bg.jpeg'), // Update with your actual image path
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          padding:   EdgeInsets.only(left: 10.h, right: 10.h, top: 40.v),
          child: Column(
            children: [
              // App Bar with padding
              DisciAppBar(context, parent_mode: parent_mode),
          
              // Title section positioned over the placeholder
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.v),
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric( horizontal: 20.h),
                  // Remove decoration to make it transparent over the placeholder
                  child: Text(
                    type == "OddOne"
                        ? "Listen to the sounds. Which one sounds different from the others?"
                        : type == "MaleFemale"
                            ? "Listen to the voice carefully. Can you tell which one is male and which one is female?"
                            : type == "DiffHalf"
                                ? "Listen closely. Tap the button as soon as the sound changes."
                                : "You will hear two sounds. Are they the same or different?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Comic Sans MS", // Child-friendly font
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Color.fromARGB(255, 132, 140, 74),
                    ),
                  ),
                ),
              ),
          
              // Main content area
              Expanded(
                child: Stack(
                  children: [
                    // Main discrimination options
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.h, 10.v, 15.h, 60.v),
                      child: discriminationOptions(type, data, dtcontainer),
                    ),
          
                    // Animation overlay at bottom
                    Stack(
                      children: [
                        Positioned(
                          bottom: 0.h,
                          left: 0.h,
                          child: IgnorePointer(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width,
                              child: RiveAnimation.asset(
                                'assets/rive/Celebration_animation.riv',
                                onInit: _onRiveInit,
                                fit: BoxFit.fitHeight,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                        ),
          
                        // Next button - positioned on the right side of Rive animation
                        if (exerciseCompleted && hasMoreExercises)
                          Positioned(
                            bottom: MediaQuery.of(context).size.height * 0.15,
                            right: 20.h,
                            child: AnimatedScale(
                              scale: exerciseCompleted ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF4CAF50),
                                      Color(0xFF45A049)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(25),
                                    onTap: _moveToNextExercise,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.h,
                                        vertical: 15.v,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Next",
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(width: 8.h),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
          
                        if (parent_mode) ...[
                          Positioned(
                            bottom: MediaQuery.of(context).size.height * 0.1,
                            right: 20,
                            child: AnimatedScale(
                              scale: 1.0,
                              duration: Duration(milliseconds: 500),
                              child: CustomButton(
                                  width: 150.h,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget discriminationOptions(String type, Object d, dynamic dtcontainer) {
    print("Type: $type");
    print("Data: $d");
    print("dtcontainer: $dtcontainer");
    switch (type) {
      case "DiffSounds":
        return DiffSoundsW(d as DiffSounds, dtcontainer);
      case "OddOne":
        return OddOneW(d as OddOne, dtcontainer);
      case "DiffHalf":
        return DiffHalfW(d as DiffHalf, dtcontainer);
      case "MaleFemale":
        return MaleFemaleW(d as MaleFemale, dtcontainer);
      default:
        return Container();
    }
  }

  Widget MaleFemaleW(MaleFemale maleFemale, dynamic dtcontainer) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    // Use LayoutBuilder to ensure responsiveness
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive sizes
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Audio player component - centered and sized appropriately
              Container(
                width: maxWidth * 0.8,
                height: 70,
                margin: EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  color: Color(0xFFF77D2B), // Orange color
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: AudioWidget(
                  audioLinks: maleFemale.getVideoUrl(),
                ),
              ),

              // Gender selection options - smaller size and centered
              Container(
                width: maxWidth * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Female option
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: _buildSmallGenderOption(
                          "FEMALE",
                          "assets/images/female.png",
                          () => maleFemale.getCorrectOutput() == "female",
                          startExerciseIndex,
                          data,
                        ),
                      ),
                    ),

                    // Male option
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: _buildSmallGenderOption(
                          "MALE",
                          "assets/images/male.png",
                          () => maleFemale.getCorrectOutput() == "male",
                          startExerciseIndex,
                          data,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Small gender option widget optimized for centered layout
  Widget _buildSmallGenderOption(
      String label,
      String imagePath,
      bool Function() isCorrectFn,
      int startExerciseIndex,
      Map<String, dynamic> data) {
    return OptionWidget(
      triggerAnimation: _triggerAnimation,
      child: Container(
        height: 220, // Reduced height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image section
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF5FB8FF),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    height: 85, // Smaller image size
                  ),
                ),
              ),
            ),

            // Label section
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5E9FE0), Color(0xFF3D7EDB)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // Smaller font size
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isCorrect: () {
        var condition = isCorrectFn();
        if (condition && !parent_mode) {
          var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
          data_pro.incrementLevel(startExerciseIndex);

          UserData(uid: FirebaseAuth.instance.currentUser!.uid)
              .updateExerciseData(
                  euid: data["uid"],
                  date: data["date"],
                  performance: {
                "correct_attempt": condition,
                "correct_output": label,
                "time": DateTime.now().toString(),
              });
        }
        return condition;
      },
    );
  }

  Widget DiffHalfW(DiffHalf diffHalf, dynamic dtcontainer) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    // Using LayoutBuilder for responsive layout
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate responsive sizes
          double maxWidth = constraints.maxWidth;
          double maxHeight = constraints.maxHeight;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spacer to push content to vertical center
              Spacer(flex: 1),

              // Audio player component - centered
              Container(
                width: maxWidth * 0.85,
                height: 70,
                margin: EdgeInsets.only(bottom: 50),
                decoration: BoxDecoration(
                  color: Color(0xFFF77D2B), // Orange color
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: AudioWidget(
                  key: _childKey,
                  audioLinks: diffHalf.getVideoUrls(),
                ),
              ),

              // Change button - centered
              ScaleTransition(
                scale: _scaleAnimation,
                child: OptionWidget(
                  triggerAnimation: _triggerAnimation,
                  child:
                      OptionButton(type: ButtonType.Change, onPressed: () {}),
                  isCorrect: () {
                    // Add null safety check
                    if (_childKey.currentState == null) {
                      return false;
                    }

                    // Check if AudioWidget is properly initialized
                    if (!_childKey.currentState!.isInitialized) {
                      return false;
                    }

                    List<double> total_length = _childKey.currentState!.lengths;

                    // Check if lengths are properly initialized
                    if (total_length.isEmpty || total_length.length < 2) {
                      return false;
                    }

                    double ans =
                        total_length[0] / (total_length[1] + total_length[0]);
                    var condition =
                        _childKey.currentState!.progress.value > ans &&
                            _childKey.currentState!.progress.value < ans + 0.4;

                    if (condition && !parent_mode) {
                      data_pro.incrementLevel(startExerciseIndex);

                      UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                          .updateExerciseData(
                              euid: data["uid"],
                              date: data["date"],
                              performance: {
                            "progress": _childKey.currentState!.progress.value,
                            "total_length": total_length,
                          });
                    }

                    return condition;
                  },
                ),
              ),

              Spacer(flex: 1),
            ],
          );
        },
      ),
    );
  }

  Widget DiffSoundsW(DiffSounds diffSounds, dynamic dtcontainer) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 35.v, horizontal: 20.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Improved audio player
                Container(
                  width: constraints.maxWidth,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: AudioWidget(
                    audioLinks: diffSounds.getVideoUrls(),
                  ),
                ),

                SizedBox(height: 40.v),

                // Button row with improved styling
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: OptionWidget(
                        triggerAnimation: _triggerAnimation,
                        child: OptionButton(
                            type: ButtonType.Same, onPressed: () {}),
                        isCorrect: () {
                          var condition = diffSounds.getSame();
                          if (condition && !parent_mode) {
                            data_pro.incrementLevel(startExerciseIndex);

                            UserData(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .updateExerciseData(
                                    euid: data["uid"],
                                    date: data["date"],
                                    performance: {
                                  "correct_attempt": condition,
                                  "time": DateTime.now().toString(),
                                });
                          }

                          return condition;
                        },
                      ),
                    ),
                    SizedBox(height: 20.v),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: OptionWidget(
                        triggerAnimation: _triggerAnimation,
                        child: OptionButton(
                            type: ButtonType.Diff, onPressed: () {}),
                        isCorrect: () {
                          var condition = !diffSounds.getSame();
                          if (condition && !parent_mode) {
                            data_pro.incrementLevel(startExerciseIndex);

                            UserData(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .updateExerciseData(
                                    euid: data["uid"],
                                    date: data["date"],
                                    performance: {
                                  "correct_attempt": condition,
                                  "time": DateTime.now().toString(),
                                });
                          }
                          return condition;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResponseButton(
    String label,
    IconData icon,
    bool Function() isCorrectFn,
  ) {
    return OptionWidget(
      triggerAnimation: _triggerAnimation,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 60.v,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5E9FE0), Color(0xFF3D7EDB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              // Button press animation
              _animationController
                  .forward()
                  .then((_) => _animationController.reverse());
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8.h),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isCorrect: isCorrectFn,
    );
  }

  Widget OddOneW(OddOne oddOne, dynamic dtcontainer) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    // Function to build each audio option
    Widget buildAudioOption(int index) {
      return OptionWidget(
        triggerAnimation: (value) => _triggerAnimation(value),
        child: Container(
          width:
              MediaQuery.of(context).size.width * 0.85, // 85% of screen width
          height: 70, // Fixed height for all audio widgets
          decoration: BoxDecoration(
            color: Color(0xFFF77D2B), // Orange color
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AudioWidget(
            audioLinks: [oddOne.getVideoUrls()[index]],
          ),
        ),
        isCorrect: () {
          var condition =
              oddOne.getVideoUrls()[index] == oddOne.getCorrectOutput();

          if (condition && !parent_mode) {
            data_pro.incrementLevel(startExerciseIndex);

            UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                .updateExerciseData(
                    euid: data["uid"],
                    date: data["date"],
                    performance: {
                  "correct_attempt": condition,
                  "time": DateTime.now().toString(),
                });
          }

          return condition;
        },
      );
    }

    // Using LayoutBuilder for responsive layout
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the number of options and spacing
        int optionCount = oddOne.video_url.length;
        double containerHeight = optionCount * 70 +
            (optionCount - 1) * 20; // Height for all options + spacing
        double topPadding =
            (constraints.maxHeight - containerHeight) / 2; // Center vertically

        return Column(
          children: [
            // Top padding to push content to vertical center
            Spacer(flex: 1),

            // Container for audio options
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  optionCount,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                        bottom: index < optionCount - 1 ? 20 : 0),
                    child: Center(child: buildAudioOption(index)),
                  ),
                ),
              ),
            ),
            Spacer(flex: 1),
          ],
        );
      },
    );
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
}

class ImageWidget extends StatelessWidget {
  final String imagePath;

  const ImageWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}
