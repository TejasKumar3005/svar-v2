import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/utils/image_constant.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/widgets/Options.dart';

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
  Stop,
  Spectrum,
}

class CustomButton extends StatefulWidget {
  final ButtonType type;
  final VoidCallback onPressed;
  final double? progress; // Only used for Spectrum
  final Color? color; // Only used for Spectrum
  final String? text; // Add this line

  const CustomButton({
    Key? key,
    required this.type,
    required this.onPressed,
    this.progress,
    this.color,
    this.text, // Add this line
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  String imagePath = '';
  double height = 0;
  double width = 0;
  BoxFit fit = BoxFit.contain;
  bool isSvg = false;
  late VoidCallback onPressed_state;

  @override
  void initState() {
    super.initState();
    onPressed_state = widget.onPressed;
    switch (widget.type) {
      case ButtonType.Play:
        imagePath = ImageConstant.playBtn;
        height = 60;
        isSvg = true;
        break;
      case ButtonType.Settings:
        imagePath = ImageConstant.settingsBtn;
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
      case ButtonType.Change:
        imagePath = ImageConstant.imgChangebtn;
        width = 170;
        height = 80;
        isSvg = true;
        break;
      case ButtonType.Diff:
        imagePath = ImageConstant.imgDiffbtn;
        width = 170;
        height = 80;
        isSvg = true;
        break;
      case ButtonType.Tip2:
        imagePath = ImageConstant.imgTipbtn;
        width = 35;
        height = 35;
        isSvg = true;
        break;
      case ButtonType.Same:
        imagePath = ImageConstant.imgSamebtn;
        width = 170;
        height = 80;
        isSvg = true;
        break;
      case ButtonType.Video1:
        imagePath = ImageConstant.imgVideo1btn;
        width = 100;
        height = 60;
        isSvg = true;
        break;
      case ButtonType.Video2:
        imagePath = ImageConstant.imgVideo2btn;
        width = 100;
        height = 60;
        isSvg = true;
        break;
      case ButtonType.Stop:
        imagePath = ImageConstant.imgStopBtn;
        width = 170;
        height = 80;
        isSvg = true;
        break;
      case ButtonType.Spectrum:
        imagePath = ImageConstant.imgSpectrum;
        width = 60;
        height = 60;
        isSvg = true;
        break;

      // Add cases for more button types here
    }
  }

  @override
  Widget build(BuildContext context) {
    // Adjust width for certain button types dynamically
    if (widget.type == ButtonType.Play ||
        widget.type == ButtonType.Settings ||
        widget.type == ButtonType.Login ||
        widget.type == ButtonType.SignUp ||
        widget.type == ButtonType.Next ||
        widget.type == ButtonType.Video1 ||
        widget.type == ButtonType.Video2) {
      width = MediaQuery.of(context).size.width * 0.7;
    }

    // Handle Spectrum type with progress and color
    if (widget.type == ButtonType.Spectrum) {
      return GestureDetector(
        onTap: () {
          onPressed_state();
          AnalyticsService _analyticsService = AnalyticsService();
          _analyticsService.logEvent('button_pressed', {
            'button_type': widget.type.toString(),
            "time": DateTime.now().toString()
          });
        },
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: [
              // Original SVG
              SvgPicture.asset(
                imagePath,
                fit: fit,
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.7,
              ),
              // Overlay with progress
              if (widget.progress != null)
                ClipRect(
                  clipper: _ProgressClipper(
                    progress: widget.progress!,
                  ),
                  child: SvgPicture.asset(
                    imagePath,
                    fit: fit,
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.7,
                    colorFilter: ColorFilter.mode(
                      widget.color ?? Colors.green,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (widget.type == ButtonType.Next) {
          PlayBgm().playMusic('Next_Btn.mp3', "mp3", false);
        }
        onPressed_state();
        AnalyticsService _analyticsService = AnalyticsService();
        _analyticsService.logEvent('button_pressed', {
          'button_type': widget.type.toString(),
          "time": DateTime.now().toString()
        });
      },
      child: Container(
        height: height,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            isSvg
                ? SvgPicture.asset(
                    imagePath,
                    fit: fit,
                    width: width,
                    height: height,
                  )
                : Image.asset(
                    imagePath,
                    fit: fit,
                    width: width,
                    height: height,
                  ),
            if (widget.text != null)
              Text(
                widget.text!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper for progress overlay
class _ProgressClipper extends CustomClipper<Rect> {
  final double progress;

  _ProgressClipper({required this.progress});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(_ProgressClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

class OptionButton extends CustomButton {



const OptionButton({
    Key? key,
    required ButtonType type,
    required VoidCallback onPressed,
  }) : super(key: key, type: type, onPressed: onPressed);

  @override
  _OptionButtonState createState() => _OptionButtonState();
}

class _OptionButtonState extends _CustomButtonState {
  @override
  void initState () {
    super.initState();
  }

  @override
  Widget build (BuildContext context){
    final click = ClickProvider.of(context)?.click;
    setState(() {
      onPressed_state = () {
        if (click != null) {
          print("click");
          click();
        }
        widget.onPressed();
      };
    });
    return super.build(context);
  }
}
