
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key})
      : super(
          key: key,
        );

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
  static Widget builder(BuildContext context) {
    return 
       WelcomeScreen();
  }
}

class WelcomeScreenState extends State<WelcomeScreen> {
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
            color: appTheme.whiteA70001,
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgWelcomeScreen,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: 768.h,
            padding: EdgeInsets.symmetric(
              horizontal: 26.h,
              vertical: 16.v,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 12.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 355.v),
                      child: CustomIconButton(
                        height: 32.adaptSize,
                        width: 32.adaptSize,
                        padding: EdgeInsets.all(8.h),
                        decoration: IconButtonStyleHelper
                            .gradientDeepOrangeToDeepOrangeTL18,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgArrowDownWhiteA70001,
                        ),
                      ),
                    ),
                    Container(
                      height: 365.v,
                      width: 502.h,
                      margin: EdgeInsets.only(
                        left: 179.h,
                        top: 23.v,
                      ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgMascot173x143,
                            height: 253.v,
                            width: 216.h,
                            alignment: Alignment.bottomRight,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgSvarLogo146x288,
                            height: 146.v,
                            width: 288.h,
                            alignment: Alignment.topLeft,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 20.h,
                                right: 234.h,
                                bottom: 47.v,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconButton(
                                    height: 63.v,
                                    width: 248.h,
                                    padding: EdgeInsets.all(4.h),
                                    decoration: IconButtonStyleHelper
                                        .gradientPrimaryToLightGreenTL10,
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgShine,
                                    ),
                                  ),
                                  SizedBox(height: 10.v),
                                  CustomIconButton(
                                    height: 63.v,
                                    width: 248.h,
                                    padding: EdgeInsets.all(5.h),
                                    decoration: IconButtonStyleHelper
                                        .gradientDeepOrangeToOrangeTL10,
                                    child: CustomImageView(
                                      imagePath: ImageConstant.imgShine,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
