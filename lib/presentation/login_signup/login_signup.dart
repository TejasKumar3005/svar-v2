import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:rive/rive.dart';

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

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
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
          body: Container(
            width: screenWidth,
            height: screenHeight,
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Login_Screen_Potrait.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomImageView(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.15, // Adjusted proportionally
                  fit: BoxFit.contain,
                  imagePath: ImageConstant.imgSvaLogo,
                ),
                SizedBox(
                  height: screenHeight * 0.05, // Adjusted proportionally
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
                        // Adjusted proportionally
                      ),
                      SizedBox(
                        height: screenHeight * 0.02, // Adjusted proportionally
                      ),
                      CustomButton(
                        type: ButtonType.SignUp,
                        onPressed: () {
                          NavigatorService.pushNamed(AppRoutes.register);
                        },
                        // Adjusted proportionally
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05, // Adjusted proportionally
                ),
                Flexible(
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.8, // Adjusted proportionally
                      height: screenHeight * 0.8, // Adjusted proportionally
                      child: RiveAnimation.asset(
                        'assets/rive/mascot-rig-final.riv', // Update with your Rive file
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
