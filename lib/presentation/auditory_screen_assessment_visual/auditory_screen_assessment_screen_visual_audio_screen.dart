import 'package:svar_new/widgets/auditoryAppbar.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'models/auditory_screen_assessment_screen_visual_audio_model.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/auditory_screen_assessment_screen_visual_audio_provider.dart';

class AuditoryScreenAssessmentScreenVisualAudioScreen extends StatefulWidget {
  const AuditoryScreenAssessmentScreenVisualAudioScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AuditoryScreenAssessmentScreenVisualAudioScreenState createState() =>
      AuditoryScreenAssessmentScreenVisualAudioScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuditoryScreenAssessmentScreenVisualAudioProvider(),
      child: AuditoryScreenAssessmentScreenVisualAudioScreen(),
    );
  }
}

class AuditoryScreenAssessmentScreenVisualAudioScreenState
    extends State<AuditoryScreenAssessmentScreenVisualAudioScreen> {
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
        backgroundColor: appTheme.gray300,
        body: Container(
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            color: appTheme.gray300,
            image: DecorationImage(
              image: fs.Svg(
                ImageConstant.imgAuditorybg,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: 768.h,
            padding: EdgeInsets.symmetric(
              horizontal: 44.h,
              vertical: 21.v,
            ),
            child: Column(
              children: [
                SizedBox(height: 18.v),
                AuditoryAppBar(context),
                SizedBox(height: 47.v),
                _buildVector(context),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildNextBTNTextButton(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                      imagePath: ImageConstant.imgStar107,
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
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildVector(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15.h,
        right: 5.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 204.v,
            width: 327.h,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(1.h),
                    decoration: AppDecoration.outlineBlack9005.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder15,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 1.v),
                        Container(
                          height: 198.v,
                          width: 321.h,
                          decoration: BoxDecoration(
                            color: appTheme.lightBlue50,
                            borderRadius: BorderRadius.circular(
                              16.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 111.h,
                      right: 95.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.h),
                          child: Text(
                            "lbl_paani".tr,
                            style: CustomTextStyles.displaySmallNunito,
                          ),
                        ),
                        SizedBox(height: 3.v),
                        CustomImageView(
                          imagePath: ImageConstant.imgGroup,
                          height: 128.v,
                          width: 119.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgOptionsDeepOrangeA200,
            height: 147.v,
            width: 284.h,
            margin: EdgeInsets.only(
              top: 28.v,
              bottom: 29.v,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNextBTNTextButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 346.h,
        right: 333.h,
        bottom: 49.v,
      ),
      decoration: AppDecoration.gradientGreenToLightGreen.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Container(
        decoration: AppDecoration.gradientGreenToLightGreen.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgEllipse39WhiteA70001,
                    height: 3.v,
                    width: 4.h,
                    alignment: Alignment.centerRight,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5.v,
                      right: 2.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 2.v,
                            bottom: 1.v,
                          ),
                          decoration: AppDecoration.outlineBlack900,
                          child: Text(
                            "lbl_next2".tr.toUpperCase(),
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgUserWhiteA7000119x18,
                          height: 19.v,
                          width: 18.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgUserWhiteA7000110x9,
              height: 10.v,
              width: 9.h,
              radius: BorderRadius.circular(
                4.h,
              ),
              margin: EdgeInsets.only(bottom: 19.v),
            ),
          ],
        ),
      ),
    );
  }
}
