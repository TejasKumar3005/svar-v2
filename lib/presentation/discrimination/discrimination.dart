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

  // **Step 1: Define a list to hold all GlobalKeys from OptionWidgets**
  final List<GlobalKey> optionKeys = [];

  // **Optional: TutorialCoachMark instance**

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

    // **Optional: Initialize Tutorial after a slight delay to ensure keys are assigned**
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize tutorial if needed
      // _showTutorial(); // Uncomment if implementing tutorials
    });
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
      body: Container(
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
            // **Pass the optionKeys list to the discriminationOptions method**
            discriminationOptions(type, data, dtcontainer, optionKeys),
          ],
        ),
      ),
    );
  }

  Widget discriminationOptions(String type, Map<String, dynamic> d,
      dynamic dtcontainer, List<GlobalKey> optionKeys) {
    switch (type) {
      case "DiffSounds":
        var data = DiffSounds.fromJson(d);
        return DiffSoundsW(data, dtcontainer, optionKeys);
      case "OddOne":
        var data = OddOne.fromJson(d);
        return OddOneW(data, dtcontainer, optionKeys);
      case "DiffHalf":
        var data = DiffHalf.fromJson(d);
        return DiffHalfW(data, dtcontainer, optionKeys);
      case "MaleFemale":
        var data = MaleFemale.fromJson(d);
        return MaleFemaleW(data, dtcontainer, optionKeys);
      default:
        return Container();
    }
  }

  Widget MaleFemaleW(
      MaleFemale maleFemale, dynamic dtcontainer, List<GlobalKey> optionKeys) {
    // **Step 2: Assign keys from optionKeys list**
    // Ensure the list has enough keys
    while (optionKeys.length <= 3) {
      optionKeys.add(GlobalKey());
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
                // **Assign the first key from the list**
                optionKey: optionKeys[1],
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
                // **Assign the second key from the list**
                optionKey: optionKeys[2],
                tutorialOrder: 3,
                align: ContentAlign.ontop,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget Artboard(String image) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.v),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFDCFBFF),
            Color(0xFFDBEBEC),
            Color(0xFFCEEAE7),
            Color(0xFFC1E2DE),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white,
          width: 5,
        ),
      ),
      child: Stack(
        children: [
          CustomImageView(
            width: 100,
            height: 100,
            fit: BoxFit.contain,
            imagePath: image,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: CustomImageView(
              width: 40,
              height: 40,
              fit: BoxFit.contain,
              imagePath: "assets/images/shine.png",
            ),
          ),
        ],
      ),
    );
  }

  Widget DiffHalfW(
      DiffHalf diffHalf, dynamic dtcontainer, List<GlobalKey> optionKeys) {
    // **Step 2: Assign keys from optionKeys list**
    // Ensure the list has enough keys
    while (optionKeys.length <= 2) {
      optionKeys.add(GlobalKey());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
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
          // **Assign the third key from the list**
          optionKey: optionKeys[1],
          tutorialOrder: 2,
          align: ContentAlign.ontop,
        ),
      ],
    );
  }

  Widget DiffSoundsW(
      DiffSounds diffSounds, dynamic dtcontainer, List<GlobalKey> optionKeys) {
    // **Determine the number of OptionWidgets needed**
    int numberOfOptions = dtcontainer.getVideoUrls().length;

    // **Ensure the optionKeys list has enough keys**
    while (optionKeys.length < numberOfOptions) {
      optionKeys.add(GlobalKey());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (dtcontainer.getVideoUrls().length <= 4)
              ...List.generate(dtcontainer.getVideoUrls().length, (index) {
                return Row(
                  children: [
                    // **Assign keys from the list**
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
                      align: ContentAlign.onside,
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
                        provider.userModel.toJson()["levelMap"]
                            ["Discrimination"]!) {
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
              optionKey: optionKeys[numberOfOptions],
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
                        provider.userModel.toJson()["levelMap"]
                            ["Discrimination"]!) {
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
                return dtcontainer.getSame();
              },
              // **Assign the next key from the list**
              optionKey: optionKeys[numberOfOptions + 1],
              tutorialOrder: numberOfOptions + 2,
              align: ContentAlign.ontop,
            ),
          ],
        )
      ],
    );
  }

  Widget OddOneW(
      OddOne oddOne, dynamic dtcontainer, List<GlobalKey> optionKeys) {
    int numberOfOptions = oddOne.video_url.length;

    // **Ensure the optionKeys list has enough keys**
    while (optionKeys.length < numberOfOptions) {
      optionKeys.add(GlobalKey());
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
                  optionKey: optionKeys[0],
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
                  optionKey: optionKeys[1],
                  tutorialOrder: 2,
                  align: ContentAlign.ontop,
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
                  optionKey: optionKeys[0],
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
                  optionKey: optionKeys[1],
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
                  optionKey: optionKeys[2],
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
                  optionKey: optionKeys[0],
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
                  optionKey: optionKeys[1],
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
                  optionKey: optionKeys[2],
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
                  optionKey: optionKeys[3],
                  tutorialOrder: 4,
                  align: ContentAlign.onside,
                ),
              ],
            ),
          ],
        );
    }
  }
}
