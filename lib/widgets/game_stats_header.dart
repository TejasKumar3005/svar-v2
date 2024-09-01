import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/providers/userDataProvider.dart';

class AppStatsHeader extends StatelessWidget {
  final double per;
  const AppStatsHeader({super.key, required this.per});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<UserDataProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.userProfileScreen);
          },
          child: SvgPicture.asset(
            ImageConstant.imgAvatar,
            height: 38.adaptSize,
            width: 38.adaptSize,
          ),
        ),
        Container(
          height: 31.v,
          width: 140.h,
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
                  width: 130.h,
                  margin: EdgeInsets.only(top: 7.v),
                  decoration: AppDecoration.outlineOrangeA700.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder5,
                  ),
                  child: SvgPicture.asset(
                    ImageConstant.imgBarcode,
                    height: 10.v,
                    fit: BoxFit.contain,
                    width: (130 *
                            (provider.userModel.auditory_current_level! / 10))
                        .h,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              Positioned(
                left: 115.h,
                top: 0,
                right: 0,
                child: SizedBox(
                  height: 26.adaptSize,
                  width: 26.adaptSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        ImageConstant.imgStar14,
                        height: 26.adaptSize,
                        width: 26.adaptSize,
                        alignment: Alignment.center,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          provider.userModel.auditory_current_level.toString(),
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
          width: 80.h,
          margin: EdgeInsets.symmetric(vertical: 9.v),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 90.h,
                  height: 19.v,
                  margin: EdgeInsets.only(left: 13.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.h,
                    vertical: 1.v,
                  ),
                  decoration: AppDecoration.fillPink.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder5,
                  ),
                  child: Container(
                    width: 80.h,
                    height: 19.v,
                    margin: EdgeInsets.only(right: 5.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.h,
                      vertical: 1.v,
                    ),
                    decoration: AppDecoration.fillPink300.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder5,
                    ),
                    child: Center(
                      child: Text(
                        provider.userModel.coins.toString(),
                        style: CustomTextStyles.nunitoWhiteA70001Bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 3.h,
                child: Text(
                  "lbl2".tr,
                  style: theme.textTheme.labelMedium,
                ),
              ),
              Positioned(
                left: 5.h,
                child: CustomImageView(
                  imagePath: ImageConstant.imgCandy37x37,
                  width: 20.h,
                  height: 21.v,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 19.v,
          width: 80.h,
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
                  width: 90.h,
                  height: 19.v,
                  margin: EdgeInsets.only(left: 13.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.h,
                    vertical: 1.v,
                  ),
                  decoration: AppDecoration.fillYellow.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder5,
                  ),
                  child: Container(
                    width: 90.h,
                    height: 19.v,
                    margin: EdgeInsets.only(right: 5.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.h,
                      vertical: 1.v,
                    ),
                    decoration: AppDecoration.fillDeeporange70002.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder5,
                    ),
                    child: Center(
                      child: Text(
                        provider.userModel.coins.toString(),
                        style: CustomTextStyles.nunitoWhiteA70001Bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 3.h,
                child: Text(
                  "lbl2".tr,
                  style: theme.textTheme.labelMedium,
                ),
              ),
              Positioned(
                left: 5.h,
                child: CustomImageView(
                  imagePath: ImageConstant.imgCoinSvg,
                  width: 20.h,
                  height: 21.v,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
