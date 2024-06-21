import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/welcome_screen_potrait_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:svar_new/widgets/custom_image_view.dart'; // Ensure this import is correct

class WelcomeScreenPotraitScreen extends StatefulWidget {
  const WelcomeScreenPotraitScreen({Key? key}) : super(key: key);

  @override
  WelcomeScreenPotraitScreenState createState() => WelcomeScreenPotraitScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WelcomeScreenPotraitProvider(),
      child: WelcomeScreenPotraitScreen(),
    );
  }
}

class WelcomeScreenPotraitScreenState extends State<WelcomeScreenPotraitScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            SvgPicture.asset(
              "assets/images/svg/Bg.svg",  // Ensure this path matches the actual path
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomImageView(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 110,
                    fit: BoxFit.contain,
                    imagePath: ImageConstant.imgSvaLogo,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        CustomButton(
                          type: ButtonType.Play,
                          onPressed: () {
                            NavigatorService.pushNamed(
                              AppRoutes.logInSignUpScreenPotraitScreen,
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                          type: ButtonType.Settings,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
