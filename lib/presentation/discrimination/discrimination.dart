import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/audioSampleExtractor.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/utils/playAudio.dart';
import './customthumb.dart';

class Discrimination extends StatefulWidget {
  const Discrimination({super.key});

  @override
  State<Discrimination> createState() => _DiscriminationState();
  static Widget builder(BuildContext context) {
    return Discrimination();
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
  String type = "4";
  List<double> samples = [];
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
            Container(
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
                  "Pick the odd One Out",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.v,
            ),
            discriminationOptions(),
          ],
        ),
      ),
    );
  }

  Widget discriminationOptions() {
    switch (type) {
      case "1":
        return DiscriType1();
      case "2-4":
        return DiscriType24();
      case "3":
        return DiscriType3();
      case "4":
        return DiscriType4();
      default:
        return DiscriType1();
    }
  }

  Widget DiscriType4() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildOption("", PrimaryColors().deepOrangeA200, 0),
        SizedBox(
          height: 20.v,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Artboard("img_mascot"),
            SizedBox(
              width: 20.h,
            ),
            Artboard("img_mascot"),
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
            imagePath: "assets/images/$image.png",
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

  Widget DiscriType3() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildOption("A", PrimaryColors().deepOrangeA200, 0),
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
                value: 0.2,
                onChanged: (value) {},
                min: 0.0,
                max: 1.0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.v,
        ),
        CustomButton(
          type: ButtonType.Change,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget DiscriType1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOption("A", PrimaryColors().deepOrangeA200, 0),
            SizedBox(
              width: 30.h,
            ),
            _buildOption("B", PrimaryColors().deepOrangeA200, 1),
          ],
        ),
        SizedBox(
          height: 20.v,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              

              type: ButtonType.Same, onPressed: () {}),
            SizedBox(
              width: 20.h,
            ),
            CustomButton(type: ButtonType.Diff, onPressed: () {}),
          ],
        )
      ],
    );
  }

  Widget DiscriType24() {
    switch (audios.length) {
      case 2:
        // Statements executed when the expression equals value1
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildOption("A", PrimaryColors().deepOrangeA200, 0),
                SizedBox(
                  width: 20.h,
                ),
                _buildOption("B", PrimaryColors().deepOrangeA200, 1),
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
                _buildOption("A", PrimaryColors().deepOrangeA200, 0),
                SizedBox(
                  width: 20.h,
                ),
                _buildOption("B", PrimaryColors().deepOrangeA200, 1),
              ],
            ),
            SizedBox(
              height: 20.v,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOption("C", PrimaryColors().deepOrangeA200, 2),
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
                _buildOption("A", PrimaryColors().deepOrangeA200, 0),
                SizedBox(
                  width: 20.h,
                ),
                _buildOption("B", PrimaryColors().deepOrangeA200, 1),
              ],
            ),
            SizedBox(
              height: 20.v,
            ),
            Row(
              children: [
                _buildOption("C", PrimaryColors().deepOrangeA200, 2),
                SizedBox(
                  width: 20.h,
                ),
                _buildOption("D", PrimaryColors().deepOrangeA200, 3),
              ],
            ),
          ],
        );
      // Statements executed when none of the values match the value of the expression
    }
  }

  Widget _buildOption(String text, Color color, int index) {
    {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text + ")",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 10.h,
          ),
          GestureDetector(
            onTap: () {
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
                color: selectedOption != index ? color : PrimaryColors().green30001,
                border: Border.all(
                        color: Colors.black,
                        width: 3,
                      )
                    
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    type: ButtonType.ImagePlay,
                    onPressed: () {
                      // AudioSampleExtractor audioSampleExtractor =
                      //     AudioSampleExtractor();
                      // audioSampleExtractor.getAssetAudioSamples(audios[index]);
                      playAudio.playMusic(audios[index], "mp3", false);
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
