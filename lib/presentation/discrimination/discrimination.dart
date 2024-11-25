// discrimination.dart

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/network/cacheManager.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/Identification_screen/celebration_overlay.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/utils/playAudio.dart';
import './customthumb.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/widgets/audio_widget.dart';
import 'package:svar_new/widgets/tutorial_coach_mark/lib/tutorial_coach_mark.dart';
import 'package:rive/rive.dart'; // Add this for the animation

class Discrimination extends StatefulWidget {
  const Discrimination({
    Key? key,
  }) : super(key: key);

  @override
  State<Discrimination> createState() => _DiscriminationState();

  static Widget builder(BuildContext context) {
    return const Discrimination();
  }
}

class _DiscriminationState extends State<Discrimination> {
  final GlobalKey<AudioWidgetState> _childKey = GlobalKey<AudioWidgetState>();

  int selectedOption = -1;
  List<double> samples = [];
  OverlayEntry? _overlayEntry;

  bool isPlaying = false;

  int currentIndex = 0;
  double currentProgress = 0.0;
  List<double> total_length = [];

  // Define a list to hold all GlobalKeys from OptionWidgets
  final List<GlobalKey<OptionWidgetState>> optionKeys = [];

  // TutorialCoachMark instance
  TutorialCoachMark? tutorialCoachMark;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  int level = 0;

  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
    level = obj[4] as int;

    Map<String, dynamic> data = obj[1] as Map<String, dynamic>;
    dynamic dtcontainer = obj[2] as dynamic;

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/discri_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 15.h,
              vertical: 10.v,
            ),
            child: Column(
              children: [
                DisciAppBar(context),
                SizedBox(
                  height: 26.v,
                ),
                Visibility(
                  visible: type != "MaleFemale" && type != "DiffHalf",
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.symmetric(
                      vertical: 5.v,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                        type == "OddOne"
                            ? ("Pick the Odd One Out").toUpperCase()
                            : ("SAME OR DIFFERENT?").toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.v,
                ),
                // Pass the optionKeys list to the discriminationOptions method
                discriminationOptions(type, data, dtcontainer),
              ],
            ),
          ),
          // Tip Button
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                // Initialize and show the tutorial
                _initTutorial();
                showTutorial();
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
    );
  }

  Widget discriminationOptions(String type, Map<String, dynamic> d, dynamic dtcontainer) {
    switch (type) {
      case "DiffSounds":
        var data = DiffSounds.fromJson(d);
        return DiffSoundsW(data, dtcontainer);
      case "OddOne":
        var data = OddOne.fromJson(d);
        return OddOneW(data, dtcontainer);
      case "DiffHalf":
        var data = DiffHalf.fromJson(d);
        return DiffHalfW(data, dtcontainer);
      case "MaleFemale":
        var data = MaleFemale.fromJson(d);
        return MaleFemaleW(data, dtcontainer);
      default:
        return Container();
    }
  }

  Widget MaleFemaleW(MaleFemale maleFemale, dynamic dtcontainer) {
    // Assign keys from optionKeys list
    // Ensure the list has enough keys
    while (optionKeys.length < 3) {
      optionKeys.add(GlobalKey<OptionWidgetState>());
    }

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OptionWidget(
          child: AudioWidget(
            audioLinks: dtcontainer.getAudioUrl(),
          ),
          isCorrect: () => false,
          optionKey: optionKeys[0], // Apply key
          tutorialOrder: 1,
          align: ContentAlign.onside,
        ),
        SizedBox(
          height: 20.v,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: OptionWidget(
                child: ImageWidget(imagePath: "assets/images/female.png"),
                isCorrect: () {
                  return dtcontainer.getCorrectOutput() == "female";
                },
                optionKey: optionKeys[1], // Assign the key
                tutorialOrder: 2,
                align: ContentAlign.ontop,
              ),
            ),
            Expanded(
              child: OptionWidget(
                child: ImageWidget(imagePath: "assets/images/male.png"),
                isCorrect: () {
                  return dtcontainer.getCorrectOutput() == "male";
                },
                optionKey: optionKeys[2], // Assign the key
                tutorialOrder: 3,
                align: ContentAlign.ontop,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget DiffHalfW(DiffHalf diffHalf, dynamic dtcontainer) {
    // Assign keys from optionKeys list
    // Ensure the list has enough keys
    while (optionKeys.length < 2) {
      optionKeys.add(GlobalKey<OptionWidgetState>());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OptionWidget(
          child: AudioWidget(
            audioLinks: dtcontainer.getVideoUrls(),
          ),
          isCorrect: () => false,
          optionKey: optionKeys[0], // Apply key
          tutorialOrder: 1,
          align: ContentAlign.onside,
        ),
        SizedBox(
          height: 20.v,
        ),
        OptionWidget(
          child: OptionButton(type: ButtonType.Change, onPressed: () {}),
          isCorrect: () {
            List<double> total_length = _childKey.currentState!.lengths;
            double ans = total_length[0] / (total_length[1] + total_length[0]);
            print(
                "ans is $ans current progress is ${_childKey.currentState!.progress}");
            if (_childKey.currentState!.progress > ans &&
                _childKey.currentState!.progress < ans + 0.1) {
              return true;
            } else {
              return false;
            }
          },
          optionKey: optionKeys[1], // Assign the key
          tutorialOrder: 2,
          align: ContentAlign.ontop,
        ),
      ],
    );
  }

  Widget DiffSoundsW(DiffSounds diffSounds, dynamic dtcontainer) {
    // Determine the number of OptionWidgets needed
    int numberOfOptions = dtcontainer.getVideoUrls().length;

    // Ensure the optionKeys list has enough keys
    while (optionKeys.length < numberOfOptions + 2) {
      optionKeys.add(GlobalKey<OptionWidgetState>());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (dtcontainer.getVideoUrls().length <= 4)
              ...List.generate(dtcontainer.getVideoUrls().length, (index) {
                  Map<String,GlobalKey<OptionWidgetState>> keymap = {
      
    };
      keymap["option_0"] = new GlobalKey();
                return Row(
                  children: [
                    OptionWidget(
                      child: AudioWidget(
                        audioLinks: [dtcontainer.getVideoUrls()[index]],
                      ),
                      isCorrect: () {
                        return dtcontainer.getVideoUrls()[index] ==
                            dtcontainer.getCorrectOutput();
                      },
                      optionKey: optionKeys[index],
                      tutorialOrder: index + 1,
                      align: ContentAlign.ontop,
                    ),
                    SizedBox(width: 20), // Adds gap between each OptionWidget
                  ],
                );
              }),
          ],
        ),
        SizedBox(
          height: 20.v,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OptionWidget(
              child: OptionButton(
                type: ButtonType.Same,
                onPressed: () {
                  var provider =
                      Provider.of<UserDataProvider>(context, listen: false);
                  if (dtcontainer.getSame()) {
                    if (level >
                        provider.userModel.toJson()["levelMap"]["Discrimination"]!) {
                      UserData(buildContext: context)
                          .incrementLevelCount("Discrimination")
                          .then((value) {});
                    }
                  }
                },
              ),
              isCorrect: () {
                return dtcontainer.getSame();
              },
              optionKey: optionKeys[numberOfOptions], // Assign the key
              tutorialOrder: numberOfOptions + 1,
              align: ContentAlign.ontop,
            ),
            SizedBox(
              width: 20.h,
            ),
            OptionWidget(
              child: OptionButton(
                type: ButtonType.Diff,
                onPressed: () {
                  var provider =
                      Provider.of<UserDataProvider>(context, listen: false);
                  if (!dtcontainer.getSame()) {
                    if (level >
                        provider.userModel.toJson()["levelMap"]["Discrimination"]!) {
                      AnalyticsService().logEvent("level_complete",
                          {"name": "Discrimination", "level": level});

                      UserData(buildContext: context)
                          .incrementLevelCount("Discrimination")
                          .then((value) {});
                    }
                  }
                },
              ),
              isCorrect: () {
                return !dtcontainer.getSame();
              },
              optionKey: optionKeys[numberOfOptions + 1], // Assign the key
              tutorialOrder: numberOfOptions + 2,
              align: ContentAlign.ontop,
            ),
          ],
        )
      ],
    );
  }

  Widget OddOneW(OddOne oddOne, dynamic dtcontainer) {
    int numberOfOptions = oddOne.video_url.length;

    // Ensure the optionKeys list has enough keys
    while (optionKeys.length < numberOfOptions) {
      optionKeys.add(GlobalKey<OptionWidgetState>());
    }

    switch (numberOfOptions) {
      case 2:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the column vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center the column horizontally
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the row horizontally
              children: [
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [dtcontainer.getVideoUrls()[0]],
                  ),
                  isCorrect: () {
                    return dtcontainer.getVideoUrls()[0] ==
                        dtcontainer.getCorrectOutput();
                  },
                  optionKey: optionKeys[0], // Assign the key
                  tutorialOrder: 1,
                  align: ContentAlign.onside,
                ),
                SizedBox(
                  width: 20.h,
                ),
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [dtcontainer.getVideoUrls()[1]],
                  ),
                  isCorrect: () {
                    return dtcontainer.getVideoUrls()[1] ==
                        dtcontainer.getCorrectOutput();
                  },
                  optionKey: optionKeys[1], // Assign the key
                  tutorialOrder: 2,
                  align: ContentAlign.onside,
                ),
              ],
            ),
          ],
        );
      case 3:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the column vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center the column horizontally
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the row horizontally
              children: [
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [dtcontainer.getVideoUrls()[0]],
                  ),
                  isCorrect: () {
                    return dtcontainer.getVideoUrls()[0] ==
                        dtcontainer.getCorrectOutput();
                  },
                  optionKey: optionKeys[0], // Assign the key
                  tutorialOrder: 1,
                  align: ContentAlign.onside,
                ),
                SizedBox(
                  width: 20.h,
                ),
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [dtcontainer.getVideoUrls()[1]],
                  ),
                  isCorrect: () {
                    return dtcontainer.getVideoUrls()[1] ==
                        dtcontainer.getCorrectOutput();
                  },
                  optionKey: optionKeys[1], // Assign the key
                  tutorialOrder: 2,
                  align: ContentAlign.onside,
                ),
              ],
            ),
            SizedBox(
              height: 20.v,
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the row horizontally
              children: [
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [dtcontainer.getVideoUrls()[2]],
                  ),
                  isCorrect: () {
                    return dtcontainer.getVideoUrls()[2] ==
                        dtcontainer.getCorrectOutput();
                  },
                  optionKey: optionKeys[2], // Assign the key
                  tutorialOrder: 3,
                  align: ContentAlign.onside,
                ),
              ],
            )
          ],
        );
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the column vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center the column horizontally
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the row horizontally
              children: [
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [dtcontainer.getVideoUrls()[0]],
                  ),
                  isCorrect: () {
                    return dtcontainer.getVideoUrls()[0] ==
                        dtcontainer.getCorrectOutput();
                  },
                  optionKey: optionKeys[0], // Assign the key
                  tutorialOrder: 1,
                  align: ContentAlign.onside,
                ),
                SizedBox(
                  width: 20.h,
                ),
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [dtcontainer.getVideoUrls()[1]],
                  ),
                  isCorrect: () {
                    return dtcontainer.getVideoUrls()[1] ==
                        dtcontainer.getCorrectOutput();
                  },
                  optionKey: optionKeys[1], // Assign the key
                  tutorialOrder: 2,
                  align: ContentAlign.onside,
                ),
              ],
            ),
            SizedBox(
              height: 20.v,
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the row horizontally
              children: [
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [dtcontainer.getVideoUrls()[2]],
                  ),
                  isCorrect: () {
                    return dtcontainer.getVideoUrls()[2] ==
                        dtcontainer.getCorrectOutput();
                  },
                  optionKey: optionKeys[2], // Assign the key
                  tutorialOrder: 3,
                  align: ContentAlign.onside,
                ),
                SizedBox(
                  width: 20.h,
                ),
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [dtcontainer.getVideoUrls()[3]],
                  ),
                  isCorrect: () {
                    return dtcontainer.getVideoUrls()[3] ==
                        dtcontainer.getCorrectOutput();
                  },
                  optionKey: optionKeys[3], // Assign the key
                  tutorialOrder: 4,
                  align: ContentAlign.onside,
                ),
              ],
            ),
          ],
        );
    }
  }

  // Implement the tutorial methods in Discrimination class

  void _initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black.withOpacity(0.5),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("Tutorial finished");
      },
      onSkip: () {
        print("Tutorial skipped");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    for (int i = 0; i < optionKeys.length; i++) {
      final key = optionKeys[i];
      final twidget = key.currentWidget as OptionWidget?;
      if (twidget != null) {
        targets.add(
          TargetFocus(
            identify: "tutorial_step_${i + 1}",
            keyTarget: key,
            contents: [
              TargetContent(
                align: twidget.align,
                builder: (context, controller) {
                  return _buildTutorialContent(
                    "",
                    isCorrect: false,
                    child: twidget.child,
                  );
                },
              ),
            ],
          ),
        );
      }
    }

    // Add a target for the correct option
    for (int i = 0; i < optionKeys.length; i++) {
      final key = optionKeys[i];
      final twidget = key.currentWidget as OptionWidget?;
      if (twidget != null && twidget.isCorrect()) {
        targets.add(
          TargetFocus(
            identify: "correct_option",
            keyTarget: key,
            contents: [
              TargetContent(
                align: ContentAlign.ontop,
                builder: (context, controller) {
                  return _buildTutorialContent(
                    _getCorrectAnswerMessage(1),
                    isCorrect: true,
                    child: twidget.child,
                  );
                },
              ),
            ],
          ),
        );
        break; // Assuming only one correct option
      }
    }

    return targets;
  }

  Widget _buildTutorialContent(String text,
      {required bool isCorrect, required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: RiveAnimation.asset(
              'assets/rive/hand_click.riv',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          if (isCorrect)
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
        ],
      ),
    );
  }

  String _getCorrectAnswerMessage(int step) {
    switch (step) {
      case 1:
        return "This is the correct answer!";
      case 2:
        return "Well done!";
      default:
        return "Great job!";
    }
  }

  void showTutorial() {
    if (tutorialCoachMark != null) {
      tutorialCoachMark!.show(context: context);
    }
  }
}
