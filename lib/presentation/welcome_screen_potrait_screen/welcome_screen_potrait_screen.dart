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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.mainScreen),
              fit: BoxFit.cover, // Adjust the fit as needed
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
                                  onTap: () {
                                    onTapBtnUser(context);
                                  },
                                  child: CustomImageView(
                                    imagePath: ImageConstant.playBtn,
                                  ),
                                ),
                                SizedBox(height: 18.v),
                                CustomIconButton(
                                  height: 68.v,
                                  width: 266.h,
                                  onTap: () {
                                    // Add onTap function for settings button
                                  },
                                  child: CustomImageView(
                                    imagePath: ImageConstant.settingsBtn,
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
            imagePath: ImageConstant.imgBackBtn,
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
