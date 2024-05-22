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
        context.watch<LingLearningProvider>();
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
                            Text(
                              lingLearningProvider.selectedCharacter,
                              style: theme.textTheme.displayLarge!
                                  .copyWith(fontSize: 45),
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
                
              ]),

              Align(
                  alignment: Alignment.bottomRight, // Adjust this as needed
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: 20.h, bottom: 5.h), // Adjust padding as needed
                    child: CustomImageView(
                      imagePath: ImageConstant.imgProtaganist1,
                      height: 420.v,
                      width: 200.h,
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: 1.h, bottom: 3.h), // Adjust padding as needed
                  child: CustomImageView(
                    height: 60.adaptSize,
                    width: 60.adaptSize,
                    fit: BoxFit.contain,
                    imagePath: ImageConstant.imgTipBtn,
                  ),
                ),
              ),
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
          Padding(
            padding: EdgeInsets.only(left: 1.h),
            child: CustomImageView(
              height: 38.adaptSize,
              width: 38.adaptSize,
              fit: BoxFit.contain,
              imagePath: ImageConstant.imgBackBtn,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(left: 1.h),
            child: CustomImageView(
              height: 38.adaptSize,
              width: 38.adaptSize,
              fit: BoxFit.contain,
              imagePath: ImageConstant.imgHomeBtn,
            ),
          ),
          SizedBox(width: 5),
          Padding(
            padding: EdgeInsets.only(left: 1.h),
            child: CustomImageView(
              height: 38.adaptSize,
              width: 38.adaptSize,
              fit: BoxFit.contain,
              imagePath: ImageConstant.imgFullvolBtn,
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
