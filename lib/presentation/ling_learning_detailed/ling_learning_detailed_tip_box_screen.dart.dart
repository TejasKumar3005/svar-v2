import 'package:svar_new/presentation/ling_learning_detailed/ling_learning_detailed_tip_box_provider.dart.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

class LingLearningDetailedTipBoxScreen extends StatefulWidget {
  const LingLearningDetailedTipBoxScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LingLearningDetailedTipBoxScreenState createState() =>
      LingLearningDetailedTipBoxScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LingLearningDetailedTipBoxProvider(),
      child: LingLearningDetailedTipBoxScreen(),
    );
  }
}

class LingLearningDetailedTipBoxScreenState
    extends State<LingLearningDetailedTipBoxScreen> {
  @override
  void initState() {
    super.initState();
    NavigatorService.pushNamed(
      AppRoutes.tipBoxVideoScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: 432.v,
          width: 768.h,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.h,
                    vertical: 36.v,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        ImageConstant.imgGroup7,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAppBar(context),
                      SizedBox(height: 56.v),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(left: 84.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 14.v),
                                child: Column(
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.imgImage85,
                                      height: 166.v,
                                      width: 195.h,
                                    ),
                                    SizedBox(height: 27.v),
                                    GestureDetector(
                                      onTap: () {
                                        onTapNextBTNTextButton(context);
                                      },
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.imgNextBtn,
                                                  height: 30
                                                      .v, // Increase the height to make the button bigger
                                                  width: 60.h,
                                                  // Increase the width to make the button bigger
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgLaptop,
                                height: 86.v,
                                width: 88.h,
                                margin: EdgeInsets.only(top: 160.v),
                                onTap: () {
                                  onTapImgLaptop(context);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 19.v)
                    ],
                  ),
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgProtaganist1,
                height: 663.v,
                width: 310.h,
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(right: 103.h),
              ),
              SizedBox(height: 5.v),
              SizedBox(
                width: 150.h, // Reduced width for the text box
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "msg_apply_a_drop_of".tr,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.labelLargeNunitoSansGray5002,
                  ),
                ),
              ),
              SizedBox(height: 6.v),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            height: 37.adaptSize,
            width: 37.adaptSize,
            padding: EdgeInsets.all(9.h),
            decoration:
                IconButtonStyleHelper.gradientDeepOrangeToDeepOrangeTL18,
            child: CustomImageView(
              imagePath: ImageConstant.imgArrowDownWhiteA70001,
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

  /// Navigates to the tipBoxVideoScreen when the action is triggered.
  onTapBtnUser(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.tipBoxVideoScreen,
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
