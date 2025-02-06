import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart';

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

class _DiscriminationState extends State<ExerciseDiscrimination> {
  final GlobalKey<AudioWidgetState> _childKey = GlobalKey<AudioWidgetState>();
  late UserData userData;
  int selectedOption = -1;
  List<double> samples = [];
  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;
  bool isPlaying = false;

  int currentIndex = 0;
  double currentProgress = 0.0;
  List<double> total_length = [];

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

      // Print all state machines for debugging
      print("\nAll State Machines in artboard:");
      for (var stateMachine in artboard.stateMachines) {
        print("State Machine: ${stateMachine.name}");
      }

      // Get the triggers
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
    // playTimer?.cancel(); // Cancel any ongoing timers
    // _overlayEntry?.remove(); // Remove overlay entry if present
    // playAudio.stopMusic();
    // playAudio.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
  }

  int level = 0;

  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
    level = obj[3] as int;
    Object data = obj[1] as Object;
    dynamic dtcontainer = obj[2] as dynamic;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/discri_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // App Bar with padding
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 10.v),
                child: DisciAppBar(context),
              ),

              // Title section if needed
              if (type != "MaleFemale" && type != "DiffHalf")
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.h),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.symmetric(vertical: 5.v),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                        type == "OddOne"
                            ? ("Pick the odd One Out").toUpperCase()
                            : ("SAME OR DIfferent?").toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                      padding: EdgeInsets.fromLTRB(15.h, 20.v, 15.h, 60.v),
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
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: RiveAnimation.asset(
                                'assets/rive/Celebration_animation.riv',
                                onInit: _onRiveInit,
                                fit: BoxFit.contain,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                        ),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          child: Column(
            children: [
              // Audio section
              Expanded(
                flex: 2,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth *
                            0.4, // Same width ratio as DiffSounds
                        maxHeight: constraints.maxHeight *
                            0.3 // Same height ratio as DiffSounds
                        ),
                    child: AudioWidget(
                      audioLinks: maleFemale.getVideoUrl(),
                    ),
                  ),
                ),
              ),

              // Options section
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    // Female option
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.h),
                        child: OptionWidget(
                          triggerAnimation: (value) {
                            _triggerAnimation(value);
                          },
                          child: ImageWidget(
                              imagePath: "assets/images/female.png"),
                          isCorrect: () {
                            var condition =
                                maleFemale.getCorrectOutput() == "female";
                            if (condition) {
                              data_pro.incrementLevel(startExerciseIndex);
                              if (data["completedAt"] == null) {
                                UserData(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .updateExerciseData(
                                  euid: data["uid"],
                                  date: data["date"],
                                );
                              }
                            }
                           
                            return condition;
                          },
                        ),
                      ),
                    ),
                    // Male option
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.h),
                        child: OptionWidget(
                          triggerAnimation: (value) {
                            _triggerAnimation(value);
                          },
                          child:
                              ImageWidget(imagePath: "assets/images/male.png"),
                          isCorrect: () {
                            var condition =
                                maleFemale.getCorrectOutput() == "male";
                            if (condition) {
                              data_pro.incrementLevel(startExerciseIndex);
                              if (data["completedAt"] == null) {
                                UserData(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .updateExerciseData(
                                  euid: data["uid"],
                                  date: data["date"],
                                );
                              }
                            }
                           
                            return condition;
                          },
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

  Widget DiffHalfW(DiffHalf diffHalf, dynamic dtcontainer) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          child: Column(
            children: [
              // Audio section
              Expanded(
                flex: 4,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.4,
                        maxHeight: constraints.maxHeight * 0.3),
                    child: AudioWidget(
                      key: _childKey,
                      audioLinks: diffHalf.getVideoUrls(),
                    ),
                  ),
                ),
              ),

              // Button section
              Expanded(
                flex: 5,
                child: Center(
                  child: OptionWidget(
                    triggerAnimation: (value) {
                      _triggerAnimation(value);
                    },
                    child:
                        OptionButton(type: ButtonType.Change, onPressed: () {}),
                    isCorrect: () {
                      List<double> total_length =
                          _childKey.currentState!.lengths;
                      double ans =
                          total_length[0] / (total_length[1] + total_length[0]);
                      var condition = _childKey.currentState!.progress.value > ans &&
                          _childKey.currentState!.progress.value < ans + 0.4;

                      if (condition) {
                        data_pro.incrementLevel(startExerciseIndex);
                        if (data["completedAt"] == null) {
                          UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                              .updateExerciseData(
                            euid: data["uid"],
                            date: data["date"],
                          );
                        }
                      }
                      
                      return condition;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget DiffSoundsW(DiffSounds diffSounds, dynamic dtcontainer) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          child: Column(
            children: [
              // Audio section - Two items side by side
              Expanded(
                flex: 4,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First audio widget
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 80.v),
                            child: AudioWidget(
                              audioLinks: [diffSounds.getVideoUrls()[0]],
                            ),
                          ),
                        ),
                      ),
                      // Second audio widget
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 80.v),
                            child: AudioWidget(
                              audioLinks: [diffSounds.getVideoUrls()[1]],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Buttons section - Smaller size
              // Button section with responsive sizing
              Expanded(
                flex: 5,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate relative sizes based on available space
                    final buttonWidth =
                        constraints.maxWidth * 0.2; // 35% of available width
                    final buttonHeight =
                        constraints.maxHeight * 0.5; // 25% of available height

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Same button
                        SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.02),
                            child: OptionWidget(
                              triggerAnimation: (value) {
                                _triggerAnimation(value);
                              },
                              child: OptionButton(
                                  type: ButtonType.Same, onPressed: () {}),
                              isCorrect: () {
                                var condition = !diffSounds.getSame();
                                if (condition) {
                                  data_pro.incrementLevel(startExerciseIndex);
                                }
                                
                                return condition;
                              },
                            ),
                          ),
                        ),

                        SizedBox(
                            width: constraints.maxWidth *
                                0.05), // 5% spacing between buttons

                        // Different button
                        SizedBox(
                          width: buttonWidth,
                          height: buttonHeight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.02),
                            child: OptionWidget(
                              triggerAnimation: (value) {
                                _triggerAnimation(value);
                              },
                              child: OptionButton(
                                  type: ButtonType.Diff, onPressed: () {}),
                              isCorrect: () {
                                var condition = diffSounds.getSame();
                                if (condition) {
                                  data_pro.incrementLevel(startExerciseIndex);
                                  if (data["completedAt"] == null) {
                                    UserData(
                                            uid: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .updateExerciseData(
                                      euid: data["uid"],
                                      date: data["date"],
                                    );
                                  }
                                }
                                
                                return condition;
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget OddOneW(OddOne oddOne, dynamic dtcontainer) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    Widget buildAudioOption(int index) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.4,
                maxHeight: MediaQuery.of(context).size.height *
                    0.3), // Constrain height
            child: OptionWidget(
              triggerAnimation: (value) => _triggerAnimation(value),
              child: AudioWidget(
                audioLinks: [oddOne.getVideoUrls()[index]],
              ),
              isCorrect: () {
                var condition =
                    oddOne.getVideoUrls()[index] == oddOne.getCorrectOutput();

                if (condition) {
                  data_pro.incrementLevel(startExerciseIndex);
                  if (data["completedAt"] == null) {
                    UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateExerciseData(
                      euid: data["uid"],
                      date: data["date"],
                    );
                  }
                }


                return condition;
              },
            ),
          ),
        ),
      );
    }

    Widget buildOptionRow(List<int> indices) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: indices.map((i) => buildAudioOption(i)).toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content;
        switch (oddOne.video_url.length) {
          case 2:
            content = buildOptionRow([0, 1]);
            break;
          case 3:
            content = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: buildOptionRow([0, 1]),
                ),
                Expanded(
                  flex: 1,
                  child: Container(), // Spacer
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Container()), // Left spacer
                      Expanded(
                          flex: 2, child: buildAudioOption(2)), // Center option
                      Expanded(flex: 1, child: Container()), // Right spacer
                    ],
                  ),
                ),
              ],
            );
            break;
          default: // 4 options
            content = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildOptionRow([0, 1]),
                SizedBox(height: 20.v),
                buildOptionRow([2, 3]),
              ],
            );
        }

        return Container(
          height: constraints.maxHeight,
          child: Center(child: content),
        );
      },
    );
  }
}
