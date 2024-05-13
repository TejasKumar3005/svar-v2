import 'package:flutter/material.dart';
import 'package:svar_new/core/utils/size_utils.dart';
import 'package:svar_new/theme/theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
// Display text style
  static get displayLargeNunitoGray90001 =>
      theme.textTheme.displayLarge!.nunito.copyWith(
        color: appTheme.gray90001,
        fontSize: 65.fSize,
      );
  static get displayLargeNunitoTeal90003 =>
      theme.textTheme.displayLarge!.nunito.copyWith(
        color: appTheme.teal90003,
        fontSize: 60.fSize,
        fontWeight: FontWeight.w900,
      );
  static get displayLargeTiroDevanagariHindi =>
      theme.textTheme.displayLarge!.tiroDevanagariHindi.copyWith(
        fontSize: 55.fSize,
        fontWeight: FontWeight.w400,
      );
  static get displayLargeTiroDevanagariHindiGray90001 =>
      theme.textTheme.displayLarge!.tiroDevanagariHindi.copyWith(
        color: appTheme.gray90001,
        fontWeight: FontWeight.w400,
      );
  static get displayMediumMaterialIconsOrangeA700 =>
      theme.textTheme.displayMedium!.materialIcons.copyWith(
        color: appTheme.orangeA700,
      );
  static get displaySmallNunito =>
      theme.textTheme.displaySmall!.nunito.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get displaySmallNunitoTeal90003 =>
      theme.textTheme.displaySmall!.nunito.copyWith(
        color: appTheme.teal90003,
        fontWeight: FontWeight.w900,
      );
  static get displaySmallNunitoteal90003 =>
      theme.textTheme.displaySmall!.nunito.copyWith(
        color: appTheme.teal90003,
        fontWeight: FontWeight.w900,
      );
  static get displaySmallNunitoWhiteA70001 =>
      theme.textTheme.displaySmall!.nunito.copyWith(
        color: appTheme.whiteA70001,
        fontSize: 35.fSize,
        fontWeight: FontWeight.w900,
      );
// Headline text style
  static get headlineLargeBlack => theme.textTheme.headlineLarge!.copyWith(
        fontSize: 32.fSize,
        fontWeight: FontWeight.w900,
      );
  static get headlineMediumWhiteA70001 =>
      theme.textTheme.headlineMedium!.copyWith(
        color: appTheme.whiteA70001,
        fontSize: 29.fSize,
        fontWeight: FontWeight.w800,
      );
// Label text style
  static get labelLarge12 => theme.textTheme.labelLarge!.copyWith(
        fontSize: 12.fSize,
      );
  static get labelLargeNunitoSansGray5002 =>
      theme.textTheme.labelLarge!.nunitoSans.copyWith(
        color: appTheme.gray5002,
        fontSize: 12.fSize,
        fontWeight: FontWeight.w700,
      );
  static get labelMediumGray90002 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.gray90002,
        fontSize: 10.fSize,
        fontWeight: FontWeight.w800,
      );
  static get labelMediumOnErrorContainer =>
      theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.onErrorContainer,
        fontSize: 10.fSize,
        fontWeight: FontWeight.w800,
      );
  static get labelMediumTeal90001 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.teal90001,
        fontSize: 10.fSize,
        fontWeight: FontWeight.w800,
      );
  static get labelMediumYellow500 => theme.textTheme.labelMedium!.copyWith(
        color: appTheme.yellow500,
      );
  static get labelSmallBlack => theme.textTheme.labelSmall!.copyWith(
        fontSize: 8.fSize,
        fontWeight: FontWeight.w900,
      );
  static get labelSmallTeal90001 => theme.textTheme.labelSmall!.copyWith(
        color: appTheme.teal90001,
        fontSize: 8.fSize,
        fontWeight: FontWeight.w800,
      );
// Nunito text style
  static get nunitoTeal90001 => TextStyle(
        color: appTheme.teal90001,
        fontSize: 5.fSize,
        fontWeight: FontWeight.w800,
      ).nunito;
  static get nunitoTeal90003 => TextStyle(
        color: appTheme.teal90003,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w900,
      ).nunito;
  static get nunitoTeal90003ExtraBold => TextStyle(
        color: appTheme.teal90003,
        fontSize: 6.fSize,
        fontWeight: FontWeight.w800,
      ).nunito;
  static get nunitoteal90003 => TextStyle(
        color: appTheme.teal90003,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w900,
      ).nunito;
  static get nunitoteal90003ExtraBold => TextStyle(
        color: appTheme.teal90003,
        fontSize: 6.fSize,
        fontWeight: FontWeight.w800,
      ).nunito;
  static get nunitoWhiteA70001 => TextStyle(
        color: appTheme.whiteA70001,
        fontSize: 5.fSize,
        fontWeight: FontWeight.w900,
      ).nunito;
  static get nunitoWhiteA70001Black => TextStyle(
        color: appTheme.whiteA70001,
        fontSize: 5.fSize,
        fontWeight: FontWeight.w900,
      ).nunito;
  static get nunitoWhiteA70001Black3 => TextStyle(
        color: appTheme.whiteA70001,
        fontSize: 3.fSize,
        fontWeight: FontWeight.w900,
      ).nunito;
  static get nunitoWhiteA70001Black6 => TextStyle(
        color: appTheme.whiteA70001,
        fontSize: 6.fSize,
        fontWeight: FontWeight.w900,
      ).nunito;
  static get nunitoWhiteA70001Black7 => TextStyle(
        color: appTheme.whiteA70001,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w900,
      ).nunito;
  static get nunitoWhiteA70001Bold => TextStyle(
        color: appTheme.whiteA70001,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w700,
      ).nunito;
  static get nunitoWhiteA70001ExtraBold => TextStyle(
        color: appTheme.whiteA70001,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w800,
      ).nunito;
// Title text style
  static get titleLarge21 => theme.textTheme.titleLarge!.copyWith(
        fontSize: 21.fSize,
      );
  static get titleLarge22 => theme.textTheme.titleLarge!.copyWith(
        fontSize: 22.fSize,
      );
  static get titleMedium16 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 16.fSize,
      );
  static get titleMedium17 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 17.fSize,
      );
  static get titleMedium19 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 19.fSize,
      );
  static get titleMediumNunitoSansTeal900 =>
      theme.textTheme.titleMedium!.nunitoSans.copyWith(
        color: appTheme.teal900,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleMediumTeal90003 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.teal90003,
        fontSize: 17.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallPoppinsTeal900 =>
      theme.textTheme.titleSmall!.poppins.copyWith(
        color: appTheme.teal900,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallTeal90001 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.teal90001,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w700,
      );
}

extension on TextStyle {
  TextStyle get tiroDevanagariHindi {
    return copyWith(
      fontFamily: 'Tiro Devanagari Hindi',
    );
  }

  TextStyle get nunitoSans {
    return copyWith(
      fontFamily: 'Nunito Sans',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get nunito {
    return copyWith(
      fontFamily: 'Nunito',
    );
  }

  TextStyle get jokerman {
    return copyWith(
      fontFamily: 'Jokerman',
    );
  }

  TextStyle get materialIcons {
    return copyWith(
      fontFamily: 'Material Icons',
    );
  }
}
