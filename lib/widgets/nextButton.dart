  import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/custom_outlined_button.dart';

Widget buildNext(BuildContext context) {
    return Stack(
      children:[ Align(
        alignment: Alignment.centerRight,
        child: CustomOutlinedButton(
          width: 113.h,
          text: "lbl_next".tr,
          buttonStyle: CustomButtonStyles.none,
          decoration: CustomButtonStyles.gradientDeepOrangeToOrangeDecoration,
          onPressed: () {
            
          },
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