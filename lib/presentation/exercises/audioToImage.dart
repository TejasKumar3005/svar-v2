import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'dart:math';

class AudiotoimageScreen extends StatefulWidget {
  final dynamic dtcontainer;
  final String params;

  const AudiotoimageScreen({
    Key? key,
    required this.dtcontainer,
    required this.params,
  }) : super(key: key);

  @override
  AudiotoimageScreenState createState() => AudiotoimageScreenState();

  static Widget builder(BuildContext context, dynamic dtcontainer) {
    return AudiotoimageScreen(
      dtcontainer: dtcontainer,
      params: '',
    );
  }
}

class AudiotoimageScreenState extends State<AudiotoimageScreen> {
  bool parent_mode = true;
  late AudioPlayer _player;
  late UserData userData;
  late int leveltracker;
  int sel = 0;
  List<double> samples = [];

  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;

  bool exerciseCompleted = false;
  bool hasMoreExercises = false;
  int currentExerciseIndex = 0;
  // Variable to store the correct answer

  @override
  void initState() {
    super.initState();
    // Change to portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _player = AudioPlayer();
    leveltracker = 0;

    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
  }

  void _onRiveInit(Artboard artboard) async {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 2');

    if (controller != null) {
      artboard.addController(controller);
      riveController = controller;

      // Print all state machines for debugging
      print("\nAll State Machines in artboard:");
      for (var stateMachine in artboard.stateMachines) {
        print("State Machine: ${stateMachine.name}");
      }
      _correctTrigger = controller.findInput<bool>('correct') as SMITrigger;
      _incorrectTrigger = controller.findInput<bool>('incorrect') as SMITrigger;

      print("Controller added: $controller");
    }
  }

  void _triggerAnimation(bool isCorrect) {
    print("\nTrying to fire ${isCorrect ? 'correct' : 'incorrect'} trigger");

    if (isCorrect) {
      setState(() {
        exerciseCompleted = true;
      });

      // Only auto-navigate if there are no more exercises for today
      if (!hasMoreExercises) {
        if (_correctTrigger != null) {
          print("Firing correct trigger");
          _correctTrigger!.fire();
          print("Correct trigger fired");
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted && !parent_mode) {
              Navigator.pop(context);
            }
          });
        }
      }
    } else {
      if (_incorrectTrigger != null) {
        _incorrectTrigger!.fire();
        print("Incorrect trigger fired");
      }
    }
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

  void moveToNextExercise() {
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
  void dispose() {
    _player.dispose();
    super.dispose();
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

    // Play background music based on exercise type
    String audioFile = "v4.wav";

    // Future.delayed(const Duration(seconds: 3), () async {
    //   await _player.play(AssetSource("assets/audio/bgm/$audioFile"));
    // });
  }

  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int currentExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[currentExerciseIndex];

    // Use sample data when parent_mode is true
    dynamic dtcontainer = widget.dtcontainer;
    if (parent_mode) {
      final random = Random();
      switch (widget.params) {
        case "AudioToImage":
          dtcontainer =
              sampleAudioToImage[random.nextInt(sampleAudioToImage.length)];
          break;
        case "DiffAudioToImage":
          dtcontainer = sampleDiffAudioToImage[
              random.nextInt(sampleDiffAudioToImage.length)];
          break;
        default:
          // Keep original dtcontainer if no sample available
          dtcontainer = widget.dtcontainer;
          break;
      }
    }

    // Calculate screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: appTheme.gray300,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/quiz_bg.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            // Background image

            Column(
              children: [
                // App bar
                Padding(
                  padding: EdgeInsets.only(left: 10.h, right: 10.h, top: 40.v),
                  child: DisciAppBar(context, parent_mode: parent_mode),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Text(
                    "Listen to the sound. Which image matches this sound?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Comic Sans MS",
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Color.fromARGB(255, 132, 140, 74),
                    ),
                  ),
                ),
                // Center the main content
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Audio player
                          Container(
                            width: screenWidth * 0.85,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: AudioWidget(
                              audioLinks: dtcontainer.getAudioUrl(),
                            ),
                          ),
                          // Small gap between audio and images
                          SizedBox(height: 20),
                          // Image options
                          Container(
                            height: screenHeight * 0.3,
                            child: _buildImageOptions(data_pro,
                                currentExerciseIndex, data, dtcontainer),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Animation
            Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: IgnorePointer(
                    child: SizedBox(
                      height: screenHeight * 0.4,
                      width: screenWidth,
                      child: RiveAnimation.asset(
                          key: Key(parent_mode.toString()),
                        'assets/rive/Celebration_animation.riv',
                        onInit: _onRiveInit,
                        fit: BoxFit.fitHeight,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),
                if (exerciseCompleted && hasMoreExercises && !parent_mode)
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.15,
                    right: 20,
                    child: AnimatedScale(
                      scale: exerciseCompleted ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
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
                            onTap: moveToNextExercise,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
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
                                  SizedBox(width: 8),
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
                            width: 150,
                            type: ButtonType.Continue,
                            onPressed: () {
                              setState(() {
                                parent_mode = false;
                              });
                            })),
                  )
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to build image options in a grid layout for portrait mode
  Widget _buildImageOptions(ExerciseProvider data_pro, int currentExerciseIndex,
      Map<String, dynamic> data, dynamic dtcontainer) {
    int itemCount = dtcontainer.getImageUrlList().length;

    if (itemCount <= 0) return Container();

    // For portrait mode, organize images in a grid with fixed heights
    int columns = itemCount <= 2 ? itemCount : 2;

    if (itemCount <= 2) {
      // For one or two images, display in a single row
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(itemCount, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: AspectRatio(
                aspectRatio: 1, // Make images taller than wide (2:1 ratio)
                child: OptionWidget(
                  triggerAnimation: (value) {
                    _triggerAnimation(value);
                  },
                  child: ImageWidget(
                    imagePath: dtcontainer.getImageUrlList()[index],
                  ),
                  isCorrect: () {
                    if (dtcontainer.getCorrectOutput() ==
                            dtcontainer.getImageUrlList()[index] &&
                        !parent_mode) {
                      data_pro.incrementLevel(currentExerciseIndex);

                      UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                          .updateExerciseData(
                            euid: data["uid"],
                            date: data["date"],
                          )
                          .then((value) => print("Exercise data updated"));
                    }
                    return dtcontainer.getCorrectOutput() ==
                        dtcontainer.getImageUrlList()[index];
                  },
                ),
              ),
            ),
          );
        }),
      );
    } else {
      // For more than two images, use a grid layout
      int rows = (itemCount / columns).ceil();

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(rows, (rowIndex) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.v),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(columns, (colIndex) {
                  int index = rowIndex * columns + colIndex;
                  if (index < itemCount) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.h),
                        child: OptionWidget(
                          triggerAnimation: (value) {
                            _triggerAnimation(value);
                          },
                          child: ImageWidget(
                            imagePath: dtcontainer.getImageUrlList()[index],
                          ),
                          isCorrect: () {
                            if (dtcontainer.getCorrectOutput() ==
                                    dtcontainer.getImageUrlList()[index] &&
                                !parent_mode) {
                              data_pro.incrementLevel(currentExerciseIndex);

                              UserData(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .updateExerciseData(
                                    euid: data["uid"],
                                    date: data["date"],
                                  )
                                  .then((value) =>
                                      print("Exercise data updated"));
                            }
                            return dtcontainer.getCorrectOutput() ==
                                dtcontainer.getImageUrlList()[index];
                          },
                        ),
                      ),
                    );
                  } else {
                    return Expanded(child: SizedBox());
                  }
                }),
              ),
            ),
          );
        }),
      );
    }
  }
}
