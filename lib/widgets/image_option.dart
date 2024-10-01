import 'package:flutter/material.dart';
import 'package:googleapis/keep/v1.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/core/app_export.dart';
import "package:svar_new/widgets/Options.dart";

class ImageWidget extends StatefulWidget {
  final String imagePath;

  ImageWidget({
    required this.imagePath,
  });

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;

    return Expanded(
      child: Center(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          width: MediaQuery.of(context).size.width * 0.35,
          height:
              MediaQuery.of(context).size.height * 0.45, // 35% of screen height
          decoration: AppDecoration.fillCyan.copyWith(
            border: Border.all(
              color: appTheme.black900,
              width: 2.adaptSize,
            ),
            image: DecorationImage(
              image: AssetImage("assets/images/radial_ray_bluegreen.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadiusStyle.roundedBorder10,
          ),
          child: GestureDetector(
            onTap: () {
              if (click != null) {
                click();
              }
            },
            child: FittedBox(
              fit: BoxFit.fill,
              child: CustomImageView(
                imagePath: widget.imagePath,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
