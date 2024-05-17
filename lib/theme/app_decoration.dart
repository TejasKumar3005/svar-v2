import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

class AppDecoration {
// Fill decorations
  static BoxDecoration get fillAmber => BoxDecoration(
        color: appTheme.amber100,
      );
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray50,
      );
  static BoxDecoration get fillCyan => BoxDecoration(
        color: appTheme.cyan500,
      );
  static BoxDecoration get fillCyanA => BoxDecoration(
        color: appTheme.cyanA40001,
      );
  static BoxDecoration get fillDeepOrange => BoxDecoration(
        color: appTheme.deepOrange60001,
      );
  static BoxDecoration get fillDeeporange70002 => BoxDecoration(
        color: appTheme.deepOrange70002,
      );
  static BoxDecoration get fillDeepOrange10 =>
      BoxDecoration(color: appTheme.deepOrande10);
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray300,
      );
  static BoxDecoration get fillLightGreen => BoxDecoration(
        color: appTheme.lightGreen800,
      );
  static BoxDecoration get fillOrange => BoxDecoration(
        color: appTheme.orange100,
      );
  static BoxDecoration get fillOrange30002 => BoxDecoration(
        color: appTheme.orange30002,
      );
  static BoxDecoration get fillPink => BoxDecoration(
        color: appTheme.pink900,
      );
  static BoxDecoration get fillPink300 => BoxDecoration(
        color: appTheme.pink300,
      );
  static BoxDecoration get fillPink30001 => BoxDecoration(
        color: appTheme.pink30001,
      );
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA70001,
      );
  static BoxDecoration get fillYellow => BoxDecoration(
        color: appTheme.yellow90003,
      );
  static BoxDecoration get fillYellow90002 => BoxDecoration(
        color: appTheme.yellow90002,
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
  static BoxDecoration get gradientGreenToLightGreen => BoxDecoration(
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 2.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.green300,
            appTheme.lightGreenA700,
            appTheme.lightGreen80001,
          ],
        ),
      );
  static BoxDecoration get gradientGreenToLightgreen80001 => BoxDecoration(
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 2.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.green300,
            appTheme.lightGreenA700,
            appTheme.lightGreen80001,
          ],
        ),
      );
  static BoxDecoration get gradientLightGreenToTeal => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.47, 0.06),
          end: Alignment(0.59, 1.61),
          colors: [
            appTheme.lightGreen400,
            appTheme.teal800,
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
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: appTheme.blue20001,
        border: Border.all(
          color: appTheme.black900,
          width: 3.h,
        ),
      );
  static BoxDecoration get outlineBlack900 => BoxDecoration();
  static BoxDecoration get outlineBlack9001 => BoxDecoration(
        color: appTheme.blue20001,
        border: Border.all(
          color: appTheme.black900,
          width: 2.h,
        ),
      );

  static BoxDecoration get outlineFilledBlue => BoxDecoration(
        color: appTheme.blue20001,
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 1.h,
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineBlack9002 => BoxDecoration(
        color: appTheme.whiteA70001,
        border: Border.all(
          color: appTheme.black900,
          width: 3.h,
        ),
      );
  static BoxDecoration get outlineBlack9003 => BoxDecoration(
        color: appTheme.deepOrangeA200,
        border: Border.all(
          color: appTheme.black900,
          width: 3.h,
        ),
      );
  static BoxDecoration get outlineBlack9004 => BoxDecoration(
        color: appTheme.teal90001,
        border: Border.all(
          color: appTheme.black900,
          width: 3.h,
        ),
      );
  static BoxDecoration get outlineBlack9005 => BoxDecoration(
        color: appTheme.lightBlue50,
        border: Border.all(
          color: appTheme.black900,
          width: 2.h,
        ),
      );
  static BoxDecoration get outlineBlackYellow => BoxDecoration(
        color: appTheme.yellow500,
        border: Border.all(
          color: appTheme.black900,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBlack9006 => BoxDecoration(
        color: appTheme.orange400,
        border: Border.all(
          color: appTheme.black900,
          width: 2.h,
          strokeAlign: strokeAlignCenter,
        ),
      );
  static BoxDecoration get outlineErrorContainer => BoxDecoration();
  static BoxDecoration get outlineLime => BoxDecoration(
        border: Border.all(
          color: appTheme.lime90002,
          width: 2.h,
          strokeAlign: strokeAlignCenter,
        ),
      );
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
  static BoxDecoration get outlineTeal => BoxDecoration(
        color: appTheme.orange400,
        border: Border.all(
          color: appTheme.teal900,
          width: 2.h,
        ),
      );
  static BoxDecoration get outlineWhiteA => BoxDecoration(
        color: appTheme.orange10001,
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 5.h,
        ),
      );
  static BoxDecoration get outlineWhiteA70001 => BoxDecoration(
        color: appTheme.orangeA200,
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 5.h,
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineWhiteDeepOrangeA200 => BoxDecoration(
        color: appTheme.deepOrangeA200,
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 5.h,
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineWhiteA700011 => BoxDecoration(
        color: appTheme.amber60001,
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 2.h,
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineWhiteA700012 => BoxDecoration(
        color: appTheme.deepOrangeA400,
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 2.h,
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineWhiteA700013 => BoxDecoration(
        color: appTheme.deepOrange70003,
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 2.h,
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineWhiteA700014 => BoxDecoration(
        color: appTheme.yellow500,
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 1.h,
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineWhiteA700015 => BoxDecoration(
        color: appTheme.deepOrange400,
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 3.h,
        ),
      );
}

class BorderRadiusStyle {
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
  static BorderRadius get roundedBorder15 => BorderRadius.circular(
        15.h,
      );
  static BorderRadius get roundedBorder20 => BorderRadius.circular(
        20.h,
      );
  static BorderRadius get roundedBorder27 => BorderRadius.circular(
        27.h,
      );
  static BorderRadius get roundedBorder36 => BorderRadius.circular(
        36.h,
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
