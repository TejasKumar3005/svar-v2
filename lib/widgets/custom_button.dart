import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/core/utils/image_constant.dart';
import 'package:svar_new/core/utils/playBgm.dart';

enum ButtonType {
  Play,
  Settings,
  ImagePlay,
  ArrowLeftYellow,
  ArrowRightGreen,
  Login,
  Back,
  SignUp,
  Home,
  Next,
  Replay,
  FullVolume,
  Menu,
  Tip,
  Mic,
  Change,
  Diff,
  Tip2,
  Same,
  Video1,
  Video2,
  // Add more button types as needed
}

class CustomButton extends StatelessWidget {
  final ButtonType type;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.type,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath = '';
    double height = 0;
    double width = 0;
    BoxFit fit = BoxFit.contain;
    bool isSvg = false;

    switch (type) {
      case ButtonType.Play:
        imagePath = ImageConstant.playBtn;
        width = MediaQuery.of(context).size.width * 0.7;
        height = 60;
        isSvg = true;
        break;
      case ButtonType.Settings:
        imagePath = ImageConstant.settingsBtn;
        width = MediaQuery.of(context).size.width * 0.7;
        height = 60;
        isSvg = true;
        break;
      case ButtonType.ImagePlay:
        imagePath = ImageConstant.imgPlayBtn;
        width = 50;
        height = 50;
        isSvg = true;
        break;
      case ButtonType.ArrowLeftYellow:
        imagePath = ImageConstant.imgArrowLeftYellow;
        width = 40;
        height = 40;
        isSvg = true;
        break;
      case ButtonType.ArrowRightGreen:
        imagePath = ImageConstant.imgArrowRightGreen;
        width = 40;
        height = 40;
        isSvg = true;
        break;
      case ButtonType.Login:
        imagePath = ImageConstant.imgLoginBTn;
        width = MediaQuery.of(context).size.width * 0.7;
        height = 60;
        isSvg = true;
        break;
      case ButtonType.Back:
        imagePath = ImageConstant.imgBackBtn;
        width = 35;
        height = 35;
        isSvg = true;
        break;
      case ButtonType.SignUp:
        imagePath = ImageConstant.imgSignUpBTn;
        width = MediaQuery.of(context).size.width * 0.7;
        height = 60;
        isSvg = true;
        break;
      case ButtonType.Home:
        imagePath = ImageConstant.imgHomeBtn;
        width = 35;
        height = 35;
        isSvg = true;
        break;
      case ButtonType.Next:
        imagePath = ImageConstant.imgNextBtn;
        width = MediaQuery.of(context).size.width * 0.7;
        height = 60;
        isSvg = true;
        break;
      case ButtonType.Replay:
        imagePath = ImageConstant.imgReplayBtn;
        width = 35;
        height = 35;
        isSvg = true;
        break;
      case ButtonType.FullVolume:
        imagePath = ImageConstant.imgFullvolBtn;
        width = 35;
        height = 35;
        isSvg = true;
        break;
      case ButtonType.Menu:
        imagePath = ImageConstant.imgMenuBtn;
        width = 35;
        height = 35;
        isSvg = true;
        break;
      case ButtonType.Tip:
        imagePath = ImageConstant.imgTipBtn;
        width = 35;
        height = 35;
        isSvg = true;
        break;
      case ButtonType.Mic:
        imagePath = ImageConstant.micBtn;
        width = 35;
        height = 35;
        isSvg = true;
        break;
      // Add cases for more button types here
    }

    return GestureDetector(
      onTap: () {
        if (type == ButtonType.Next){

          PlayBgm().playMusic('Next_Btn.mp3', "mp3", false);
        }
                        
        onPressed();
      },
      child: Container(
        height: height,
        width: width,
        child: isSvg
            ? SvgPicture.asset(
                imagePath,
                fit: fit,
              )
            : Image.asset(
                imagePath,
                fit: fit,
              ),
      ),
    );
  }
}
