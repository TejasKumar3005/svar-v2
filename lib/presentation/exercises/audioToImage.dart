import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';


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
  late AudioPlayer _player;
  late UserData userData;
  late int leveltracker;
  int sel = 0;
  List<double> samples = [];

  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;
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
      if (_correctTrigger != null) {
        print("Firing correct trigger");
        _correctTrigger!.fire();
        print("Correct trigger fired");

        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pop(context);
        });
      }
    } else {
      if (_incorrectTrigger != null) {
        _incorrectTrigger!.fire();
        print("Incorrect trigger fired");
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int currentExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[currentExerciseIndex];
    
    // Calculate screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: appTheme.gray300,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
        children: [
          // Background image
          Positioned.fill(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/quiz_bg.jpeg'),
              fit: BoxFit.fill,
            ),
            ),
          ),
          ),
          Column(
          children: [
            // App bar
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
            child: DisciAppBar(context),
            ),
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.v),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.v, horizontal: 20.h),
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
                  audioLinks: widget.dtcontainer.getAudioUrl(),
                  ),
                ),
                // Small gap between audio and images
                SizedBox(height: 20),
                // Image options
                Container(
                  height: screenHeight * 0.3,
                  child: _buildImageOptions(data_pro, currentExerciseIndex, data),
                ),
                ],
              ),
              ),
            ),
            ),
          ],
          ),
          // Animation
          Positioned(
          bottom: 0,
          left: 0,
          child: IgnorePointer(
            child: SizedBox(
            height: screenHeight * 0.4,
            width: screenWidth,
            child: RiveAnimation.asset(
              'assets/rive/Celebration_animation.riv',
              onInit: _onRiveInit,
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerLeft,
            ),
            ),
          ),
          ),
        ],
        ),
      ),
      ),
    );
  }

  // Method to build image options in a grid layout for portrait mode
  Widget _buildImageOptions(ExerciseProvider data_pro, int currentExerciseIndex, Map<String, dynamic> data) {
    int itemCount = widget.dtcontainer.getImageUrlList().length;
    
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
                    imagePath: widget.dtcontainer.getImageUrlList()[index],
                  ),
                  isCorrect: () {
                    if (widget.dtcontainer.getCorrectOutput() ==
                        widget.dtcontainer.getImageUrlList()[index]) {
                      data_pro.incrementLevel(currentExerciseIndex);

                      if (data["completedAt"] == null) {
                        UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                            .updateExerciseData(
                              euid: data["uid"],
                              date: data["date"],
                            )
                            .then((value) => print("Exercise data updated"));
                      }
                    }
                    return widget.dtcontainer.getCorrectOutput() ==
                        widget.dtcontainer.getImageUrlList()[index];
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
                            imagePath: widget.dtcontainer.getImageUrlList()[index],
                          ),
                          isCorrect: () {
                            if (widget.dtcontainer.getCorrectOutput() ==
                                widget.dtcontainer.getImageUrlList()[index]) {
                              data_pro.incrementLevel(currentExerciseIndex);

                              if (data["completedAt"] == null) {
                                UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                                    .updateExerciseData(
                                      euid: data["uid"],
                                      date: data["date"],
                                    )
                                    .then((value) => print("Exercise data updated"));
                              }
                            }
                            return widget.dtcontainer.getCorrectOutput() ==
                                widget.dtcontainer.getImageUrlList()[index];
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