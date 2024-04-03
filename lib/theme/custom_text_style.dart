import 'package:flutter/material.dart';
import 'package:svar_new/core/utils/size_utils.dart';
import 'package:svar_new/theme/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Display text style
  static get displaySmallNunitoTeal90004 =>
      theme.textTheme.displaySmall!.nunito.copyWith(
        color: appTheme.teal90004,
        fontWeight: FontWeight.w900,
      );
  // Label text style
  static get labelLarge12 => theme.textTheme.labelLarge!.copyWith(
        fontSize: 12.fSize,
      );
  static get labelMediumYellow500 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.yellow500,
      );
  // Nunito text style
  static get nunitoTeal90004 => TextStyle(
        color: appTheme.teal90004,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w900,
      ).nunito;
  static get nunitoTeal90004ExtraBold => TextStyle(
        color: appTheme.teal90004,
        fontSize: 6.fSize,
        fontWeight: FontWeight.w800,
      ).nunito;
  static get nunitoWhiteA70001Black6 => TextStyle(
        color: appTheme.whiteA70001,
        fontSize: 6.fSize,
        fontWeight: FontWeight.w900,
      ).nunito;
  static get nunitoWhiteA70001Bold => TextStyle(
        color: appTheme.whiteA70001,
        fontSize: 5.fSize,
        fontWeight: FontWeight.w700,
      ).nunito;
  // Title text style
  static get titleLarge21 => theme.textTheme.titleLarge!.copyWith(
        fontSize: 21.fSize,
      );
}

extension on TextStyle {
  TextStyle get nunito {
    return copyWith(
      fontFamily: 'Nunito',
    );
  }
}
