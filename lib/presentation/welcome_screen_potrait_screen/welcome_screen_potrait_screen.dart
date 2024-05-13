import 'package:svar_new/widgets/custom_icon_button.dart';
import 'models/welcome_screen_potrait_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/welcome_screen_potrait_provider.dart';

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
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
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
                  SizedBox(
                    height: 759.v,
                    width: double.maxFinite,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgTree,
                          width: 109.h,
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 233.v),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgTreeGreen400,
                          width: 68.h,
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.only(top: 303.v),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgTreeGreen400102x88,
                          width: 88.h,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 110.h),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgEllipse176,
                          height: 253.v,
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(bottom: 111.v),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgEllipse177,
                          width: 164.h,
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(bottom: 78.v),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgEllipse175,
                          height: 291.v,
                          alignment: Alignment.bottomCenter,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgMascot,
                          width: 191.h,
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(
                            right: 24.h,
                            bottom: 237.v,
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgUnionCyanA100,
                          width: 157.h,
                          alignment: Alignment.topRight,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgUnionCyanA10071x110,
                          height: 71.v,
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(
                            left: 18.h,
                            top: 21.v,
                          ),
                        ),
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
                                  decoration: AppDecoration
                                      .gradientGreenToLightGreen,
                                  onTap: () {
                                    onTapBtnUser(context);
                                  },
                                  child: CustomImageView(
                                    imagePath: ImageConstant.imgUser,
                                  ),
                                ),
                                SizedBox(height: 18.v),
                                CustomIconButton(
                                  height: 68.v,
                                  width: 266.h,
                                  padding: EdgeInsets.all(8.h),
                                  decoration: IconButtonStyleHelper
                                      .gradientDeepOrangeToOrange,
                                  child: CustomImageView(
                                    imagePath: ImageConstant.imgUser,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
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
          CustomImageView(
            imagePath: ImageConstant.imgCloseCyanA100,
            width: 59.h,
            margin: EdgeInsets.only(
              top: 18.v,
              bottom: 118.v,
            ),
            onTap: () {
              onTapImgClose(context);
            },
          ),
          Container(
            height: 232.v,
            width: 363.h,
            margin: EdgeInsets.only(left: 7.h),
            child: Stack(
              alignment: Alignment.bottomLeft,
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
