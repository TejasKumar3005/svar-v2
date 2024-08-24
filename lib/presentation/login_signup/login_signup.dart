import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:rive/rive.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key})
      : super(
          key: key,
        );

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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/Login_Screen_Potrait.png"),
                  fit: BoxFit.fill),
            ),
            child: Stack(
              // Changed to Stack
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomImageView(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 110.v,
                          fit: BoxFit.contain,
                          imagePath: ImageConstant.imgSvaLogo,
                        ),
                        SizedBox(
                          height: 100.v,
                        ),
                        Column(
                          children: [
                            CustomButton(
                              type: ButtonType.Login,
                              onPressed: () {
                                NavigatorService.pushNamed(
                                  AppRoutes.login,
                                );
                              },
                            ),
                            SizedBox(
                              height: 10.v,
                            ),
                            CustomButton(
                              type: ButtonType.SignUp,
                              onPressed: () {
                                NavigatorService.pushNamed(
                                  AppRoutes.register,
                                );
                              },
                            ),
                          ],
                        ),
                        Container(),
                      ],
                    )
                  ],
                ),
                Positioned(
                  bottom: 20.v, // Adjust position as needed
                  right: 20.h, // Adjust position as needed
                  child: Container(
                    width: 100.v, // Set width for the Rive animation
                    height: 100.v, // Set height for the Rive animation
                    decoration: BoxDecoration(
                      color: Colors.white, // Add background color
                      borderRadius: BorderRadius.circular(
                          10.v), // Optional: add rounded corners
                    ),
                    child: RiveAnimation.asset(
                      'assets/animations/mascot-rig-final.riv', // Update with your Rive file
                      fit: BoxFit.contain,
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
