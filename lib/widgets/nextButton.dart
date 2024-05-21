  import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/custom_outlined_button.dart';

Widget buildNext(BuildContext context) {
    return Stack(
      children:[ 
        
        Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 113.h,
          padding: EdgeInsets.symmetric(horizontal: 10.h,vertical: 5.v),
          decoration: AppDecoration.outlineWhiteDeepOrangeA200.copyWith(borderRadius: BorderRadiusStyle.roundedBorder15),
          child: Center(
            child: Text(
               "lbl_next".tr,
               style: theme.textTheme.headlineMedium!.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
      Positioned(
        left: 20.h,
        top: 30.v,
        child: CustomImageView(
          height: 10,
          width: 20,
          fit: BoxFit.contain,
        imagePath:ImageConstant.imgShine ,
          
        ),
      )
      ]
    );
  }