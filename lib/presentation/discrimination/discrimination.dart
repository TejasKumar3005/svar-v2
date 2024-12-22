import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/network/cacheManager.dart';

import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/identification_screen/celebration_overlay.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/utils/playAudio.dart';
import './customthumb.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/widgets/audio_widget.dart';
import 'package:svar_new/presentation/phoneme_level_one/level_one.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:svar_new/database/userController.dart';

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
  late UserData userData;
  int selectedOption = -1;
  List<double> samples = [];
  OverlayEntry? _overlayEntry;

  bool isPlaying = false;

  int currentIndex = 0;
  double currentProgress = 0.0;
  List<double> total_length = [];

  void getAudioProgress() {
    setState(() {
      currentProgress = _childKey.currentState!.progress;
    });
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
            SizedBox(
              height: 20.v,
            ),
            discriminationOptions(type, data,
                dtcontainer), 
          ],
        ),
      ),
    );
  }

  Widget discriminationOptions(
      String type, Object d, dynamic dtcontainer) {
    switch (type) {
      case "DiffSounds":
      
        return DiffSoundsW(d as DiffSounds, d);
      case "OddOne":
      
        return OddOneW(d as OddOne, d);
      case "DiffHalf":
      
        return DiffHalfW(d as DiffHalf, d);
      case "MaleFemale":
      
        return MaleFemaleW(d as MaleFemale, d);
      default:
        return Container();
    }
  }

  Widget MaleFemaleW(MaleFemale maleFemale, dynamic dtcontainer) {
    // print("MaleFemaleW ${dtcontainer.getVideoUrl()}");
    print("MaleFemaleW ${dtcontainer}");
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AudioWidget(
          audioLinks: dtcontainer.getVideoUrl(),
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
                  if (dtcontainer.getCorrectOutput() == "female") {
                    userData.incrementLevelCount("Discrimination", level);
                
                  }
                  return dtcontainer.getCorrectOutput() == "female";
                },
              ),
            ),
            Expanded(
              child: OptionWidget(
                child: ImageWidget(imagePath: "assets/images/male.png"),
                isCorrect: () {
                  if (dtcontainer.getCorrectOutput() == "male") {
                    userData.incrementLevelCount("Discrimination", level);
                  
                  }
                  return dtcontainer.getCorrectOutput() == "male";
                },
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

  Widget DiffHalfW(DiffHalf diffHalf, dynamic dtcontainer) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AudioWidget(
          key: _childKey,
          audioLinks: dtcontainer.getVideoUrls(),
        ),
        SizedBox(
          height: 20.v,
        ),
        OptionWidget(
            child: OptionButton(type: ButtonType.Change, onPressed: () {}),
            isCorrect: () {
              List<double> total_length = _childKey.currentState!.lengths;
              double ans =
                  total_length[0] / (total_length[1] + total_length[0]);
              print(
                  "ans is $ans current progress is ${_childKey.currentState!.progress}");
              if (_childKey.currentState!.progress > ans &&
                  _childKey.currentState!.progress < ans + 0.1) {
                userData.incrementLevelCount("Discrimination", level);
                
                return true;
              } else {
                return false;
              }
            })
      ],
    );
  }

  Widget DiffSoundsW(DiffSounds diffSounds, dynamic dtcontainer) {
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
                    AudioWidget(
                      audioLinks: [
                        dtcontainer.getVideoUrls()[index],
                      ],
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
                            .incrementLevelCount("Discrimination", level)
                            .then((value) {});
                             
                      }
                   
                    }
                  }),
              isCorrect: () {
                return !dtcontainer.getSame();
              },
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
                        UserData(buildContext: context)
                            .incrementLevelCount("Discrimination", level)
                            .then((value) {});
                      }
                      
                    }
                  }),
              isCorrect: () {
                return dtcontainer.getSame();
              },
            ),
          ],
        )
      ],
    );
  }

  Widget OddOneW(OddOne oddOne, dynamic dtcontainer) {
    switch (oddOne.video_url.length) {
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
                    audioLinks: [
                      dtcontainer.getVideoUrls()[0],
                    ],
                  ),
                  isCorrect: () {
                    if (dtcontainer.getVideoUrls()[0] ==
                        dtcontainer.getCorrectOutput()) {
                      userData.incrementLevelCount("Discrimination", level);
                     
                    }
                    return dtcontainer.getVideoUrls()[0] ==
                        dtcontainer.getCorrectOutput();
                  },
                ),
                SizedBox(
                  width: 20.h,
                ),
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [
                      dtcontainer.getVideoUrls()[1],
                    ],
                  ),
                  isCorrect: () {
                    if (dtcontainer.getVideoUrls()[1] ==
                        dtcontainer.getCorrectOutput()) {
                      userData.incrementLevelCount("Discrimination", level);
                     
                    }
                    return dtcontainer.getVideoUrls()[1] ==
                        dtcontainer.getCorrectOutput();
                  },
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
                    audioLinks: [
                      dtcontainer.getVideoUrls()[0],
                    ],
                  ),
                  isCorrect: () {
                    if (dtcontainer.getVideoUrls()[0] ==
                        dtcontainer.getCorrectOutput()) {
                      userData.incrementLevelCount("Discrimination", level);
                   
                    }
                    return dtcontainer.getVideoUrls()[0] ==
                        dtcontainer.getCorrectOutput();
                  },
                ),
                SizedBox(
                  width: 20.h,
                ),
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [
                      dtcontainer.getVideoUrls()[1],
                    ],
                  ),
                  isCorrect: () {
                    if (dtcontainer.getVideoUrls()[1] ==
                        dtcontainer.getCorrectOutput()) {
                      userData.incrementLevelCount("Discrimination", level);
                     
                    }
                    return dtcontainer.getVideoUrls()[1] ==
                        dtcontainer.getCorrectOutput();
                  },
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
                    audioLinks: [
                      dtcontainer.getVideoUrls()[2],
                    ],
                  ),
                  isCorrect: () {
                    if (dtcontainer.getVideoUrls()[2] ==
                        dtcontainer.getCorrectOutput()) {
                      userData.incrementLevelCount("Discrimination", level);
                    
                    }
                    return dtcontainer.getVideoUrls()[2] ==
                        dtcontainer.getCorrectOutput();
                  },
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
                    audioLinks: [
                      dtcontainer.getVideoUrls()[0],
                    ],
                  ),
                  isCorrect: () {
                    if (dtcontainer.getVideoUrls()[0] ==
                        dtcontainer.getCorrectOutput()) {
                      userData.incrementLevelCount("Discrimination", level);
                     
                    }
                    return dtcontainer.getVideoUrls()[0] ==
                        dtcontainer.getCorrectOutput();
                  },
                ),
                SizedBox(
                  width: 20.h,
                ),
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [
                      dtcontainer.getVideoUrls()[1],
                    ],
                  ),
                  isCorrect: () {
                    if (dtcontainer.getVideoUrls()[1] ==
                        dtcontainer.getCorrectOutput()) {
                      userData.incrementLevelCount("Discrimination", level);
                       
                    }
                    return dtcontainer.getVideoUrls()[1] ==
                        dtcontainer.getCorrectOutput();
                  },
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
                    audioLinks: [
                      dtcontainer.getVideoUrls()[2],
                    ],
                  ),
                  isCorrect: () {
                    if (dtcontainer.getVideoUrls()[2] ==
                        dtcontainer.getCorrectOutput()) {
                      userData.incrementLevelCount("Discrimination", level);
                       
                    }
                    return dtcontainer.getVideoUrls()[2] ==
                        dtcontainer.getCorrectOutput();
                  },
                ),
                SizedBox(
                  width: 20.h,
                ),
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [
                      dtcontainer.getVideoUrls()[3],
                    ],
                  ),
                  isCorrect: () {
                    if (dtcontainer.getVideoUrls()[3] ==
                        dtcontainer.getCorrectOutput()) {
                      userData.incrementLevelCount("Discrimination", level);
                       
                    }
                    return dtcontainer.getVideoUrls()[3] ==
                        dtcontainer.getCorrectOutput();
                  },
                ),
              ],
            ),
          ],
        );
    }
  }
}
