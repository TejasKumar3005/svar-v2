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
          padding: EdgeInsets.zero,
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
  static BoxDecoration get gradientGreenToLightGreen => BoxDecoration(
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(
          color: appTheme.whiteA70001,
          width: 4.h,
        ),
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [
            appTheme.green30001,
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
  static BoxDecoration get gradientDeepOrangeToDeepOrange => BoxDecoration(
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
            appTheme.deepOrange40001,
          ],
        ),
      );
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: appTheme.whiteA70001,
        borderRadius: BorderRadius.circular(50.h),
        border: Border.all(
          color: appTheme.black90001,
          width: 4.h,
        ),
      );
}
