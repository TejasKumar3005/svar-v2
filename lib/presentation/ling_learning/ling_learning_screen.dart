import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';

import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

class LingLearningScreen extends StatefulWidget {
  const LingLearningScreen({Key? key}) : super(key: key);

  @override
  LingLearningScreenState createState() => LingLearningScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LingLearningProvider(),
      child: LingLearningScreen(),
    );
  }
}

class LingLearningScreenState extends State<LingLearningScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LingLearningProvider lingLearningProvider =
        Provider.of<LingLearningProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImageConstant.imgGroup7),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildAppBar(context),
              Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.h,
                          vertical: 36.v,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgImage85,
                              height: 250.v,
                              width: 195.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 27.v),
                            GestureDetector(
                              onTap: () {
                                onTapNextBTNTextButton(context);
                              },
                              child: CustomImageView(
                                imagePath: ImageConstant.imgNextBtn,
                                height: 30
                                    .v, // Increase the height to make the button bigger
                                width: 60.h,
                                fit: BoxFit.contain,
                                // Increase the width to make the button bigger
                              ),
                            ),
                            SizedBox(height: 19.v)
                          ],
                          
                        ),
                        
                      ),

                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgProtaganist1,
                    height: 300.v,
                    width: 200.h,
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(right: 103.h),
                  ),
                ),
                 CustomImageView(
                        imagePath: ImageConstant.imgTipBtn,
                        height: 60.v,
                        width: 60.h,
                        alignment: Alignment.bottomRight,
                        margin: EdgeInsets.only(right: 50.h, bottom: 10.h),
                      )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 11.h,
        right: 6.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            height: 37.adaptSize,
            width: 37.adaptSize,
            padding: EdgeInsets.all(9.h),
            decoration:
                IconButtonStyleHelper.gradientDeepOrangeToDeepOrangeTL18,
            onTap: () {
              onTapBtnArrowDown(context);
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgBackBtn,
            ),
          ),
          Spacer(),
          CustomIconButton(
            height: 37.adaptSize,
            width: 37.adaptSize,
            padding: EdgeInsets.all(3.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgHomeBtn,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.h),
            child: CustomIconButton(
              height: 37.adaptSize,
              width: 37.adaptSize,
              padding: EdgeInsets.all(3.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgFullvolBtn,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Navigates to the phonemsLevelScreenTwoScreen when the action is triggered.
  onTapBtnArrowDown(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.phonemsLevelScreenTwoScreen,
    );
  }

  /// Navigates to the lingLearningQuickTipScreen when the action is triggered.
  onTapNextBTNTextButton(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.lingLearningQuickTipScreen,
    );
  }

  /// Navigates to the lingLearningQuickTipScreen when the action is triggered.
  onTapImgLaptop(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.lingLearningQuickTipScreen,
    );
  }
}
