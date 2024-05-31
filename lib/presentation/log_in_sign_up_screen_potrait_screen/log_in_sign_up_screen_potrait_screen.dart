import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'models/log_in_sign_up_screen_potrait_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/log_in_sign_up_screen_potrait_provider.dart';

class LogInSignUpScreenPotraitScreen extends StatefulWidget {
  const LogInSignUpScreenPotraitScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LogInSignUpScreenPotraitScreenState createState() =>
      LogInSignUpScreenPotraitScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogInSignUpScreenPotraitProvider(),
      child: LogInSignUpScreenPotraitScreen(),
    );
  }
}

class LogInSignUpScreenPotraitScreenState
    extends State<LogInSignUpScreenPotraitScreen> {
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
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/BG.png"), fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgBackBtn,
                  ),
                  Spacer()
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomImageView(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 110.v,
                    fit: BoxFit.contain,
                    imagePath: ImageConstant.imgSvarLogo,
                  ),
                  SizedBox(
                    height: 100.v,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          NavigatorService.popAndPushNamed(
                              AppRoutes.loginScreenPotraitScreen);
                        },
                        child: CustomImageView(
                          imagePath: ImageConstant.imgLoginBTn,
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 60.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 10.v,
                      ),
                      GestureDetector(
                          onTap: () {
                          NavigatorService.popAndPushNamed(
                              AppRoutes.registerFormScreenPotratitV1ChildScreen);
                        },
                        child: CustomImageView(
                          imagePath: ImageConstant.imgSignUpBTn,
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 60.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
