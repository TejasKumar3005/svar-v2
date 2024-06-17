
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

// ignore: must_be_immutable
class AppbarTrailingIconbutton extends StatelessWidget {
AppbarTrailingIconbutton({
Key? key,
this.imagePath,
this.margin,
this.onTap,
}) : super(
key: key,
);

String? imagePath;

EdgeInsetsGeometry? margin;

Function? onTap;

@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: () {
onTap?.call();
},
child: Padding(
padding: margin ?? EdgeInsets.zero,
child: CustomIconButton(
height: 37.adaptSize,
width: 37.adaptSize,
child: CustomImageView(
imagePath: ImageConstant.imgHomeBtn,
),
),
),
);
}
}

