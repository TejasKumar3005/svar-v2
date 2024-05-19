import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';
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

  int sel = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: appTheme.gray300,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgAuditorybg,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.h,
              vertical: 10.v,
            ),
            child: Column(
              children: [
                AuditoryAppBar(context),
                SizedBox(height: 56.v),
                _buildOptionGRP(context),
                Spacer(),
                Center(
                  child: CustomImageView(
                    imagePath: ImageConstant.imgNext,
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ),
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
              height: 192.v,
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.all(1.h),
              decoration: AppDecoration.outlineBlack9001.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder15,
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgClap,
                radius: BorderRadiusStyle.roundedBorder15,
              )),
          Container(
            height: 192.v,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      sel = 0;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 80.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack.copyWith(
                        border: Border.all(
                          width: sel == 0 ? 2.3.h : 1.3.h,
                          color:
                              sel == 0 ? appTheme.green900 : appTheme.black900,
                        ),
                        borderRadius: BorderRadiusStyle.roundedBorder10),
                    child: Row(
                      children: [
                        CustomImageView(
                          height: 55.v,
                          width: 55.h,
                          fit: BoxFit.contain,
                          imagePath: ImageConstant.imgPlayBtn,
                        ),
                        Spacer(),
                        CustomImageView(
                          height: 65.v,
                          fit: BoxFit.contain,
                          width:
                              (MediaQuery.of(context).size.width * 0.4 - 80.h),
                          imagePath: ImageConstant.imgSpectrum,
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      sel = 1;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 80.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack9003.copyWith(
                        border: Border.all(
                          width: sel == 1 ? 2.3.h : 1.3.h,
                          color:
                              sel == 1 ? appTheme.green900 : appTheme.black900,
                        ),
                        borderRadius: BorderRadiusStyle.roundedBorder10),
                    child: Row(
                      children: [
                        CustomImageView(
                          height: 55.v,
                          width: 55.h,
                          fit: BoxFit.contain,
                          imagePath: ImageConstant.imgPlayBtn,
                        ),
                        Spacer(),
                        CustomImageView(
                          height: 65.v,
                          fit: BoxFit.contain,
                          width:
                              (MediaQuery.of(context).size.width * 0.4 - 80.h),
                          imagePath: ImageConstant.imgSpectrum,
                        )
                      ],
                    ),
                  ),
                ),
                Spacer()
              ],
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
