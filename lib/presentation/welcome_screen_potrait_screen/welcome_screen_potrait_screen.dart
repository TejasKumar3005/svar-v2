import 'package:flutter/widgets.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'models/welcome_screen_potrait_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/welcome_screen_potrait_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';

class WelcomeScreenPotraitScreen extends StatefulWidget {
  const WelcomeScreenPotraitScreen({Key? key})
      : super(
          key: key,
        );

  @override
  WelcomeScreenPotraitScreenState createState() =>
      WelcomeScreenPotraitScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WelcomeScreenPotraitProvider(),
      child: WelcomeScreenPotraitScreen(),
    );
  }
}

class WelcomeScreenPotraitScreenState
    extends State<WelcomeScreenPotraitScreen> {
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
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 80.v),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/BG.png"), fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomImageView(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 110.v,
                fit: BoxFit.contain,
                imagePath: ImageConstant.imgSvarLogo,
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
                        }),
                    SizedBox(
                      height: 10.v,
                    ),
                    CustomButton(
                        type: ButtonType.Settings,
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
