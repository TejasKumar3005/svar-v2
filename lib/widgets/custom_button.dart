import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/utils/image_constant.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:chiclet/chiclet.dart';
import 'package:chiclet/src/enums/button_types.dart';

enum ButtonType {
  Play,
  Settings,
  ImagePlay,
  ImagePause,
  ArrowLeftYellow,
  ArrowRightGreen,
  Login,
  Logout,
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
  Continue,
  AlreadyHaveAccount,
  CreateAccount,
  ResetPassword,
  Cancel,
  Save,
  Practice
}

class CustomButton extends StatefulWidget {
  final ButtonType type;
  final VoidCallback onPressed;
  final double? progress; // Only used for Spectrum
  final Color? color; // Only used for Spectrum
  final dynamic child;
  final double? width;
  const CustomButton({
    Key? key,
    required this.type,
    required this.onPressed,
    this.progress,
    this.color,
    this.child,
    this.width,
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
  dynamic defaultChild;
  ButtonTypes buttontype = ChicletButtonTypes.roundedRectangle;
  late VoidCallback onPressed_state;
  Color? color;

  @override
  void initState() {
    super.initState();
    onPressed_state = widget.onPressed;
    switch (widget.type) {
      case ButtonType.Play:
        imagePath = ImageConstant.playBtn;
        height = 60;
        width = widget.width ?? 0;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.play_arrow_rounded);
        break;
      case ButtonType.Settings:
        imagePath = ImageConstant.settingsBtn;
        height = 60;
        width = widget.width ?? 0;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.settings);
        break;
      case ButtonType.ImagePlay:
        imagePath = ImageConstant.imgPlayBtn;
        width = 50;
        height = 50;

        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.play_arrow);
        break;
      case ButtonType.ImagePause:
        imagePath = ImageConstant.imgPauseBtn;
        width = 50;
        height = 50;
  
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.pause);
        break;

      case ButtonType.Practice:
        height = 80;
        defaultChild = Text(
          "Practice",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;

      case ButtonType.Save:
        height = 60;
        width = widget.width ?? 0;
        defaultChild = Text(
          "Save",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;



      case ButtonType.ArrowLeftYellow:
        imagePath = ImageConstant.imgArrowLeftYellow;
        width = 40;
        height = 40;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.keyboard_return_rounded);
        break;
      case ButtonType.ArrowRightGreen:
        imagePath = ImageConstant.imgArrowRightGreen;
        width = 40;
        height = 40;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.keyboard_return_rounded);
        break;
      case ButtonType.Login:
        imagePath = ImageConstant.imgLoginBTn;
        height = 60;

        defaultChild = Text(
          "Login",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;

      case ButtonType.Logout:
        height = 60;
        width = widget.width ?? 0;
        defaultChild = Text(
          "Logout",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.AlreadyHaveAccount:
        height = 60;
        defaultChild = Text(
          "I ALREADY HAVE AN ACCOUNT",
          style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF47C37)),
        );
        break;

      case ButtonType.Cancel:
        height = 60;
        defaultChild = Text(
          "CANCEL",
          style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF47C37)),
        );
        break;
      case ButtonType.ResetPassword:
        height = 60;
        width = 80;
        defaultChild = Text(
          "Send Reset Email",
          style: GoogleFonts.inter(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        );
        break;
      case ButtonType.CreateAccount:
        height = 60;
        defaultChild = Text(
          "SIGN IN",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Continue:
        height = 60;
        defaultChild = Text(
          "CONTINUE",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Back:
        imagePath = ImageConstant.imgBackBtn;
        width = 35;
        height = 35;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.arrow_back);
        break;
      case ButtonType.SignUp:
        imagePath = ImageConstant.imgSignUpBTn;
        height = 60;
        defaultChild = Text(
          "Sign Up",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Home:
        imagePath = ImageConstant.imgHomeBtn;
        width = 35;
        height = 35;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = Text(
          "Submit",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Next:
        imagePath = ImageConstant.imgNextBtn;
        height = 60;
        width = widget.width ?? 0;
        defaultChild = Text(
          "Next",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;

      case ButtonType.Replay:
        imagePath = ImageConstant.imgReplayBtn;
        width = 35;
        height = 35;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.replay);
        break;
      case ButtonType.FullVolume:
        imagePath = ImageConstant.imgFullvolBtn;
        width = 35;
        height = 35;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.volume_up_sharp);
        break;
      case ButtonType.Menu:
        imagePath = ImageConstant.imgMenuBtn;
        width = 35;
        height = 35;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.menu);
        break;
      case ButtonType.Tip:
        imagePath = ImageConstant.imgTipBtn;
        width = 35;
        height = 35;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.tips_and_updates);
        break;
      case ButtonType.Mic:
        imagePath = ImageConstant.micBtn;
        width = 35;
        height = 35;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.mic);
        break;
      case ButtonType.Change:
        imagePath = ImageConstant.imgChangebtn;
        width = 170;
        height = 80;

        defaultChild = Text(
          "Stop",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Diff:
        imagePath = ImageConstant.imgDiffbtn;
        width = 170;
        height = 80;

        defaultChild = Text(
          "Diff",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Tip2:
        imagePath = ImageConstant.imgTipbtn;
        width = 35;
        height = 35;
        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.tips_and_updates);
        break;
      case ButtonType.Same:
        imagePath = ImageConstant.imgSamebtn;
        width = 170;
        height = 80;

        defaultChild = Text(
          "Same",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Video1:
        imagePath = ImageConstant.imgVideo1btn;
        width = 100;
        height = 60;

        defaultChild = Text(
          "Video 1",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Video2:
        imagePath = ImageConstant.imgVideo2btn;
        width = 100;
        height = 60;

        defaultChild = Text(
          "Video 2",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Stop:
        imagePath = ImageConstant.imgStopBtn;
        width = 170;
        height = 80;

        defaultChild = Text(
          "Stop",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Spectrum:
        imagePath = ImageConstant.imgSpectrum;
        width = 60;
        height = 60;
        isSvg = true;
        break;
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
      width = widget.width ?? MediaQuery.of(context).size.width * 0.9;
      color = null;
    }
    if (widget.type == ButtonType.AlreadyHaveAccount ||
        widget.type == ButtonType.Continue ||
        widget.type == ButtonType.ResetPassword ||
        widget.type == ButtonType.CreateAccount ||
        widget.type == ButtonType.Practice) {
      width = MediaQuery.of(context).size.width * 0.9;
      color = Color(0xFFF47C37);
    }

    if (widget.type == ButtonType.ResetPassword) {
      width = 190;
      color = Color(0xFFF47C37);
    }

    if (widget.type == ButtonType.Save) {
      color = Color(0xFF1cb0f6);
    }

    if (widget.type == ButtonType.Cancel) {
      width = 80;
      color = null;
    }

    if(widget.type == ButtonType.Logout){
      color = Color(0xFFff4b4b);
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
      child: ChicletAnimatedButton(
        onPressed: () {
          onPressed_state();
        },
        buttonType: buttontype,
        backgroundColor: widget.type != ButtonType.AlreadyHaveAccount &&
                widget.type != ButtonType.Cancel
            ? color != null
                ? color
                : Color.fromARGB(255, 29, 161, 242)
            : Color.fromARGB(255, 255, 255, 255),
        height: height,
        width: width,
        child: widget.child is Widget
            ? widget.child
            : (widget.child is String ? Text(widget.child) : defaultChild),
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
