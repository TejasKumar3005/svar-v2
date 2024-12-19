import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/app_export.dart'; // Make sure this import is correct
import 'package:svar_new/core/utils/playBgm.dart'; // Make sure this import is correct
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart'; // Make sure this import is correct
import 'package:svar_new/widgets/custom_button.dart'; // Make sure this import is correct
import 'package:rive/rive.dart';
import 'package:video_player/video_player.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  LoginSignUpScreenState createState() => LoginSignUpScreenState();

  static Widget builder(BuildContext context) {
    return LoginSignUpScreen();
  }
}

class LoginSignUpScreenState extends State<LoginSignUpScreen> {
  final PlayBgm _playBgm = PlayBgm(); // Make sure PlayBgm is implemented
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false; // Track video initialization

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController =
          VideoPlayerController.asset('assets/video/bgg_animation.mp4');
      await _videoController.initialize();
      setState(() {
        _isVideoInitialized = true;
        _videoController.play();
        _videoController.setLooping(true);
      });
    } catch (e) {
      print('Error initializing video: $e');
      // Handle error, e.g., show an error message to the user
      setState(() {
        _isVideoInitialized = false; // Video init failed
      });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showQuitDialog(context); // Make sure showQuitDialog is defined
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background Video or Placeholder
              _isVideoInitialized
                  ? SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoController.value.size.width,
                          height: _videoController.value.size.height,
                          child: VideoPlayer(_videoController),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.black,
                      child: const Center(
                          child:
                              CircularProgressIndicator()), // Loading indicator
                    ),
              // Content on top of the video
              Container(
                width: screenWidth,
                height: screenHeight,
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomImageView(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.15,
                      fit: BoxFit.contain,
                      imagePath: ImageConstant.imgSvaLogo, // Make sure this is correct
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            type: ButtonType.Login,
                            onPressed: () {
                              NavigatorService.pushNamed(AppRoutes.login);
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          CustomButton(
                            type: ButtonType.SignUp,
                            onPressed: () {
                              NavigatorService.pushNamed(AppRoutes.register);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Flexible(
                      child: Center(
                        child: SizedBox(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.8,
                          child: RiveAnimation.asset(
                            'assets/rive/mascot-rig-final.riv',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}