import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:audioplayers/audioplayers.dart';

class LingLearningScreen extends StatefulWidget {
  const LingLearningScreen({Key? key}) : super(key: key);

  @override
  LingLearningScreenState createState() => LingLearningScreenState();

  static Widget builder(BuildContext context) {
    return LingLearningScreen();
  }
}

class LingLearningScreenState extends State<LingLearningScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

// void _playAudio(String character) {
//   // Map character to audio file
//   String audioPath = '';
//   switch (character) {
//     case 'क':
//       audioPath = 'assets/audio/ka.mp3';
//       break;
//     case 'ख':
//       audioPath = 'assets/audio/kha.mp3';
//       break;
//     case 'ग':
//       audioPath = 'assets/audio/ga.mp3';
//       break;
//     case 'घ':
//       audioPath = 'assets/audio/gha.mp3';
//       break;
//     case 'च':
//       audioPath = 'assets/audio/cha.mp3';
//       break;
//     case 'छ':
//       audioPath = 'assets/audio/chha.mp3';
//       break;
//     case 'ज':
//       audioPath = 'assets/audio/ja.mp3';
//       break;
//     case 'झ':
//       audioPath = 'assets/audio/jha.mp3';
//       break;
//     case 'ट':
//       audioPath = 'assets/audio/ta.mp3';
//       break;
//     case 'ठ':
//       audioPath = 'assets/audio/thaa.mp3';
//       break;
//     case 'ड':
//       audioPath = 'assets/audio/da.mp3';
//       break;
//     case 'ढ':
//       audioPath = 'assets/audio/dhaa.mp3';
//       break;
//     case 'त':
//       audioPath = 'assets/audio/tha.mp3';
//       break;
//     case 'थ':
//       audioPath = 'assets/audio/taa.mp3';
//       break;
//     case 'ध':
//       audioPath = 'assets/audio/dhha.mp3';
//       break;
//     case 'न':
//       audioPath = 'assets/audio/naa.mp3';
//       break;
//     case 'प':
//       audioPath = 'assets/audio/pa.mp3';
//       break;
//     case 'फ':
//       audioPath = 'assets/audio/pha.mp3';
//       break;
//     case 'ब':
//       audioPath = 'assets/audio/ba.mp3';
//       break;
//     case 'भ':
//       audioPath = 'assets/audio/bha.mp3';
//       break;
//     case 'म':
//       audioPath = 'assets/audio/ma.mp3';
//       break;
//     default:
//       audioPath = 'assets/audio/default.mp3';  // Ensure a default.mp3 file exists or handle this case appropriately
//   }

//   _audioPlayer.play(AssetSource(audioPath));
// }



  @override
  Widget build(BuildContext context) {
    LingLearningProvider lingLearningProvider =
        context.watch<LingLearningProvider>();

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.imgGroup7),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  _buildAppBar(context),
                ],
              ),
              Positioned(
                left: 80,
                bottom: 100,
                child: GestureDetector(
                  // onTap: () {
                  //   _playAudio(lingLearningProvider.selectedCharacter);
                  // },
                  child: Text(
                    lingLearningProvider.selectedCharacter,
                    style: TextStyle(fontSize: 160),
                  ),
                ),
              ),
              Positioned(
                left: 180,
                bottom: 120,
                child: AvatarGlow(
                  endRadius: 90.0,
                  glowColor: Colors.blue,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: Container(
                      height: 120,
                      width: 120,
                      child: CustomButton(
                        type: ButtonType.Mic,
                        onPressed: () {
                          print("Microphone button pressed");
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 80,
                bottom: 0,
                child: Container(
                  height: 360,
                  width: 270,
                  child: Image.asset(
                    ImageConstant.imgProtaganist1,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 50,
                child: Container(
                  height: 70,
                  width: 100,
                  child: CustomButton(
                    type: ButtonType.Tip,
                    onPressed: () {
                      NavigatorService.pushNamed(
                        AppRoutes.tipBoxVideoScreen,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            type: ButtonType.Back,
            onPressed: () {
              NavigatorService.pushNamed(
                AppRoutes.phonmesListScreen,
              );
            },
          ),
          Spacer(),
        ],
      ),
    );
  }
}