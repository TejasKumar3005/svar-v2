import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: IconButton(
          icon: Container(
            height: height ?? 0,
            width: width ?? 0,
            padding: padding ?? EdgeInsets.zero,
            decoration: decoration ??
                BoxDecoration(
                  borderRadius: BorderRadius.circular(19.h),
                  border: Border.all(
                    color: appTheme.whiteA70001,
                    width: 3.h,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment(0.5, 0),
                    end: Alignment(0.5, 1),
                    colors: [
                      appTheme.deepOrange300,
                      appTheme.yellow90004,
                    ],
                  ),
                ),
            child: child,
          ),
          onPressed: onTap,
        ),
      );
}

/// Extension on [CustomIconButton] to facilitate inclusion of all types of border style etc
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get gradientPrimaryToLightGreen => BoxDecoration(
        borderRadius: BorderRadius.circular(16.h),
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
  static BoxDecoration get gradientDeepOrangeToOrange => BoxDecoration(
        borderRadius: BorderRadius.circular(18.h),
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 4.h,
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
  static BoxDecoration get gradientDeepOrangeToDeepOrangeTL18 => BoxDecoration(
        borderRadius: BorderRadius.circular(18.h),
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 3.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.64, 1),
          colors: [
            appTheme.deepOrange300,
            appTheme.deepOrange40002,
          ],
        ),
      );
  static BoxDecoration get outlineBlackTL50 => BoxDecoration(
        color: appTheme.whiteA70001,
        borderRadius: BorderRadius.circular(50.h),
        border: Border.all(
          color: appTheme.black900,
          width: 4.h,
        ),
      );
  static BoxDecoration get gradientPrimaryToLightGreenTL10 => BoxDecoration(
        borderRadius: BorderRadius.circular(10.h),
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
  static BoxDecoration get gradientDeepOrangeToOrangeTL10 => BoxDecoration(
        borderRadius: BorderRadius.circular(10.h),
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 4.h,
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
  static BoxDecoration get gradientOrangeABfToOrangeE => BoxDecoration(
        borderRadius: BorderRadius.circular(20.h),
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 2.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.orangeA100Bf,
            appTheme.orange600E5,
          ],
        ),
      );
  static BoxDecoration get outlineWhiteA => BoxDecoration(
        color: appTheme.amber600,
        borderRadius: BorderRadius.circular(25.h),
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 3.h,
        ),
      );
  static BoxDecoration get gradientGreenToLightGreenTL25 => BoxDecoration(
        borderRadius: BorderRadius.circular(25.h),
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 3.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.green300,
            appTheme.lightGreen80001,
          ],
        ),
      );
  static BoxDecoration get outlineTeal => BoxDecoration(
        color: appTheme.whiteA70001,
        borderRadius: BorderRadius.circular(37.h),
        border: Border.all(
          color: appTheme.teal900,
          width: 1.h,
        ),
      );
}
