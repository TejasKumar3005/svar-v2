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
          
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/BG.png"),fit: BoxFit.fill),
            gradient: LinearGradient(
              begin: Alignment(0.52, 0.33),
              end: Alignment(1, 0.61),
              colors: [
                appTheme.gray5003,
                appTheme.cyan200,
                appTheme.lightBlueA200
              ],
            ),
          ),
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildClose(context),
                  
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 81.h,
                              top: 87.v,
                              right: 81.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconButton(
                                  height: 68.v,
                                  
                                  width: 266.h,
                                  padding: EdgeInsets.all(4.h),
                                  decoration: IconButtonStyleHelper
                                      .gradientGreenToLightGreen,
                                  onTap: () {
                                    onTapBtnUser(context);
                                  },
                                  child: Center(child: Text("Log In",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 25),))
                                ),
                                SizedBox(height: 18.v),
                                CustomIconButton(
                                  height: 68.v,
                                  width: 266.h,
                                  padding: EdgeInsets.all(4.h),
                                  decoration: IconButtonStyleHelper
                                      .gradientDeepOrangeToOrange,
                                  child: Center(child: Text("Sign Up",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 25),))
                                )
                              ],
                            ),
                          ),
                        )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildClose(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 95.v,
            width: 62.h,
            margin: EdgeInsets.only(
              top: 18.v,
              bottom: 118.v,
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgCloseCyanA100,
                  width: 59.h,
                  alignment: Alignment.centerLeft,
                  onTap: () {
                    onTapImgClose(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.v),
                  child: CustomIconButton(
                    height: 37.adaptSize,
                    width: 37.adaptSize,
                    padding: EdgeInsets.all(9.h),
                    decoration:
                        IconButtonStyleHelper.gradientDeepOrangeToDeepOrange,
                    alignment: Alignment.topRight,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgArrowDown,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 232.v,
            width: 363.h,
            margin: EdgeInsets.only(left: 5.h),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgUnion,
                  height: 90.v,
                  alignment: Alignment.topRight,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgSvarLogo,
                  height: 150.v,
                  alignment: Alignment.bottomLeft,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapImgClose(BuildContext context) {
    NavigatorService.goBack();
  }

  /// Navigates to the mainInteractionScreen when the action is triggered.
  onTapBtnUser(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.mainInteractionScreen,
    );
  }
}
