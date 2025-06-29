/*
 * Enhanced CustomButton with Smooth Progress Transitions
 * 
 * Usage Examples:
 * 
 * 1. Basic progress with smooth animation:
 * CustomButton(
 *   type: ButtonType.Spectrum,
 *   progress: 0.7,
 *   color: Colors.green,
 *   animationDuration: Duration(milliseconds: 800),
 *   animationCurve: Curves.easeInOut,
 *   clippingStyle: ClippingStyle.leftToRight,
 *   autoAnimate: true,
 *   onPressed: () => print('Button pressed'),
 * )
 * 
 * 2. Radial progress with bouncy animation:
 * CustomButton(
 *   type: ButtonType.Spectrum,
 *   progress: progressValue,
 *   color: Colors.blue,
 *   animationDuration: Duration(seconds: 1),
 *   animationCurve: Curves.bounceOut,
 *   clippingStyle: ClippingStyle.radial,
 *   onPressed: () => updateProgress(),
 * )
 * 
 * 3. Different clipping styles available:
 *   - ClippingStyle.leftToRight
 *   - ClippingStyle.rightToLeft
 *   - ClippingStyle.topToBottom
 *   - ClippingStyle.bottomToTop
 *   - ClippingStyle.radial
 *   - ClippingStyle.diagonal
 * 
 * 4. Animation curves available:
 *   - Curves.easeInOut (default)
 *   - Curves.bounceOut
 *   - Curves.elasticOut
 *   - Curves.fastOutSlowIn
 *   - Curves.linear
 *   - etc.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/utils/image_constant.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:chiclet/chiclet.dart';
import 'package:chiclet/src/enums/button_types.dart';
import 'dart:math' as math;
import 'dart:async';

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
  Practice,
  ParentMode
}

enum ClippingStyle {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
  radial,
  diagonal
}

class CustomButton extends StatefulWidget {
  final ButtonType type;
  final VoidCallback onPressed;
  final double? progress; // Only used for Spectrum
  final Color? color; // Only used for Spectrum
  final dynamic child;
  final double? width;
  final Duration?
      animationDuration; // Animation duration for smooth transitions
  final Curve? animationCurve; // Easing curve for animations
  final ClippingStyle? clippingStyle; // Style of progress clipping
  final bool? autoAnimate; // Whether to auto-animate progress from 0 to target

  const CustomButton({
    Key? key,
    required this.type,
    required this.onPressed,
    this.progress,
    this.color,
    this.child,
    this.width,
    this.animationDuration,
    this.animationCurve,
    this.clippingStyle,
    this.autoAnimate,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  String imagePath = '';
  double height = 0;
  double width = 0;
  BoxFit fit = BoxFit.contain;
  bool isSvg = false;
  dynamic defaultChild;
  ButtonTypes buttontype = ChicletButtonTypes.roundedRectangle;
  late VoidCallback onPressed_state;
  Color? color;

  // Animation properties
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _currentProgress = 0.0;

  // Spectrum animation properties
  Timer? _spectrumTimer;
  bool _isSpectrumAnimating = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: widget.animationDuration ?? Duration(milliseconds: 500),
      vsync: this,
    );

    // Setup progress animation with easing curve
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress ?? 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve ?? Curves.easeInOut,
    ));

    // Listen to animation changes
    _progressAnimation.addListener(() {
      setState(() {
        _currentProgress = _progressAnimation.value;
      });
    });

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
        // imagePath = ImageConstant.imgPlayBtn;
        width = 50;
        height = 50;

        buttontype = ChicletButtonTypes.oval;
        defaultChild = const Icon(Icons.play_arrow);
        break;
      case ButtonType.ImagePause:
        // imagePath = ImageConstant.imgPauseBtn;
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
        height = 50;
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
        height = 60;

        defaultChild = Text(
          "Stop",
          style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
        );
        break;
      case ButtonType.Diff:
        imagePath = ImageConstant.imgDiffbtn;
        width = 200;
        height = 70;

        defaultChild = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Different",
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.circle, size: 30),
            SizedBox(width: 8),
            Icon(CupertinoIcons.arrowtriangle_up_fill, size: 35),
          ],
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
        width = 200;
        height = 70;

        defaultChild = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Same",
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.circle, size: 30),
            SizedBox(width: 8),
            Icon(Icons.circle, size: 30),
          ],
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

      case ButtonType.ParentMode:
        height = 40;
        width = 150;
        buttontype = ChicletButtonTypes.roundedRectangle;
        color = Color(0xFF1cb0f6);
        defaultChild = Center(
            child: Text(
          "Parent Mode",
          style: GoogleFonts.inter(
              fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
        ));
        break;
    }
  }

  @override
  void didUpdateWidget(CustomButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle progress changes with smooth animation
    if (widget.progress != oldWidget.progress && widget.progress != null) {
      _progressAnimation = Tween<double>(
        begin: _currentProgress,
        end: widget.progress!,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve ?? Curves.easeInOut,
      ));

      // Reset and start animation
      _animationController.reset();
      _animationController.forward();

      // Handle spectrum animation for playing state
      if (widget.type == ButtonType.Spectrum) {
        bool shouldAnimate = widget.progress! > 0 && widget.progress! < 1;
        if (shouldAnimate && !_isSpectrumAnimating) {
          _startSpectrumAnimation();
        } else if (!shouldAnimate && _isSpectrumAnimating) {
          _stopSpectrumAnimation();
        }
      }
    }

    // Auto-animate if enabled
    if (widget.autoAnimate == true &&
        widget.progress != null &&
        !_animationController.isAnimating) {
      _animationController.forward();
    }
  }

  void _startSpectrumAnimation() {
    _isSpectrumAnimating = true;
    _spectrumTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (mounted && widget.type == ButtonType.Spectrum) {
        setState(() {
          // This will trigger a repaint of the spectrum
        });
      }
    });
  }

  void _stopSpectrumAnimation() {
    _isSpectrumAnimating = false;
    _spectrumTimer?.cancel();
    _spectrumTimer = null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stopSpectrumAnimation();
    super.dispose();
  }

  // Helper methods for animation control
  void startAnimation() {
    if (widget.progress != null) {
      _animationController.forward();
    }
  }

  void resetAnimation() {
    _animationController.reset();
    setState(() {
      _currentProgress = 0.0;
    });
  }

  void reverseAnimation() {
    _animationController.reverse();
  }

  void stopAnimation() {
    _animationController.stop();
  }

  void setProgress(double progress, {bool animate = true}) {
    if (animate) {
      _progressAnimation = Tween<double>(
        begin: _currentProgress,
        end: progress.clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve ?? Curves.easeInOut,
      ));
      _animationController.reset();
      _animationController.forward();
    } else {
      setState(() {
        _currentProgress = progress.clamp(0.0, 1.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Adjust width for certain button types dynamically
    if (widget.type == ButtonType.Play ||
        widget.type == ButtonType.Settings ||
        widget.type == ButtonType.Login ||
        widget.type == ButtonType.SignUp ||
        widget.type == ButtonType.Next) {
      width = widget.width ?? MediaQuery.of(context).size.width * 0.9;
      color = null;
    }
    if (widget.type == ButtonType.Video1 || widget.type == ButtonType.Video2) {
      width = widget.width ?? 190;
      color = null;
    }
    if (widget.type == ButtonType.AlreadyHaveAccount ||
        widget.type == ButtonType.Continue ||
        widget.type == ButtonType.ResetPassword ||
        widget.type == ButtonType.CreateAccount ||
        widget.type == ButtonType.Practice) {
      width = widget.width ?? MediaQuery.of(context).size.width * 0.9;
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

    if (widget.type == ButtonType.Logout) {
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
          color: Colors.transparent, // Explicitly transparent background
          child: CustomPaint(
            painter: SpectrumPainter(
              progress: _currentProgress,
              color: widget.color ?? Colors.orange,
              isPlaying: _isSpectrumAnimating,
            ),
            size: Size(width, height),
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

// Enhanced progress clipper with multiple clipping styles
class _ProgressClipper extends CustomClipper<Path> {
  final double progress;
  final ClippingStyle style;

  _ProgressClipper({required this.progress, required this.style});

  @override
  Path getClip(Size size) {
    Path path = Path();

    switch (style) {
      case ClippingStyle.leftToRight:
        path.addRect(Rect.fromLTRB(0, 0, size.width * progress, size.height));
        break;

      case ClippingStyle.rightToLeft:
        path.addRect(Rect.fromLTRB(
            size.width * (1 - progress), 0, size.width, size.height));
        break;

      case ClippingStyle.topToBottom:
        path.addRect(Rect.fromLTRB(0, 0, size.width, size.height * progress));
        break;

      case ClippingStyle.bottomToTop:
        path.addRect(Rect.fromLTRB(
            0, size.height * (1 - progress), size.width, size.height));
        break;

      case ClippingStyle.radial:
        double radius = math.min(size.width, size.height) / 2 * progress;
        Offset center = Offset(size.width / 2, size.height / 2);
        path.addOval(Rect.fromCircle(center: center, radius: radius));
        break;

      case ClippingStyle.diagonal:
        if (progress <= 0.5) {
          // First half - diagonal from top-left
          double diagProgress = progress * 2;
          path.moveTo(0, 0);
          path.lineTo(size.width * diagProgress, 0);
          path.lineTo(0, size.height * diagProgress);
          path.close();
        } else {
          // Second half - complete the fill
          double diagProgress = (progress - 0.5) * 2;
          path.moveTo(0, 0);
          path.lineTo(size.width, 0);
          path.lineTo(size.width, size.height * diagProgress);
          path.lineTo(size.width * (1 - diagProgress), size.height);
          path.lineTo(0, size.height);
          path.close();
        }
        break;
    }

    return path;
  }

  @override
  bool shouldReclip(_ProgressClipper oldClipper) {
    return oldClipper.progress != progress || oldClipper.style != style;
  }
}

// Beautiful animated spectrum painter
class SpectrumPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isPlaying;

  SpectrumPainter({
    required this.progress,
    required this.color,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    const int barCount = 28;
    const double barWidth = 4.0;
    const double spacing = 3.0;
    final double totalWidth = barCount * (barWidth + spacing) - spacing;
    final double startX = (size.width - totalWidth) / 2;

    final int activeBars = (barCount * progress).floor();
    final random = math.Random();

    for (int i = 0; i < barCount; i++) {
      final double x = startX + i * (barWidth + spacing);

      // A gentle descending curve for bar heights, matching the image.
      final t = i / (barCount - 1);
      final heightFactor = 0.4 + (0.5 * (math.cos(t * math.pi) + 1) * 0.5);

      double barHeight = size.height * heightFactor;

      if (isPlaying && i < activeBars) {
        barHeight *= (0.85 + 0.15 * random.nextDouble());
      }

      // Active bars are colored, inactive are gray.
      paint.color = i < activeBars ? color : const Color(0xFF4C4C4C);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x + barWidth / 2, size.height / 2),
            width: barWidth,
            height: barHeight,
          ),
          Radius.circular(barWidth / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SpectrumPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isPlaying != isPlaying;
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
