
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

class LingLearningQuickTipScreen extends StatefulWidget {
  const LingLearningQuickTipScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LingLearningQuickTipScreenState createState() =>
      LingLearningQuickTipScreenState();
  static Widget builder(BuildContext context) {
    return 
       LingLearningQuickTipScreen();
  }
}

class LingLearningQuickTipScreenState
    extends State<LingLearningQuickTipScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height:MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 100.h,
                    vertical: 66.v,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 70.v),
                      CustomImageView(
                        imagePath: ImageConstant.imgImage85,
                        height: 166.v,
                        width: 195.h,
                      ),
                      SizedBox(height: 23.v),
                      Container(
                        width: 114.h,
                        margin: EdgeInsets.only(
                          left: 40.h,
                          right: 413.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.h,
                          vertical: 1.v,
                        ),
                        decoration: AppDecoration.gradientGreenToLightgreen80001
                            .copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder10,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                                    imagePath:
                                        ImageConstant.imgUserWhiteA700018x9,
                                    height: 8.v,
                                    width: 9.h,
                                    radius: BorderRadius.circular(
                                      4.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 9.v),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                    height: 16.v,
                                    width: 19.h,
                                    margin: EdgeInsets.only(left: 8.h),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomImageView(
                imagePath: ImageConstant.imgProtaganist1,
                height: 663.v,
                width: 290.h,
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(right: 142.h),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 66.h,
                    vertical: 51.v,
                  ),
                  decoration: AppDecoration.outlineTeal.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 71.v),
                      Padding(
                        padding: EdgeInsets.only(right: 1.h),
                        child: Text(
                          "msg_parental_tip_box".tr,
                          style: CustomTextStyles.titleSmallPoppinsTeal900,
                        ),
                      ),
                      SizedBox(height: 3.v),
                      Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        margin: EdgeInsets.only(right: 13.h),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: appTheme.lime90002,
                            width: 2.h,
                          ),
                          borderRadius: BorderRadiusStyle.roundedBorder1,
                        ),
                        child: Container(
                          height: 109.v,
                          width: 121.h,
                          decoration: AppDecoration.outlineLime.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder1,
                          ),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgMouth1,
                                height: 109.v,
                                width: 121.h,
                                radius: BorderRadius.circular(
                                  1.h,
                                ),
                                alignment: Alignment.center,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 43.h,
                                    top: 9.v,
                                    right: 28.h,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomImageView(
                                        imagePath: ImageConstant.imgCheckmark,
                                        height: 15.adaptSize,
                                        width: 15.adaptSize,
                                      ),
                                      SizedBox(height: 2.v),
                                      Container(
                                        height: 6.adaptSize,
                                        width: 6.adaptSize,
                                        margin: EdgeInsets.only(right: 15.h),
                                        decoration: BoxDecoration(
                                          color: appTheme.deepOrangeA70001,
                                          borderRadius: BorderRadius.circular(
                                            3.h,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.v),
                                      CustomIconButton(
                                        height: 42.v,
                                        width: 39.h,
                                        padding: EdgeInsets.all(8.h),
                                        alignment: Alignment.centerLeft,
                                        child: CustomImageView(
                                          imagePath: ImageConstant.imgContrast,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.v),
                      SizedBox(
                        width: 152.h,
                        child: Text(
                          "msg_apply_a_drop_of".tr,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.labelLargeNunitoSansGray5002,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.h,
                    vertical: 36.v,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 4.h,
                          bottom: 322.v,
                        ),
                        child: CustomIconButton(
                          height: 37.adaptSize,
                          width: 37.adaptSize,
                          padding: EdgeInsets.all(9.h),
                          decoration: IconButtonStyleHelper
                              .gradientDeepOrangeToDeepOrangeTL18,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgArrowDownWhiteA70001,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 322.v),
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
                          left: 4.h,
                          bottom: 322.v,
                        ),
                        child: CustomIconButton(
                          height: 37.adaptSize,
                          width: 37.adaptSize,
                          padding: EdgeInsets.all(3.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgFullvolBtn,
                          ),
                        ),
                      ),
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
}
