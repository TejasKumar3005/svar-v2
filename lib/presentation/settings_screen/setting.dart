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
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/settings_bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth * 0.6,
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * 0.9,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: PrimaryColors().brown200, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.h),
                          child: GestureDetector(
                            onTap: () {
                              PlayBgm().playMusic('Back_Btn.mp3', "mp3", false);
                              Navigator.pop(context);
                            },
                            child: CustomImageView(
                              height: 35.adaptSize,
                              width: 35.adaptSize,
                              fit: BoxFit.contain,
                              imagePath: ImageConstant.imgBackBtn,
                            ),
                          ),
                        ),
                      ),
                      
                      // Settings Title
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.v),
                        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 6.v),
                        decoration: BoxDecoration(
                          color: PrimaryColors().deepOrange70003,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Settings",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),

                      // Sliders Section
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildSliderRow(
                                'assets/images/svg/mute_btn.svg',
                                bgmslider,
                                (value) {
                                  setState(() => bgmslider = value);
                                  _playBgm.setVolume(value);
                                },
                              ),
                              buildSliderRow(
                                'assets/images/svg/musicz_btn.svg',
                                audioslider,
                                (value) {
                                  setState(() => audioslider = value);
                                },
                              ),
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
                        padding: EdgeInsets.only(bottom: 16.v),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSliderRow(String iconPath, double value, Function(double) onChanged) {
    return Row(
      children: [
        Container(
          width: 32.adaptSize,
          height: 32.adaptSize,
          margin: EdgeInsets.only(right: 8.h),
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
              trackHeight: 16.0,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 11.0,
                elevation: 0,
              ),
              thumbColor: PrimaryColors().orange800,
              overlayColor: Colors.orange.withOpacity(0.2),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
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
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 4.v),
        decoration: BoxDecoration(
          color: PrimaryColors().deepOrange70003,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}