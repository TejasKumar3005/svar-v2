
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/auditory_screen_visual_learning_screen_resized_provider.dart';

class AuditoryScreenVisualLearningScreenResizedScreen extends StatefulWidget {
  const AuditoryScreenVisualLearningScreenResizedScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AuditoryScreenVisualLearningScreenResizedScreenState createState() =>
      AuditoryScreenVisualLearningScreenResizedScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuditoryScreenVisualLearningScreenResizedProvider(),
      child: AuditoryScreenVisualLearningScreenResizedScreen(),
    );
  }
}

class AuditoryScreenVisualLearningScreenResizedScreenState
    extends State<AuditoryScreenVisualLearningScreenResizedScreen> {
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 15.h,vertical: 10.v),
          decoration: BoxDecoration(
            color: appTheme.whiteA70001,
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgAuditoryScreen,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              _buildHomeBTN(context),
              Spacer(),
              Container(
              
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                        height: 40.adaptSize,
                      width: 40.adaptSize,
                      fit: BoxFit.contain,
                      imagePath: ImageConstant.imgArrowLeftYellow,
                    ),
                    CustomImageView(
                        height: 40.adaptSize,
                      width: 40.adaptSize,
                      fit: BoxFit.contain,
                      imagePath: ImageConstant.imgArrowRightGreen,
                    )
                  
                  ],
                ),
              )
                ,Spacer()
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHomeBTN(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          height: 37.v,
          width: 37.h,
          fit: BoxFit.contain,
          imagePath: ImageConstant.imgHomeBtn,
        ),
        Spacer(),
        Container(
          height: 35.v,
          width: 120.h,
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          decoration: AppDecoration.fillDeepOrange.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder10
          ),
          child: Center(
            child: Text("CLAPPING",
            style: theme.textTheme.titleMedium,
              
            ),
          ),
        ),
        Spacer(),
        CustomImageView(
            height: 37.v,
          width: 37.h,
          fit: BoxFit.contain,
          imagePath: ImageConstant.imgReplayBtn,
        ),
        CustomImageView(
            height: 37.v,
          width: 37.h,
          fit: BoxFit.contain,
          imagePath: ImageConstant.imgFullvolBtn,
        )
      ],
    );
  }

  /// Navigates to the auditoryScreenAssessmentScreenAudioVisualResizedScreen when the action is triggered.
  onTapBtnArrowLeft(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.auditoryScreenAssessmentScreenAudioVisualResizedScreen,
    );
  }
}
