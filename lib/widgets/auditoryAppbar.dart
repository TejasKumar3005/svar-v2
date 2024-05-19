import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/custom_image_view.dart';

Widget AuditoryAppBar(BuildContext context) {
  return Row(
    children: [
      Padding(
            padding: EdgeInsets.only(top: 1.v),
            child: CustomImageView(
              height: 37.v,
              fit: BoxFit.contain,
              width: 37.h,
              imagePath: ImageConstant.imgBackBtn,
            ),
          ),
          Spacer(),
          
        Container(
          height: 25.v,
          width: 50.h,
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
                  width: 50.h,
                  height: 25.v,
                  margin: EdgeInsets.only(left: 13.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.h,
                    vertical:3.v,
                  ),
                  decoration: AppDecoration.fillYellow.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder5,
                  ),
                  child: Center(
                    child: Container(
                      width: 55.h,
                      height: 25.v,
                      
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.h,
                        vertical: 1.v,
                      ),
                      decoration: AppDecoration.fillDeeporange70002.copyWith(
                        borderRadius: BorderRadius.circular(3.h),
                      ),
                      child: Center(
                        child: Text(
                          "0/16".tr,
                          style: CustomTextStyles.nunitoWhiteA70001Bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 2.h,
                child: Transform.rotate(
                  angle: -29 *3.14/180,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgStar14,
                    width: 25.h,
                    height: 24.v,
                  ),
                ),
              ),
                
            
            ],
          ),
        ),

        Container(
          height: 19.v,
          width: 90.h,
          margin: EdgeInsets.symmetric(vertical: 9.v),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 90.h,
                  height: 25.v,
                  margin: EdgeInsets.only(left: 13.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.h,
                    vertical: 3.v,
                  ),
                  decoration: AppDecoration.fillPink.copyWith(
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                  child: Container(
                    width: 80.h,
                    height: 25.v,
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
                        "0/10000".tr,
                        style: CustomTextStyles.nunitoWhiteA70001Bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right:3.h,
                child: Text(
                  "lbl2".tr,
                  style: theme.textTheme.labelMedium,
                ),
              ),
              Positioned(
                left: 5.h,
                child: CustomImageView(
                  imagePath: ImageConstant.imgCandy37x37,
                  width: 25.h,
                  height: 25.v,
                  fit: BoxFit.contain,
                ),
              ),
              
            ],
          ),
        ),
      Padding(
                padding: EdgeInsets.only(
                  left: 8.h,
                  top: 1.v,
                ),
                child: CustomImageView(
                  height: 37.v,
                  width: 37.h,
                  fit: BoxFit.contain,
                  imagePath: ImageConstant.imgReplayBtn,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8.h,
                  top: 1.v,
                ),
                child: CustomImageView(
                  height: 37.v,
                  width: 37.h,
                  fit: BoxFit.contain,
                  imagePath: ImageConstant.imgFullvolBtn,
                ),
              )
    ],
  );
}
