import 'package:svar_new/presentation/ling_sound_assessment/ling_sound_assessment_provider.dart.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

class LingSoundAssessmentScreen extends StatefulWidget {
  const LingSoundAssessmentScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LingSoundAssessmentScreenState createState() =>
      LingSoundAssessmentScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LingSoundAssessmentProvider(),
      child: LingSoundAssessmentScreen(),
    );
  }
}

class LingSoundAssessmentScreenState extends State<LingSoundAssessmentScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.blueGray50,
        body: SizedBox(
          height: 432.v,
          width: 768.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.65,
                child: CustomImageView(
                  imagePath: ImageConstant.imgBg10,
                  height: 430.v,
                  width: 768.h,
                  alignment: Alignment.center,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 36.h,
                    vertical: 32.v,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 7.v),
                      _buildAppBar(context),
                      SizedBox(height: 32.v),
                      CustomImageView(
                        imagePath: ImageConstant.imgAudioSection,
                        height: 42.v,
                        width: 662.h,
                      ),
                      SizedBox(height: 23.v),
                      _buildOptnOne(context),
                      SizedBox(height: 27.v),
                      _buildNavigationBtn(context),
                    ],
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
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1.v),
            child: CustomIconButton(
              height: 37.adaptSize,
              width: 37.adaptSize,
              padding: EdgeInsets.all(9.h),
              decoration:
                  IconButtonStyleHelper.gradientDeepOrangeToDeepOrangeTL18,
              child: CustomImageView(
                imagePath: ImageConstant.imgArrowDownWhiteA7000137x37,
              ),
            ),
          ),
          Spacer(),
          SizedBox(
            height: 38.v,
            width: 63.h,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(left: 18.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.h,
                      vertical: 2.v,
                    ),
                    decoration: AppDecoration.fillOrange30002.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder5,
                    ),
                    child: Container(
                      width: 37.h,
                      padding: EdgeInsets.symmetric(horizontal: 6.h),
                      decoration: AppDecoration.fillYellow90002.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 1.v),
                          Text(
                            "lbl_0_16".tr,
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgStar102,
                  height: 38.adaptSize,
                  width: 38.adaptSize,
                  radius: BorderRadius.circular(
                    1.h,
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ],
            ),
          ),
          Container(
            height: 36.v,
            width: 125.h,
            margin: EdgeInsets.only(
              left: 9.h,
              top: 1.v,
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 18.h,
                      top: 8.v,
                      bottom: 8.v,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.h,
                      vertical: 1.v,
                    ),
                    decoration: AppDecoration.fillPink.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 1.v),
                          padding: EdgeInsets.symmetric(horizontal: 21.h),
                          decoration: AppDecoration.fillPink30001.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder5,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 1.v),
                              Text(
                                "lbl_0_10000".tr,
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 4.h,
                            bottom: 1.v,
                          ),
                          child: Text(
                            "lbl2".tr,
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgCandy36x36,
                  height: 36.adaptSize,
                  width: 36.adaptSize,
                  radius: BorderRadius.circular(
                    18.h,
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 22.h,
              top: 1.v,
            ),
            child: CustomIconButton(
              height: 37.adaptSize,
              width: 37.adaptSize,
              padding: EdgeInsets.all(3.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgSettingsWhiteA70001,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 8.h,
              top: 1.v,
            ),
            child: CustomIconButton(
              height: 37.adaptSize,
              width: 37.adaptSize,
              padding: EdgeInsets.all(3.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgSoundBtn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildOptnOne(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 19.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgOptn1,
            height: 144.v,
            width: 146.h,
            margin: EdgeInsets.only(bottom: 2.v),
          ),
          Container(
            height: 142.v,
            width: 144.h,
            margin: EdgeInsets.only(
              top: 1.v,
              bottom: 2.v,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 30.h,
              vertical: 1.v,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: fs.Svg(
                  ImageConstant.imgOptn2,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: CustomImageView(
              imagePath: ImageConstant.imgOpt21,
              height: 116.v,
              width: 81.h,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Container(
            height: 144.v,
            width: 145.h,
            margin: EdgeInsets.only(top: 1.v),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 143.v,
                    width: 142.h,
                    decoration: BoxDecoration(
                      color: appTheme.blue20001,
                      borderRadius: BorderRadius.circular(
                        18.h,
                      ),
                      border: Border.all(
                        color: appTheme.black900,
                        width: 2.h,
                      ),
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgOptn2,
                  height: 142.v,
                  width: 144.h,
                  alignment: Alignment.center,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgImage84128x135,
                  height: 128.v,
                  width: 135.h,
                  radius: BorderRadius.circular(
                    18.h,
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgOptn4Blue200,
            height: 144.adaptSize,
            width: 144.adaptSize,
            margin: EdgeInsets.only(top: 1.v),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNavigationBtn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomIconButton(
            height: 50.adaptSize,
            width: 50.adaptSize,
            padding: EdgeInsets.all(4.h),
            decoration: IconButtonStyleHelper.outlineWhiteA,
            child: CustomImageView(
              imagePath: ImageConstant.imgSoundBtn,
            ),
          ),
          CustomIconButton(
            height: 50.adaptSize,
            width: 50.adaptSize,
            padding: EdgeInsets.all(2.h),
            decoration: IconButtonStyleHelper.gradientGreenToLightGreenTL25,
            child: CustomImageView(
              imagePath: ImageConstant.imgUserWhiteA7000150x50,
            ),
          ),
        ],
      ),
    );
  }
}
