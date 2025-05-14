import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/exercises/audioToImage.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/exercises/identification_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/database/userController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/presentation/settings_screen/setting.dart';

class ExerciseIdentification extends StatefulWidget {
  const ExerciseIdentification({Key? key})
      : super(
          key: key,
        );

  @override
  AuditoryScreenState createState() => AuditoryScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IdentificationProvider(),
      child: ExerciseIdentification(),
    );
  }
}

class AuditoryScreenState extends State<ExerciseIdentification> {
  late AudioPlayer _player;
  late int leveltracker;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  late UserData userData;

  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Change orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _player = AudioPlayer();
    leveltracker = 0;

    // Initialize userData with uid and context
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
  }

  int sel = 0;

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
  Widget build(BuildContext context) {
    var provider = context.watch<IdentificationProvider>();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;

    String type = obj[0] as String;
    dynamic dtcontainer = obj[1] as dynamic;
    String params = obj[2] as String;

    return type != "AudioToImage"
        ? (type == "AudioToAudio"
            ? Container()
            : SafeArea(
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  backgroundColor: appTheme.gray300,
                  body: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // Replace gradient with background image
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/quiz_bg.jpeg'), // Update with your actual image path
          fit: BoxFit.fill,
        ),
                        
                      ),
                      ),
                      ),
                      
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.h,
                          vertical: 10.v,
                        ),
                        child: Column(
                          children: [
                            DisciAppBar(context), // No need for any callbacks now,
                            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.v),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15.v, horizontal: 20.h),
                // Remove decoration to make it transparent over the placeholder
                child: Text(
                  type == "ImageToAudio"
                      ? "IDENTIFY  SOUND OF THE IMAGE"
                      : type == "MaleFemale" 
                        ? "IDENTIFY THE GENDER"
                        : type == "DiffHalf"
                          ? "PRESS WHEN THE SOUND CHANGES"
                          : "SAME OR DIFFERENT?",
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
            
                            Expanded(
                              child: Stack(
                                children: [
                                  _buildOptionGRP(
                                    context,
                                    provider,
                                    type,
                                    dtcontainer,
                                    params,
                                  ),
                                  // Rive animation positioned at bottom left
                                  Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
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
                                    ],
                                  ),
                                  // Tip button
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Add tip button functionality
                                      },
                                      child: CustomImageView(
                                        imagePath: ImageConstant.imgTipbtn,
                                        height: 60.v,
                                        width: 60.h,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        : AudiotoimageScreen(
            dtcontainer: dtcontainer,
            params: params,
          );
  }

  /// Section Widget
  Widget _buildOptionGRP(BuildContext context, IdentificationProvider provider,
      String type, dynamic dtcontainer, String params) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Changed from Row to Column for portrait mode
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                padding: EdgeInsets.all(1.h),
                child: Stack(
                  
                  children: [
                
                    if (type == "WordToFig")
                      Center(
                        child: Text(
                          dtcontainer.getImageUrl(),
                          style: TextStyle(fontSize: 90),
                        ),
                      )
                    else
                      CustomImageView(
                        imagePath: dtcontainer.getImageUrl(),
                        radius: BorderRadiusStyle.roundedBorder15,
                      ),
                  ],
                ),
              ),
            
              Container(
                height: MediaQuery.of(context).size.height * 0.4, // Adjusted height for portrait
                child: buildDynamicOptions(type, provider, dtcontainer, params),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDynamicOptions(String quizType, IdentificationProvider provider,
      dynamic dtcontainer, String params) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int currentExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[currentExerciseIndex];
    dynamic dtcontainer = obj[1] as dynamic;

    switch (quizType) {
      case "ImageToAudio":
        return dtcontainer.getAudioList().length <= 4
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0), // Adjust padding as needed
                child: Container(
                    height: MediaQuery.of(context).size.height *
                        0.4, // Adjust height as needed
                    width: MediaQuery.of(context).size.width,
                    // Adjusted for portrait mode
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (dtcontainer.getAudioList().length <= 4)
                          ...List.generate(dtcontainer.getAudioList().length,
                              (index) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.08,
                            margin: EdgeInsets.only(bottom: 4.v),
                              child: OptionWidget(
                                triggerAnimation: (value) {
                                  _triggerAnimation(value);
                                },
                                child: AudioWidget(
                                  audioLinks: [
                                    dtcontainer.getAudioList()[index],
                                  ],
                                ),
                                isCorrect: () {
                                  bool isCorrect = dtcontainer
                                          .getCorrectOutput() ==
                                      dtcontainer.getAudioList()[index];

                                  var data_pro =
                                      Provider.of<ExerciseProvider>(
                                          context,
                                          listen: false);
                                  if (isCorrect) {
                                    data_pro.incrementLevel(
                                        currentExerciseIndex);

                                    if (data["completedAt"] == null) {
                                      UserData(
                                              uid: FirebaseAuth.instance
                                                  .currentUser!.uid)
                                          .updateExerciseData(
                                            euid: data["uid"],
                                            date: data["date"],
                                          )
                                          .then((value) => print(
                                              "Exercise data updated"));
                                    }
                                  }

                                  return isCorrect;
                                },
                              ),
                            );
                          }),
                      ],
                    )),
              )
            : SizedBox();

      case "FigToWord":
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (dtcontainer.getTextList().length <= 4)
                          ...List.generate(
                            dtcontainer.getTextList().length ~/ 2 + 
                            dtcontainer.getTextList().length % 2, // Calculate rows needed
                            (rowIndex) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 2.v),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Create 2 items per row (if available)
                                    ...List.generate(
                                      2,
                                      (colIndex) {
                                        final index = rowIndex * 2 + colIndex;
                                        if (index < dtcontainer.getTextList().length) {
                                          return Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 5.h),
                                              child: OptionWidget(
                                                triggerAnimation: (value) {
                                                  _triggerAnimation(value);
                                                },
                                                child: TextContainer(
                                                  text: dtcontainer.getTextList()[index],
                                                ),
                                                isCorrect: () {
                                                  bool isCorrect = dtcontainer
                                                          .getCorrectOutput() ==
                                                      dtcontainer.getTextList()[index];

                                                  var data_pro =
                                                      Provider.of<ExerciseProvider>(
                                                          context,
                                                          listen: false);
                                                  if (isCorrect) {
                                                    data_pro.incrementLevel(
                                                        currentExerciseIndex);
                                                    if (data["completedAt"] == null) {
                                                      UserData(
                                                              uid: FirebaseAuth.instance
                                                                  .currentUser!.uid)
                                                          .updateExerciseData(
                                                            euid: data["uid"],
                                                            date: data["date"],
                                                          )
                                                          .then((value) => print(
                                                              "Exercise data updated"));
                                                    }
                                                  }

                                                  return isCorrect;
                                                },
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Expanded(child: SizedBox());
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );

      case "WordToFig":
        debugPrint("entering in the word to fig section");
        return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (dtcontainer.getImageUrlList().length <= 4)
                  ...List.generate(
                    dtcontainer.getImageUrlList().length ~/ 2 + 
                    dtcontainer.getImageUrlList().length % 2, // Calculate rows needed
                    (rowIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Create 2 items per row (if available)
                          ...List.generate(
                            2,
                            (colIndex) {
                              final index = rowIndex * 2 + colIndex;
                              if (index < dtcontainer.getImageUrlList().length) {
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.h),
                                    child: OptionWidget(
                                      triggerAnimation: (value) {
                                        _triggerAnimation(value);
                                      },
                                      child: ImageWidget(
                                        imagePath: dtcontainer.getImageUrlList()[index],
                                      ),
                                      isCorrect: () {
                                        bool isCorrect =
                                            dtcontainer.getCorrectOutput() ==
                                                dtcontainer.getImageUrlList()[index];

                                        var data_pro = Provider.of<ExerciseProvider>(
                                            context,
                                            listen: false);
                                        if (isCorrect) {
                                          data_pro.incrementLevel(currentExerciseIndex);
                                          if (data["completedAt"] == null) {
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
                                        }

                                        return isCorrect;
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                return Expanded(child: SizedBox());
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ));

      default:
        return Container();
    }
  }
}