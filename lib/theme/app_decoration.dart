import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillDeepOrange => BoxDecoration(
        color: appTheme.deepOrange60001,
      );
  static BoxDecoration get fillDeeporange70002 => BoxDecoration(
        color: appTheme.deepOrange70002,
      );
  static BoxDecoration get fillLightGreen => BoxDecoration(
        color: appTheme.lightGreen800,
      );
  static BoxDecoration get fillOrange => BoxDecoration(
        color: appTheme.orange100,
      );
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA70001,
      );
  static BoxDecoration get fillYellow => BoxDecoration(
        color: appTheme.yellow90003,
      );

  // Gradient decorations
  static BoxDecoration get gradientGrayToLightBlueA => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.52, 0.33),
          end: Alignment(1, 0.61),
          colors: [
            appTheme.gray5003,
            appTheme.cyan200,
            appTheme.lightBlueA200,
          ],
        ),
      );
  static BoxDecoration get gradientRedToWhiteA => BoxDecoration(
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 5.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0, 0.5),
          end: Alignment(0.67, 0.5),
          colors: [
            appTheme.red100,
            appTheme.whiteA700,
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outlineOrange => BoxDecoration(
        color: appTheme.yellow70001,
        border: Border.all(
          color: appTheme.orange90001,
          width: 1.h,
          strokeAlign: strokeAlignOutside,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.amber900,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              1,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineOrangeA => BoxDecoration(
        color: appTheme.gray50,
        border: Border.all(
          color: appTheme.orangeA200,
          width: 4.h,
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineOrangeA200 => BoxDecoration(
        color: appTheme.whiteA70001,
        border: Border.all(
          color: appTheme.orangeA200,
          width: 1.h,
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineOrangeA2001 => BoxDecoration(
        color: appTheme.gray5004,
        border: Border.all(
          color: appTheme.orangeA200,
          width: 1.h,
          strokeAlign: strokeAlignOutside,
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.deepOrangeA100,
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(
              0,
              2,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineOrangeA2002 => BoxDecoration(
        color: appTheme.gray5004,
        border: Border.all(
          color: appTheme.orangeA200,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineOrangeA700 => BoxDecoration(
        color: appTheme.deepOrange200,
        border: Border.all(
          color: appTheme.orangeA700,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineWhiteA => BoxDecoration(
        color: appTheme.orange10001,
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 5.h,
        ),
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder14 => BorderRadius.circular(
        14.h,
      );

  // Custom borders
  static BorderRadius get customBorderTL5 => BorderRadius.horizontal(
        left: Radius.circular(5.h),
      );

  // Rounded borders
  static BorderRadius get roundedBorder1 => BorderRadius.circular(
        1.h,
      );
  static BorderRadius get roundedBorder10 => BorderRadius.circular(
        10.h,
      );
  static BorderRadius get roundedBorder20 => BorderRadius.circular(
        20.h,
      );
  static BorderRadius get roundedBorder5 => BorderRadius.circular(
        5.h,
      );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
