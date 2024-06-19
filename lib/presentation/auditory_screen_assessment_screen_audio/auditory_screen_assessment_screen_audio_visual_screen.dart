import 'package:svar_new/widgets/auditoryAppbar.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/auditory_screen_assessment_screen_audio_visual_provider.dart';


class AuditoryScreenAssessmentScreenAudioVisualScreen extends StatefulWidget {
  const AuditoryScreenAssessmentScreenAudioVisualScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AuditoryScreenAssessmentScreenAudioVisualScreenState createState() =>
      AuditoryScreenAssessmentScreenAudioVisualScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuditoryScreenAssessmentScreenAudioVisualProvider(),
      child: AuditoryScreenAssessmentScreenAudioVisualScreen(),
    );
  }
}

class AuditoryScreenAssessmentScreenAudioVisualScreenState
    extends State<AuditoryScreenAssessmentScreenAudioVisualScreen> {
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
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: 768.h,
            padding: EdgeInsets.symmetric(
              horizontal: 80.h,
              vertical: 39.v,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuditoryAppBar(context),
                SizedBox(height: 42.v),
                CustomImageView(
                  imagePath: ImageConstant.imgSpectrum,
                  height: 30.v,
                  width: 287.h,
                  radius: BorderRadius.circular(
                    9.h,
                  ),
                ),
                SizedBox(height: 12.v),
                _buildPaani(context),
                SizedBox(height: 5.v),
              ],
            ),
          ),
        ),
      ),
    );
  }

  

  /// Section Widget
  Widget _buildPaani(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            margin: EdgeInsets.all(0),
            color: appTheme.whiteA70001,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: appTheme.black900,
                width: 3.h,
              ),
              borderRadius: BorderRadiusStyle.roundedBorder15,
            ),
            child: Container(
              height: 199.v,
              width: 291.h,
              padding: EdgeInsets.symmetric(
                horizontal: 55.h,
                vertical: 23.v,
              ),
              decoration: AppDecoration.outlineBlack9002.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder15,
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "lbl_paani".tr,
                      style: CustomTextStyles.displayLargeNunitoGray90001,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 6.v),
                      child: Text(
                        "lbl4".tr,
                        style: CustomTextStyles
                            .displayLargeTiroDevanagariHindiGray90001,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 25.v,
              bottom: 4.v,
            ),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgOptions,
                  height: 111.v,
                  width: 361.h,
                ),
                SizedBox(height: 11.v),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.h,
                    vertical: 1.v,
                  ),
                  decoration:
                      AppDecoration.gradientGreenToLightgreen80001.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 12.h,
                          bottom: 10.v,
                        ),
                        child: Column(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgEllipse39WhiteA70001,
                              height: 3.v,
                              width: 4.h,
                              alignment: Alignment.centerRight,
                            ),
                            SizedBox(height: 5.v),
                            SizedBox(
                              width: 76.h,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    imagePath:
                                        ImageConstant.imgUserWhiteA7000119x18,
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
                        margin: EdgeInsets.only(bottom: 29.v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
