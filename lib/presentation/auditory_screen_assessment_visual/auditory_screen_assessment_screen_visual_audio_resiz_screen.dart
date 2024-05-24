
import 'package:svar_new/widgets/auditoryAppbar.dart';
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
    var provider =
        context.watch<AuditoryScreenAssessmentScreenVisualAudioResizProvider>();
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
                _buildOptionGRP(context, provider),
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
  Widget _buildOptionGRP(BuildContext context,
      AuditoryScreenAssessmentScreenVisualAudioResizProvider provider) {
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
          buildDynamicOptions(provider.quizType, provider)
        ],
      ),
    );
  }

  Widget buildDynamicOptions(String quizType,
      AuditoryScreenAssessmentScreenVisualAudioResizProvider provider) {
    switch (quizType) {
      case "VOICE":
        return Row();
      case "FIG_TO_WORD":
        return Container(
          height: 192.v,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            children: [
              Container(
                
                    height: 130.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack9003.copyWith(
                      color: appTheme.deepOrangeA200,
                        border: Border.all(
                          width: provider.sel == 1 ? 2.3.h : 1.3.h,
                          color: provider.sel == 1
                              ? appTheme.green900
                              : appTheme.black900,
                          
                        ),
                        image: DecorationImage(image: AssetImage("assets/images/radial_ray_orange.png"),fit:BoxFit.cover),
                        borderRadius: BorderRadiusStyle.roundedBorder10),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(provider.optStrings1[0],style: theme.textTheme.labelMedium,),
                              SizedBox(height: 8.v,),
                              Text(provider.optStrings1[1],style: theme.textTheme.labelSmall,),
                            ],
                          ),
                        ),
                      
              ),
              Container(
                
                    height: 130.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack9003.copyWith(
                      color: appTheme.teal90001,
                        border: Border.all(
                          width: provider.sel == 1 ? 2.3.h : 1.3.h,
                          color: provider.sel == 1
                              ? appTheme.green900
                              : appTheme.black900,
                          
                        ),
                        image: DecorationImage(image: AssetImage("assets/images/radial_ray_green.png"),fit:BoxFit.cover),
                        borderRadius: BorderRadiusStyle.roundedBorder10),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(provider.optStrings2[0],style: theme.textTheme.labelMedium,),
                              SizedBox(height: 8.v,),
                              Text(provider.optStrings2[1],style: theme.textTheme.labelSmall,),
                            ],
                          ),
                        ),
                      
              ),
            ],
          ),
        );  
      case "WORD_TO_FIG":
        return Container(
          height: 192.v,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            children: [
              Container(
                
                    height: 130.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack9003.copyWith(
                        border: Border.all(
                          width: provider.sel == 1 ? 2.3.h : 1.3.h,
                          color: provider.sel == 1
                              ? appTheme.green900
                              : appTheme.black900,
                          
                        ),
                        image: DecorationImage(image: AssetImage("assets/images/radial_ray_yellow.png"),fit:BoxFit.cover),
                        borderRadius: BorderRadiusStyle.roundedBorder10),
                        child: Center(
                          child: Image.network(provider.optionFigures[0],fit: BoxFit.contain,height: 70.v,width: 50.v,),
                        ),
                      
              ),
              Container(
                
                    height: 130.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack9003.copyWith(
                        border: Border.all(
                          width: provider.sel == 1 ? 2.3.h : 1.3.h,
                          color: provider.sel == 1
                              ? appTheme.green900
                              : appTheme.black900,
                          
                        ),
                        image: DecorationImage(image: AssetImage("assets/images/radial_ray_yellow.png"),fit:BoxFit.cover),
                        borderRadius: BorderRadiusStyle.roundedBorder10),
                        child: Center(
                          child: Image.network(provider.optionFigures[1],fit: BoxFit.contain,height: 70.v,width: 50.v,),
                        ),
                      
              ),
            ],
          ),
        );
      default:
        return Container(
            height: 192.v,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    provider.setSelected(0);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 80.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack.copyWith(
                        border: Border.all(
                          width: provider.sel == 0 ? 2.3.h : 1.3.h,
                          color: provider.sel == 0
                              ? appTheme.green900
                              : appTheme.black900,
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
                    provider.setSelected(1);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 80.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack9003.copyWith(
                        border: Border.all(
                          width: provider.sel == 1 ? 2.3.h : 1.3.h,
                          color: provider.sel == 1
                              ? appTheme.green900
                              : appTheme.black900,
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
            ));
    }
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
