import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart';
import 'package:svar_new/widgets/custom_button.dart';
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
  final PlayBgm _playBgm = PlayBgm();
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
        '/Users/anurag1104/Desktop/svar-v2/assets/video/bgg_animation.mp4')
      ..initialize().then((_) {
        setState(() {
          _videoController.play();
          _videoController.setLooping(true);
        });
      });
    print("video value intialised ${_videoController.value.isInitialized}");
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    _videoController.dispose(); // Properly dispose of the video controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showQuitDialog(context);
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Stack(
            // Use Stack instead of Container with Column
            fit: StackFit.expand,
            children: [
              // Background Video
              _videoController.value.isInitialized
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
                : Container(color: Colors.black),
              Container(
                // Your existing content
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
                      imagePath: ImageConstant.imgSvaLogo,
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
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
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          CustomButton(
                            type: ButtonType.SignUp,
                            onPressed: () {
                              NavigatorService.pushNamed(AppRoutes.register);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    Flexible(
                      child: Center(
                        child: Container(
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
