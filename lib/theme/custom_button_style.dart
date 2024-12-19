import 'package:flutter/material.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
// Gradient button style
  static BoxDecoration get gradientDeepOrangeToOrangeDecoration =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(10.h),
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 2.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.deepOrange10002,
            appTheme.orange900,
          ],
        ),
      );
  static BoxDecoration get gradientPrimaryToLightGreenDecoration =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(18.h),
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 4.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            theme.colorScheme.primary,
            appTheme.lightGreen80001,
          ],
        ),
      );
// text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
      );
}
