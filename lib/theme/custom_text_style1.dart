import 'package:flutter/material.dart';

extension on TextStyle {
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
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
// Label text style
static get labelMediumGray90001 => theme.textTheme.labelMedium!.copyWith(
color: appTheme.gray90001,
fontSize: 10.fSize,
fontWeight: FontWeight.w800,
);
static get labelMediumTeal900 => theme.textTheme.labelMedium!.copyWith(
color: appTheme.teal900,
fontSize: 10.fSize,
fontWeight: FontWeight.w800,
);
static get labelMediumYellow50001 => theme.textTheme.labelMedium!.copyWith(
color: appTheme.yellow50001,
);
static get labelSmallTeal900 => theme.textTheme.labelSmall!.copyWith(
color: appTheme.teal900,
fontWeight: FontWeight.w800,
);
// Nunito text style
static get nunitoTeal900 => TextStyle(
color: appTheme.teal900,
fontSize: 5.fSize,
fontWeight: FontWeight.w800,
).nunito;
static get nunitoWhiteA700 => TextStyle(
color: appTheme.whiteA700,
fontSize: 5.fSize,
fontWeight: FontWeight.w900,
).nunito;
static get nunitoWhiteA700Black => TextStyle(
color: appTheme.whiteA700,
fontSize: 5.fSize,
fontWeight: FontWeight.w900,
).nunito;
static get nunitoWhiteA700Black3 => TextStyle(
color: appTheme.whiteA700,
fontSize: 3.fSize,
fontWeight: FontWeight.w900,
).nunito;
static get nunitoWhiteA700Black6 => TextStyle(
color: appTheme.whiteA700,
fontSize: 6.fSize,
fontWeight: FontWeight.w900,
).nunito;
static get nunitoWhiteA700Black7 => TextStyle(
color: appTheme.whiteA700,
fontSize: 7.fSize,
fontWeight: FontWeight.w900,
).nunito;
static get nunitoWhiteA700Bold => TextStyle(
color: appTheme.whiteA700,
fontSize: 7.fSize,
fontWeight: FontWeight.w700,
).nunito;
static get nunitoWhiteA700ExtraBold => TextStyle(
color: appTheme.whiteA700,
fontSize: 7.fSize,
fontWeight: FontWeight.w800,
).nunito;
}

