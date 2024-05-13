import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

class AppStatsHeader extends StatelessWidget {
  const AppStatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: 47.h,
          right: 30.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgUserYellow700,
              height: 38.adaptSize,
              width: 38.adaptSize,
              onTap: () {
              
              },
            ),
            Container(
              height: 31.v,
              width: 198.h,
              margin: EdgeInsets.only(
                left: 5.h,
                bottom: 7.v,
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 12.v,
                      width: 186.h,
                      margin: EdgeInsets.only(top: 7.v),
                      decoration: AppDecoration.outlineOrangeA700.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgBarcode,
                        height: 10.v,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      height: 26.adaptSize,
                      width: 26.adaptSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgStar14,
                            height: 26.adaptSize,
                            width: 26.adaptSize,
                            radius: BorderRadius.circular(
                              1.h,
                            ),
                            alignment: Alignment.center,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "lbl_10".tr,
                              style: CustomTextStyles.nunitoWhiteA70001Black6,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 9.v,
                      width: 78.h,
                      decoration: BoxDecoration(
                        color: appTheme.deepOrange70001,
                        borderRadius: BorderRadius.circular(
                          4.h,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.h),
                      child: Text(
                        "lbl_2500_10000".tr,
                        style: CustomTextStyles.nunitoWhiteA70001Black6,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Container(
              height: 19.v,
              color: Colors.red,
              width: 78.h,
              margin: EdgeInsets.symmetric(vertical: 9.v),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(left: 13.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                        vertical: 1.v,
                      ),
                      decoration: AppDecoration.fillYellow.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: Container(
                        width: 50.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.h,
                          vertical: 1.v,
                        ),
                        decoration: AppDecoration.fillDeepOrange.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder5,
                        ),
                        child: Text(
                          "lbl_10000_10000".tr,
                          style: CustomTextStyles.nunitoWhiteA70001Bold,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "lbl2".tr,
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 19.v,
                      width: 17.h,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 17.v,
                              width: 13.h,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgUserDeepOrange600,
                                    width: 13.h,
                                    alignment: Alignment.center,
                                  ),
                                  CustomImageView(
                                    imagePath:
                                        ImageConstant.imgSettingsDeepOrange700,
                                    height: 11.v,
                                    alignment: Alignment.bottomCenter,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 19.v,
                              width: 16.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageView(
                                    imagePath: ImageConstant.imgClose,
                                    width: 16.h,
                                    alignment: Alignment.center,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height: 16.v,
                                      width: 11.h,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CustomImageView(
                                            imagePath:
                                                ImageConstant.imgCloseYellow90003,
                                            width: 11.h,
                                            alignment: Alignment.center,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "lbl3".tr,
                                              style: CustomTextStyles
                                                  .labelMediumYellow500,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 19.v,
              width: 78.h,
              margin: EdgeInsets.only(
                left: 17.h,
                top: 9.v,
                bottom: 9.v,
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(left: 13.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                        vertical: 1.v,
                      ),
                      decoration: AppDecoration.fillYellow.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: Container(
                        width: 50.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.h,
                          vertical: 1.v,
                        ),
                        decoration: AppDecoration.fillDeeporange70002.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder5,
                        ),
                        child: Text(
                          "lbl_10000_10000".tr,
                          style: CustomTextStyles.nunitoWhiteA70001Bold,
                        ),
                      ),
                    ),
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgUserYellow500,
                    width: 17.h,
                    alignment: Alignment.centerLeft,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "lbl2".tr,
                      style: theme.textTheme.labelMedium,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 19.h),
              child: CustomIconButton(
                height: 37.adaptSize,
                width: 37.adaptSize,
                padding: EdgeInsets.all(3.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgCloseWhiteA70001,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}