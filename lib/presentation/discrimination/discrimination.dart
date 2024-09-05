import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:svar_new/core/app_export.dart';

import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/Identification_screen/celebration_overlay.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/utils/playAudio.dart';
import './customthumb.dart';

class Discrimination extends StatefulWidget {
  final String type; // The type of the quiz
  final Map<String, dynamic> data; // The data for the quiz

  const Discrimination({Key? key, required this.type, required this.data})
      : super(key: key);

  @override
  State<Discrimination> createState() => _DiscriminationState();

  static Widget builder(BuildContext context) {
    // Provide default values for demonstration purposes
    return Discrimination(type: "DiffSounds", data: {});
  }
}

class _DiscriminationState extends State<Discrimination> {
  PlayAudio playAudio = PlayAudio();
  List<String> options = ["A", "B", "C", "D"];
  List<String> audios = [
    "ba.mp3",
    "bha.mp3",
    "cha.mp3",
    "chha.mp3",
  ];
  int selectedOption = -1;
  List<double> samples = [];
  OverlayEntry? _overlayEntry;

  bool isPlaying = false;

  Duration totalDuration = Duration(seconds: 0);
  Duration position = Duration(seconds: 0);
  int currentIndex = 0;
  double currentProgress = 0.0;
  Timer? playTimer;

  @override
  void dispose() {
    playAudio.stopMusic();
    playAudio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              visible: widget.type != "MaleFemale" && widget.type != "DiffHalf",
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
                    widget.type == "OddOne"
                        ? ("Pick the odd One Out").toUpperCase()
                        : ("SAME OR DIferent?").toUpperCase(),
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
            discriminationOptions(
                widget.type, widget.data), // Use the passed widget here
          ],
        ),
      ),
    );
  }

  Widget discriminationOptions(String type, Map<String, dynamic> d) {
    switch (type) {
      case "DiffSounds":
        var data = DiffSounds.fromJson(d);
        return DiffSoundsW(data);
      case "OddOne":
        var data = OddOne.fromJson(d);
        return OddOneW(data);
      case "DiffHalf":
        var data = DiffHalf.fromJson(d);
        return DiffHalfW(data);
      case "MaleFemale":
        var data = MaleFemale.fromJson(d);
        return MaleFemaleW(data);
      default:
        return Container();
    }
  }

  Widget MaleFemaleW(MaleFemale maleFemale) {
    var obj =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var provider = Provider.of<UserDataProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildOption(
            color: PrimaryColors().deepOrangeA200,
            index: 0,
            audio: maleFemale.video_url,
            correctOutput: maleFemale.correct_output,
            type: "MaleFemale"),
        SizedBox(
          height: 20.v,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (maleFemale.correct_output == "female") {
                  print("Correct");
                  if (obj["level"] >
                      provider.userModel.toJson()["levelMap"]
                          ["Discrimination"]!) {
                    UserData(buildContext: context)
                        .incrementLevelCount("Discrimination")
                        .then((value) {});
                  }

                  _overlayEntry = celebrationOverlay(context, () {
                    _overlayEntry?.remove();
                  });
                  Overlay.of(context).insert(_overlayEntry!);
                }
              },
              child: Artboard("female"),
            ),
            SizedBox(
              width: 20.h,
            ),
            GestureDetector(
              onTap: () {
                if (maleFemale.correct_output == "male") {
                  print("Correct");
                  if (obj["level"] >
                      provider.userModel.toJson()["levelMap"]
                          ["Discrimination"]!) {
                    UserData(buildContext: context)
                        .incrementLevelCount("Discrimination")
                        .then((value) {});
                  }
                  _overlayEntry = celebrationOverlay(context, () {
                    _overlayEntry?.remove();
                  });
                  Overlay.of(context).insert(_overlayEntry!);
                }
              },
              child: Artboard("male"),
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

  Widget DiffHalfW(DiffHalf diffHalf) {
      var obj =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var provider = Provider.of<UserDataProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildOption(
            text: "A",
            color: PrimaryColors().deepOrangeA200,
            index: 0,
            audio: diffHalf.video_url,
            correctOutput: diffHalf.correct_output,
            type: "DiffHalf"),
        SizedBox(
          height: 20.v,
        ),
        Container(
          height: 40,

          width: MediaQuery.of(context).size.width *
              0.6, // Adjust this value to control the width of the slider
          child: Center(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor:
                    PrimaryColors().blue20001, // Green part of the slider
                inactiveTrackColor:
                    Colors.white, // Light blue part of the slider
                trackHeight: 20.0,

                thumbShape: RectangularImageThumb(
                  thumbWidth: 50.0, // Set the width of the thumb
                  thumbHeight: 50.0, // Set the height of the thumb
                  thumbImagePath:
                      'assets/images/thumb.png', // Path to the thumb image
                ),
                thumbColor: PrimaryColors().orange800,
                // Orange circle
                overlayColor: Colors.orange
                    .withOpacity(0.2), // Overlay color when dragging
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
              ),
              child: Slider(
                value: currentProgress,
                onChanged: (value) {

                },
                min: 0.0,
                max: 10.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.v,
        ),
        CustomButton(
          type: ButtonType.Change,
          onPressed: () {
            if (currentProgress>4 && currentProgress<6) {
              if (obj["level"] >
                      provider.userModel.toJson()["levelMap"]
                          ["Discrimination"]!) {
                    UserData(buildContext: context)
                        .incrementLevelCount("Discrimination")
                        .then((value) {});
                  }
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

  Widget DiffSoundsW(DiffSounds diffSounds) {
    var obj =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    var provider = Provider.of<UserDataProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOption(
                text: "A",
                color: PrimaryColors().deepOrangeA200,
                index: 0,
                audio: diffSounds.video_url,
                correctOutput: diffSounds.same,
                type: "DiffSounds"),
            SizedBox(
              width: 30.h,
            ),
            _buildOption(
                text: "B",
                color: PrimaryColors().deepOrangeA200,
                index: 1,
                audio: diffSounds.video_url,
                correctOutput: diffSounds.same,
                type: "DiffSounds"),
          ],
        ),
        SizedBox(
          height: 20.v,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                type: ButtonType.Same,
                onPressed: () {
                  if (diffSounds.same) {
                    if (obj["level"] >
                        provider.userModel.toJson()["levelMap"]
                            ["Discrimination"]!) {
                      UserData(buildContext: context)
                          .incrementLevelCount("Discrimination")
                          .then((value) {});
                    }
                    _overlayEntry = celebrationOverlay(context, () {
                      _overlayEntry?.remove();
                    });
                    Overlay.of(context).insert(_overlayEntry!);
                  }
                }),
            SizedBox(
              width: 20.h,
            ),
            CustomButton(
                type: ButtonType.Diff,
                onPressed: () {
                  if (!diffSounds.same) {
                    if (obj["level"] >
                        provider.userModel.toJson()["levelMap"]
                            ["Discrimination"]!) {
                      UserData(buildContext: context)
                          .incrementLevelCount("Discrimination")
                          .then((value) {});
                    }
                    _overlayEntry = celebrationOverlay(context, () {
                      _overlayEntry?.remove();
                    });
                    Overlay.of(context).insert(_overlayEntry!);
                  }
                }),
          ],
        )
      ],
    );
  }

  Widget OddOneW(OddOne oddOne) {
    switch (oddOne.video_url.length) {
      case 2:
        // Statements executed when the expression equals value1
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildOption(
                    text: "A",
                    color: PrimaryColors().deepOrangeA200,
                    index: 0,
                    audio: oddOne.video_url,
                    correctOutput: oddOne.correct_output),
                SizedBox(
                  width: 20.h,
                ),
                _buildOption(
                    text: "B",
                    color: PrimaryColors().deepOrangeA200,
                    index: 1,
                    audio: oddOne.video_url,
                    correctOutput: oddOne.correct_output),
              ],
            ),
          ],
        );
      case 3:
        // Statements executed when the expression equals value2
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildOption(
                    text: "A",
                    color: PrimaryColors().deepOrangeA200,
                    index: 0,
                    audio: oddOne.video_url,
                    correctOutput: oddOne.correct_output),
                SizedBox(
                  width: 20.h,
                ),
                _buildOption(
                    text: "B",
                    color: PrimaryColors().deepOrangeA200,
                    index: 1,
                    audio: oddOne.video_url,
                    correctOutput: oddOne.correct_output),
              ],
            ),
            SizedBox(
              height: 20.v,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOption(
                    text: "C",
                    color: PrimaryColors().deepOrangeA200,
                    index: 2,
                    audio: oddOne.video_url,
                    correctOutput: oddOne.correct_output),
              ],
            )
          ],
        );

      // Statements executed when the expression equals value2

      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildOption(
                    text: "A",
                    color: PrimaryColors().deepOrangeA200,
                    index: 0,
                    audio: oddOne.video_url,
                    correctOutput: oddOne.correct_output),
                SizedBox(
                  width: 20.h,
                ),
                _buildOption(
                    text: "B",
                    color: PrimaryColors().deepOrangeA200,
                    index: 1,
                    audio: oddOne.video_url,
                    correctOutput: oddOne.correct_output),
              ],
            ),
            SizedBox(
              height: 20.v,
            ),
            Row(
              children: [
                _buildOption(
                    text: "C",
                    color: PrimaryColors().deepOrangeA200,
                    index: 2,
                    audio: oddOne.video_url,
                    correctOutput: oddOne.correct_output),
                SizedBox(
                  width: 20.h,
                ),
                _buildOption(
                    text: "D",
                    color: PrimaryColors().deepOrangeA200,
                    index: 3,
                    audio: oddOne.video_url,
                    correctOutput: oddOne.correct_output),
              ],
            ),
          ],
        );
      // Statements executed when none of the values match the value of the expression
    }
  }

  void setupTimer(List<String> audioUrls) {
    playTimer?.cancel(); // Cancel any existing timer
    playTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      currentIndex++;
      if (currentIndex < audioUrls.length) {
        playAudio.playMusic(audioUrls[currentIndex], "mp3", false);
      } else {
        timer.cancel();
        playAudio.stopMusic();
      }
    });
  }

  Widget _buildOption(
      {String? text,
      required Color color,
      required int index,
      required List<String> audio,
      required dynamic correctOutput,
      String? type}) {
    {
      var obj =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      var provider = Provider.of<UserDataProvider>(context, listen: false);
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: text == null ? false : true,
            child: Text(
              text! + ")",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 10.h,
          ),
          GestureDetector(
            onTap: () {
              if (type == "DiffSounds" || type == "MaleFemale") {
                return;
              }

              if (audio[index] == correctOutput) {
                print("Correct");
                if (obj["level"] >
                    provider.userModel.toJson()["levelMap"]
                        ["Discrimination"]!) {
                  UserData(buildContext: context)
                      .incrementLevelCount("Discrimination");
                }
                _overlayEntry = celebrationOverlay(context, () {
                  _overlayEntry?.remove();
                });
                Overlay.of(context).insert(_overlayEntry!);
              }

              setState(() {
                selectedOption = index;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.symmetric(
                horizontal: 3.h,
                vertical: 5.v,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: selectedOption != index
                      ? color
                      : PrimaryColors().green30001,
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    type: ButtonType.ImagePlay,
                    onPressed: () {
                      // AudioSampleExtractor audioSampleExtractor =
                      //     AudioSampleExtractor();
                      // audioSampleExtractor.getAssetAudioSamples(audios[index]);
                      if (type == "DiffHalf") {
                        if (playAudio.audioPlayer.state ==
                            PlayerState.playing) {
                          playAudio.audioPlayer.pause();
                        } else {
                            playAudio.audioPlayer.onPositionChanged
                            .listen((position) {
                          setState(() {
                            currentProgress = position.inSeconds.toDouble();
                          });
                        });

                          playAudio.playMusic(
                              audio[currentIndex], "mp3", false);
                              setupTimer(audio);
                        }
                      } else {
                        playAudio.playMusic(audio[index], "mp3", false);
                        
                      }
                    },
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Stack(
                    children: [
                      CustomImageView(
                        width: MediaQuery.of(context).size.width * 0.4 - 90,
                        height: 60,
                        fit: BoxFit.fill,
                        imagePath: "assets/images/spectrum.png",
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: PolygonWaveform(
                          samples: samples, // Use the updated samples
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.4 - 90,
                          inactiveColor: Colors.white.withOpacity(0.5),
                          activeColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
