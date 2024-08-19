
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playBgm.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _sliderValue = 0.5;
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
      body: SafeArea(child: Container(
          width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/settings_bg.png"), fit: BoxFit.fill),
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  border: Border.all(color: PrimaryColors().brown200, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.h,vertical: 8),
                      decoration: BoxDecoration(
                      color: PrimaryColors().deepOrange70003,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text("Settings",style: TextStyle(color: Colors.white,fontSize:20),),
                    ),
                    SizedBox(height: 20,)
                    ,
                  
                    Row(  
                      mainAxisAlignment: MainAxisAlignment.center,
                      
      children: [
        // Music Icon
        Container(
          width: 40,
          height: 40,
          child: SvgPicture.asset(
            'assets/images/svg/mute_btn.svg', // Path to your SVG asset
            width: 40,
            height: 40,
          ),
        ),
        SizedBox(width: 8), // Add spacing between the icon and the slider

        // Slider
        Container(
          height: 40,
          
          width: MediaQuery.of(context).size.width * 0.36, // Adjust this value to control the width of the slider
          child: Center(
            child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: PrimaryColors().blue20001, // Green part of the slider
              inactiveTrackColor: PrimaryColors().teal90001, // Light blue part of the slider
              trackHeight: 20.0,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 13.0, // Radius of the orange circle
                elevation: 0, // No elevation
              ),
              thumbColor: PrimaryColors().orange800,
               // Orange circle
              overlayColor: Colors.orange.withOpacity(0.2), // Overlay color when dragging
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
            ),
            child: Slider(
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
                _playBgm.setVolume(value);
              },
              min:0.0,
              max: 1.0,
            ),
          ),
          ),
        ),
      ],
    ),
      SizedBox(height: 10,),
                    Row(  
                      mainAxisAlignment: MainAxisAlignment.center,
                      
      children: [
        // Music Icon
        Container(
          width: 40,
          height: 40,
          child: SvgPicture.asset(
            'assets/images/svg/musicz_btn.svg', // Path to your SVG asset
            width: 40,
            height: 40,
          ),
        ),
        SizedBox(width: 8), // Add spacing between the icon and the slider

        // Slider
        Container(
          height: 40,
          
          width: MediaQuery.of(context).size.width * 0.36, // Adjust this value to control the width of the slider
          child: Center(
            child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              
              activeTrackColor: PrimaryColors().blue20001, // Green part of the slider
              inactiveTrackColor: PrimaryColors().teal90001, // Light blue part of the slider
              trackHeight: 20.0,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 13.0, // Radius of the orange circle
                elevation: 0, // No elevation
              ),
              thumbColor: PrimaryColors().orange800,
               // Orange circle
              overlayColor: Colors.orange.withOpacity(0.2), // Overlay color when dragging
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
            ),
            child: Slider(
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
          ),
          ),
        ),
      ],
    ),
    SizedBox(height: 10,),
                    Row(  
                      mainAxisAlignment: MainAxisAlignment.center,
                      
      children: [
        // Music Icon
        Container(
          width: 40,
          height: 40,
          child: SvgPicture.asset(
            'assets/images/svg/video_btn.svg', // Path to your SVG asset
            width: 40,
            height: 40,
          ),
        ),
        SizedBox(width: 8), // Add spacing between the icon and the slider

        // Slider
        Container(
          height: 40,
          
          width: MediaQuery.of(context).size.width * 0.36, // Adjust this value to control the width of the slider
          child: Center(
            child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: PrimaryColors().blue20001, // Green part of the slider
              inactiveTrackColor: PrimaryColors().teal90001, // Light blue part of the slider
              trackHeight: 20.0,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 13.0, // Radius of the orange circle
                elevation: 0, // No elevation
              ),
              thumbColor: PrimaryColors().orange800,
               // Orange circle
              overlayColor: Colors.orange.withOpacity(0.2), // Overlay color when dragging
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
            ),
            child: Slider(
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
          ),
          ),
        ),
      ],
    ),
    
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
                    
                    Card(
                      child: Container(
                      margin: EdgeInsets.all(3.h),
                        decoration: BoxDecoration(
                          color: PrimaryColors().deepOrange70003,
                          borderRadius: BorderRadius.circular(10),
                      
                        ),
                        padding: EdgeInsets.symmetric(horizontal:15.h,vertical:5.v),
                        child: Text("Privacy Policy",style: TextStyle(color: Colors.white,fontSize: 18),),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Card(
                      child: Container(
                      margin: EdgeInsets.all(3.h),
                        decoration: BoxDecoration(
                          color: PrimaryColors().deepOrange70003,
                          borderRadius: BorderRadius.circular(10),
                      
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15.h,vertical:5.v),
                        child: Text("Credits",style: TextStyle(color: Colors.white,fontSize: 18),),
                      ),
                    )
                  ],)
                  ],
                  
                ),
              ),
            ),
      )),

    );
  }
}