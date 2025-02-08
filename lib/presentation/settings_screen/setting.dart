import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playBgm.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
  
  static Widget builder(BuildContext context) {
    return SettingsScreen();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  double bgmslider = 0.5;
  double audioslider = 0.5;
  double videoslider = 0.5;

  final PlayBgm _playBgm = PlayBgm();
  
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
           Container(
            width: MediaQuery.of(context).size.width * 0.6,
            // constraints: BoxConstraints(
            //   maxHeight: MediaQuery.of(context).size.height * 0.8,
            // ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
                  decoration: BoxDecoration(
                    color: PrimaryColors().deepOrange70003,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          PlayBgm().playMusic('Back_Btn.mp3', "mp3", false);
                          Navigator.pop(context);
                        },
                        child: CustomImageView(
                          height: 30.adaptSize,
                          width: 30.adaptSize,
                          fit: BoxFit.contain,
                          imagePath: ImageConstant.imgBackBtn,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Settings",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

               
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 16.v, horizontal: 24.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildSliderRow(
                          'assets/images/svg/mute_btn.svg',
                          bgmslider,
                          (value) {
                            setState(() => bgmslider = value);
                            _playBgm.setVolume(value);
                          },
                        ),
                        SizedBox(height: 16.v),
                        buildSliderRow(
                          'assets/images/svg/musicz_btn.svg',
                          audioslider,
                          (value) {
                            setState(() => audioslider = value);
                          },
                        ),
                        SizedBox(height: 16.v),
                        buildSliderRow(
                          'assets/images/svg/video_btn.svg',
                          videoslider,
                          (value) {
                            setState(() => videoslider = value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Buttons
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButton("Privacy Policy"),
                      SizedBox(width: 16.h),
                      buildButton("Credits"),
                    ],
                  ),
                ),
              ],
            ),
          // ),
    );
  }

  Widget buildSliderRow(String iconPath, double value, Function(double) onChanged) {
    return Row(
      children: [
        Container(
          width: 32.adaptSize,
          height: 32.adaptSize,
          margin: EdgeInsets.only(right: 16.h),
          child: SvgPicture.asset(
            iconPath,
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: PrimaryColors().blue20001,
              inactiveTrackColor: PrimaryColors().teal90001,
              trackHeight: 8.0,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 12.0,
                elevation: 4,
              ),
              thumbColor: PrimaryColors().orange800,
              overlayColor: Colors.orange.withOpacity(0.2),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
              min: 0.0,
              max: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildButton(String text) {
    return Material(
      color: PrimaryColors().deepOrange70003,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}