import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class ThemeHelper {
// The current app theme
var _appTheme = PrefUtils().getThemeData();

// A map of custom color themes supported by the app
Map<String, LightCodeColors> _supportedCustomColor = {
'lightCode': LightCodeColors()
};

// A map of color schemes supported by the app
Map<String, ColorScheme> _supportedColorScheme = {
'lightCode': ColorSchemes.lightCodeColorScheme
};

/// Returns the lightCode colors for the current theme.
LightCodeColors _getThemeColors() {
return _supportedCustomColor[_appTheme] ?? LightCodeColors();
}

/// Returns the current theme data.
ThemeData _getThemeData() {
var colorScheme =
_supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
return ThemeData(
visualDensity: VisualDensity.standard,
colorScheme: colorScheme,
textTheme: TextThemes.textTheme(colorScheme),
scaffoldBackgroundColor: appTheme.deepOrangeA100,
elevatedButtonTheme: ElevatedButtonThemeData(
style: ElevatedButton.styleFrom(
backgroundColor: appTheme.blueGray50,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(5),
),
visualDensity: const VisualDensity(
vertical: -4,
horizontal: -4,
),
padding: EdgeInsets.zero,
),
),
dividerTheme: DividerThemeData(
thickness: 5,
space: 5,
),
);
}

/// Returns the lightCode colors for the current theme.
LightCodeColors themeColor() => _getThemeColors();

/// Returns the current theme data.
ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
displayMedium: TextStyle(
color: appTheme.whiteA700,
fontSize: 45.fSize,
fontFamily: 'Jokerman',
fontWeight: FontWeight.w400,
),
labelMedium: TextStyle(
color: appTheme.whiteA700,
fontSize: 11.fSize,
fontFamily: 'Nunito',
fontWeight: FontWeight.w900,
),
labelSmall: TextStyle(
color: appTheme.whiteA700,
fontSize: 8.fSize,
fontFamily: 'Nunito',
fontWeight: FontWeight.w900,
),
);
}

/// Class containing the supported color schemes.
class ColorSchemes {
static final lightCodeColorScheme = ColorScheme.light();
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
// Amber
Color get amber900 => Color(0XFFFF7300);
// Black
Color get black900 => Color(0XFF030303);
Color get black90001 => Color(0XFF000000);
Color get black90059 => Color(0X590E0000);
// Blackf
Color get black9003f => Color(0X3F000000);
// Blue
Color get blue200 => Color(0XFF87CEEB);
Color get blue20001 => Color(0XFF91BDFF);
Color get blue300 => Color(0XFF5B9DFF);
Color get blueA200 => Color(0XFF4299FF);
// BlueGray
Color get blueGray100 => Color(0XFFCCCCCC);
Color get blueGray10001 => Color(0XFFD3D3D3);
Color get blueGray10002 => Color(0XFFCBCBCB);
Color get blueGray10003 => Color(0XFFD9D9D9);
Color get blueGray400 => Color(0XFF888888);
Color get blueGray50 => Color(0XFFF1F1F1);
// Cyan
Color get cyanA400 => Color(0XFF01ECFF);
Color get cyanA40001 => Color(0XFF01E0FF);
// DeepOrange
Color get deepOrange100 => Color(0XFFFFC89E);
Color get deepOrange10001 => Color(0XFFFFDCC3);
Color get deepOrange200 => Color(0XFFFFA2A2);
Color get deepOrange20001 => Color(0XFFFFA5A5);
Color get deepOrange20002 => Color(0XFFF2BE99);
Color get deepOrange300 => Color(0XFFFA9960);
Color get deepOrange30001 => Color(0XFFFF8D4D);
Color get deepOrange600 => Color(0XFFE86124);
Color get deepOrange60001 => Color(0XFFE45C22);
Color get deepOrange700 => Color(0XFFDC4A26);
Color get deepOrange70001 => Color(0XFFE25820);
Color get deepOrange70002 => Color(0XFFE25A21);
Color get deepOrange900 => Color(0XFF9E4200);
Color get deepOrangeA100 => Color(0XFFF2AB75);
Color get deepOrangeA200 => Color(0XFFF47C37);
Color get deepOrangeA20001 => Color(0XFFF27C36);
Color get deepOrangeA700 => Color(0XFFF81212);
// DeepPurple
Color get deepPurple100 => Color(0XFFCDA5FF);
Color get deepPurpleA100 => Color(0XFFA55EFF);
// Gray
Color get gray200 => Color(0XFFEEEEEE);
Color get gray300 => Color(0XFFDFDFDF);
Color get gray400 => Color(0XFFBFBFBF);
Color get gray50 => Color(0XFFF9F9F9);
Color get gray500 => Color(0XFFA5A5A5);
Color get gray50001 => Color(0XFFA8A8A8);
Color get gray50002 => Color(0XFFAAA7A7);
Color get gray50003 => Color(0XFF929292);
Color get gray600 => Color(0XFF848484);
Color get gray800 => Color(0XFF683917);
Color get gray900 => Color(0XFF502500);
Color get gray90001 => Color(0XFF1E1E1E);
// Green
Color get green900 => Color(0XFF039600);
Color get greenA700 => Color(0XFF22D41F);
// LightGreen
Color get lightGreen400 => Color(0XFFA4DA4A);
Color get lightGreen500 => Color(0XFF83C82F);
Color get lightGreen50001 => Color(0XFF89B15F);
Color get lightGreen800 => Color(0XFF569119);
Color get lightGreenA700 => Color(0XFF6EBD1F);
// Lime
Color get lime20082 => Color(0X82E4FB94);
Color get lime300 => Color(0XFFCEF16C);
Color get lime40082 => Color(0X82C1E95B);
Color get lime800 => Color(0XFFAE7F38);
Color get lime900 => Color(0XFF6D440F);
Color get lime90001 => Color(0XFF693900);
// Orange
Color get orange300 => Color(0XFFFFAC5B);
Color get orange30001 => Color(0XFFDFB04F);
Color get orange400 => Color(0XFFFF9F2E);
Color get orange40001 => Color(0XFFFFAA2C);
Color get orange600 => Color(0XFFD39800);
Color get orange900 => Color(0XFFCA5B00);
Color get orangeA200 => Color(0XFFFF9950);
Color get orangeA700 => Color(0XFFF96900);
// OrangeD
Color get orange400D8 => Color(0XD8FF9233);
// Pink
Color get pink300 => Color(0XFFFE6090);
Color get pink900 => Color(0XFF68182B);
// Red
Color get red300 => Color(0XFFFF7070);
Color get red500 => Color(0XFFFF4242);
Color get red50001 => Color(0XFFF73E3E);
// Teal
Color get teal100 => Color(0XFFA8E4D6);
Color get teal900 => Color(0XFF004D40);
Color get tealA400 => Color(0XFF17D4A7);
// White
Color get whiteA700 => Color(0XFFFFFFFF);
// Yellow
Color get yellow500 => Color(0XFFEFE834);
Color get yellow50001 => Color(0XFFF0E92D);
Color get yellow700 => Color(0XFFFFB629);
Color get yellow70001 => Color(0XFFFFB62A);
Color get yellow800 => Color(0XFFEFB521);
Color get yellow900 => Color(0XFFEF8521);
Color get yellow90001 => Color(0XFFE86C23);
Color get yellow90002 => Color(0XFFF78D11);
Color get yellow90003 => Color(0XFFE98D32);
Color get yellow90004 => Color(0XFFCD7F32);
Color get yellowA700 => Color(0XFFFFD600);
}

