import 'package:svar_new/widgets/custom_icon_button.dart';
import 'models/auditory_screen_assessment_screen_visual_audio_resiz_model.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/auditory_screen_assessment_screen_visual_audio_resiz_provider.dart';

class AuditoryScreenAssessmentScreenVisualAudioResizScreen
    extends StatefulWidget {
  const AuditoryScreenAssessmentScreenVisualAudioResizScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AuditoryScreenAssessmentScreenVisualAudioResizScreenState createState() =>
      AuditoryScreenAssessmentScreenVisualAudioResizScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          AuditoryScreenAssessmentScreenVisualAudioResizProvider(),
      child: AuditoryScreenAssessmentScreenVisualAudioResizScreen(),
    );
  }
}

class AuditoryScreenAssessmentScreenVisualAudioResizScreenState
    extends State<AuditoryScreenAssessmentScreenVisualAudioResizScreen> {
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
                ImageConstant.imgAuditoryScreen,
              ),
              fit: BoxFit.contain,
            ),
          ),
          child: Container(
            width: 768.h,
            padding: EdgeInsets.symmetric(
              horizontal: 44.h,
              vertical: 23.v,
            ),
            child: Column(
              children: [
                SizedBox(height: 17.v),
                _buildAppBar(context),
                SizedBox(height: 56.v),
                _buildOptionGRP(context)
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
              onTap: () {
                onTapBtnArrowDown(context);
              },
              child: CustomImageView(
                imagePath: ImageConstant.imgArrowDownWhiteA70001,
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgStar101,
                      height: 38.adaptSize,
                      width: 38.adaptSize,
                      radius: BorderRadius.circular(
                        1.h,
                      ),
                      alignment: Alignment.centerLeft,
                    )
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
                                  )
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
                            )
                          ],
                        ),
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgCandy1,
                      height: 36.adaptSize,
                      width: 36.adaptSize,
                      radius: BorderRadius.circular(
                        18.h,
                      ),
                      alignment: Alignment.centerLeft,
                    )
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
                    imagePath: ImageConstant.imgHomeBtn,
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
                    imagePath: ImageConstant.imgFullvolBtn,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildOptionGRP(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(1.h),
            decoration: AppDecoration.outlineBlack9001.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 1.v),
                Container(
                  height: 192.v,
                  width: 312.h,
                  decoration: AppDecoration.fillCyan.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder15,
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgGroupBlack90001192x312,
                    height: 192.v,
                    width: 312.h,
                    radius: BorderRadius.circular(
                      16.h,
                    ),
                    alignment: Alignment.center,
                  ),
                )
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgOptionGrp,
            height: 168.v,
            width: 325.h,
            margin: EdgeInsets.only(
              top: 13.v,
              bottom: 17.v,
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildNextBTNTextButton(BuildContext context) {
    return Container(
      width: 87.h,
      margin: EdgeInsets.only(
        left: 349.h,
        right: 330.h,
        bottom: 45.v,
      ),
      decoration: AppDecoration.gradientGreenToLightGreen.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgEllipse39,
                  height: 3.v,
                  width: 4.h,
                  margin: EdgeInsets.only(bottom: 5.v),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgUserWhiteA700019x9,
                  height: 9.v,
                  width: 8.h,
                  radius: BorderRadius.circular(
                    4.h,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 11.h),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 1.v),
                  decoration: AppDecoration.outlineBlack900,
                  child: Text(
                    "lbl_next2".tr.toUpperCase(),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowLeft,
                  height: 17.v,
                  width: 18.h,
                  margin: EdgeInsets.only(left: 8.h),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Navigates to the auditoryScreenAssessmentScreenAudioVisualResizedScreen when the action is triggered.
  onTapBtnArrowDown(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.auditoryScreenAssessmentScreenAudioVisualResizedScreen,
    );
  }
}
