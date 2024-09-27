import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
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


  }

  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
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
                dtcontainer), // Pass dtcontainer as an argument here
          ],
        ),
      ),
    );
  }

  Widget discriminationOptions(
      String type, Map<String, dynamic> d, dynamic dtcontainer) {
  
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
    var provider = Provider.of<UserDataProvider>(context, listen: false);
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AudioWidget(
          audioLinks: [
            dtcontainer.getVideoUrl()[0], // Use dtcontainer here
          ],
        ),
        SizedBox(
          height: 20.v,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (dtcontainer.getCorrectOutput == "female") {
                  // dtcontainer usage
                  print("Correct");
                  // if (obj!["level"] >
                  //     provider.userModel.toJson()["levelMap"]
                  //         ["Discrimination"]!) {
                  //   UserData(buildContext: context)
                  //       .incrementLevelCount("Discrimination")
                  //       .then((value) {});
                  // }

                  _overlayEntry = celebrationOverlay(context, () {
                    _overlayEntry?.remove();
                  });
                  Overlay.of(context).insert(_overlayEntry!);
                }
              },
              child: Artboard("assets/images/female.png"),
            ),
            SizedBox(
              width: 20.h,
            ),
            GestureDetector(
              onTap: () {
                if (dtcontainer.getCorrectOutput == "male") {
                  // dtcontainer usage
                  print("Correct");
                  // if (obj!["level"] >
                  //     provider.userModel.toJson()["levelMap"]
                  //         ["Discrimination"]!) {
                  //   UserData(buildContext: context)
                  //       .incrementLevelCount("Discrimination")
                  //       .then((value) {});
                  // }
                  _overlayEntry = celebrationOverlay(context, () {
                    _overlayEntry?.remove();
                  });
                  Overlay.of(context).insert(_overlayEntry!);
                }
              },
              child: Artboard("assets/images/male.png"),
            ),
          ],
        ),
        SizedBox(
          height: 20.v,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImageView(
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              imagePath: "assets/images/half_mascot.png",
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
          audioLinks: [
            dtcontainer.getVideoUrls(),
          ],
        ),
        // SizedBox(
        //   height: 20.v,
        // ),
        // Container(
        //   height: 40,
        //   width: MediaQuery.of(context).size.width * 0.6,
        //   child: Center(
        //     child: SliderTheme(
        //       data: SliderTheme.of(context).copyWith(
        //         activeTrackColor: PrimaryColors().blue20001,
        //         inactiveTrackColor: Colors.white,
        //         trackHeight: 20.0,
        //         thumbShape: RectangularImageThumb(
        //           thumbWidth: 50.0,
        //           thumbHeight: 50.0,
        //           thumbImagePath: 'assets/images/thumb.png',
        //         ),
        //         thumbColor: PrimaryColors().orange800,
        //         overlayColor: Colors.orange.withOpacity(0.2),
        //         overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
        //       ),
        //       child: Slider(
        //         value: currentProgress,
        //         onChanged: (value) {},
        //         min: 0.0,
        //         max: 10.0,
        //       ),
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 20.v,
        ),
        OptionButton(
          type: ButtonType.Change,
          onPressed: () {
            List<double> total_length = _childKey.currentState!.lengths;
            double ans = total_length[0] / (total_length[1]+total_length[0]);
            if (_childKey.currentState!.progress > ans && _childKey.currentState!.progress < ans + 0.1) {
              // if (obj!["level"] >
              //     provider.userModel.toJson()["levelMap"]["Discrimination"]!) {
              //   UserData(buildContext: context)
              //       .incrementLevelCount("Discrimination")
              //       .then((value) {});
              // }
              _overlayEntry = celebrationOverlay(context, () {
                _overlayEntry?.remove();
              });
              Overlay.of(context).insert(_overlayEntry!);
            }
          },
        ),
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
                    if (dtcontainer.getSame()) {
                      // if (obj!["level"] >
                      //     provider.userModel.toJson()["levelMap"]
                      //         ["Discrimination"]!) {
                      //   UserData(buildContext: context)
                      //       .incrementLevelCount("Discrimination")
                      //       .then((value) {});
                      // }
                    }
                  }),
              isCorrect: () {
                return dtcontainer.getSame();
              },
            ),
            SizedBox(
              width: 20.h,
            ),
            OptionWidget(
              child: OptionButton(
                  type: ButtonType.Diff,
                  onPressed: () {
                    if (!dtcontainer.getSame()) {
                      // if (obj!["level"] >
                      //     provider.userModel.toJson()["levelMap"]
                      //         ["Discrimination"]!) {
                      //   UserData(buildContext: context)
                      //       .incrementLevelCount("Discrimination")
                      //       .then((value) {});
                      // }
                    }
                  }),
              isCorrect: () {
                return !dtcontainer.getSame();
              },
            ),
          ],
        )
      ],
    );
  }

  Widget OddOneW(OddOne oddOne, dynamic dtcontainer) {
    var provider = Provider.of<UserDataProvider>(context, listen: false);

    switch (oddOne.video_url.length) {
      case 2:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [
                      dtcontainer.getVideoUrls()[0],
                    ],
                  ),
                  isCorrect: () {
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
          children: [
            Row(
              children: [
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [
                      dtcontainer.getVideoUrls()[0],
                    ],
                  ),
                  isCorrect: () {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [
                      dtcontainer.getVideoUrls()[2],
                    ],
                  ),
                  isCorrect: () {
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
          children: [
            Row(
              children: [
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [
                      dtcontainer.getVideoUrls()[0],
                    ],
                  ),
                  isCorrect: () {
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
              children: [
                OptionWidget(
                  child: AudioWidget(
                    audioLinks: [
                      dtcontainer.getVideoUrls()[2],
                    ],
                  ),
                  isCorrect: () {
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

//   void setupTimer(List<String> audioUrls) {
//     playTimer?.cancel(); // Cancel any existing timer
//     playTimer = Timer.periodic(Duration(seconds: 5), (timer) {
//       currentIndex++;
//       if (currentIndex < audioUrls.length) {
//         playAudio.playMusic(audioUrls[currentIndex], "mp3", false);
//       } else {
//         timer.cancel();
//         playAudio.stopMusic();
//       }
//     });
//   }

//   Widget _buildOption(
//       {String? text,
//       required Color color,
//       required int index,
//       required List<String> audio,
//       required dynamic correctOutput,
//       String? type}) {
//     {
//       var obj =
//           ModalRoute.of(context)?.settings.arguments as List< dynamic>;

//       var provider = Provider.of<UserDataProvider>(context, listen: false);
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Visibility(
//             visible: text == null ? false : true,
//             child: Text(
//               text! + ")",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 10.h,
//           ),
//           GestureDetector(
//             onTap: () {
//               if (type == "DiffSounds" || type == "MaleFemale") {
//                 return;
//               }

//               if (audio[index] == correctOutput) {
//                 print("Correct");
//                 // if (obj["level"] >
//                 //     provider.userModel.toJson()["levelMap"]
//                 //         ["Discrimination"]!) {
//                 //   UserData(buildContext: context)
//                 //       .incrementLevelCount("Discrimination");
//                 // }
//                 _overlayEntry = celebrationOverlay(context, () {
//                   _overlayEntry?.remove();
//                 });
//                 Overlay.of(context).insert(_overlayEntry!);
//               }

//               setState(() {
//                 selectedOption = index;
//               });
//             },
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.4,
//               padding: EdgeInsets.symmetric(
//                 horizontal: 3.h,
//                 vertical: 5.v,
//               ),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: selectedOption != index
//                       ? color
//                       : PrimaryColors().green30001,
//                   border: Border.all(
//                     color: Colors.black,
//                     width: 3,
//                   )),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       if (type == "DiffHalf") {
//                         if (playAudio.audioPlayer.state ==
//                             PlayerState.playing) {
//                           playAudio.audioPlayer.pause();
//                         } else {
//                           playAudio.audioPlayer.onPositionChanged
//                               .listen((position) {
//                             setState(() {
//                               currentProgress = position.inSeconds.toDouble();
//                             });
//                           });
//                           File? file;
//                           CachingManager()
//                               .getCachedFile(audios[index])
//                               .then((value) {
//                             file = value;
//                           });
//                           playAudio.playMusicFromFile(file!, "mp3", false);

//                           setupTimer(audio);
//                         }
//                       } else {
//                         File? file;
//                         CachingManager()
//                             .getCachedFile(audios[index])
//                             .then((value) {
//                           file = value;
//                         });
//                         playAudio.playMusicFromFile(file!, "mp3", false);
//                       }
//                     },
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CustomButton(
//                           type: ButtonType.ImagePlay,
//                           onPressed: () {},
//                         ),
//                         SizedBox(
//                           width: 10.h,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 50,
//                     width: 8,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10.h,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       if (type == "OddOne") {
//                         setState(() {
//                           selectedOption = index;
//                         });
//                       }
//                     },
//                     child: CustomImageView(
//                       width: MediaQuery.of(context).size.width * 0.4 - 98,
//                       height: 60,
//                       fit: BoxFit.fill,
//                       imagePath: "assets/images/spectrum.png",
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }
