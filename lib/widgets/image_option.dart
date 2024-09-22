import 'package:flutter/material.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/core/app_export.dart';


class ImageWidget extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTapCallback;

  ImageWidget({
    required this.imagePath,
    required this.onTapCallback,
  });

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool _isGlowing = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        height: 202.0,
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
          boxShadow: _isGlowing
              ? [
                  BoxShadow(
                    color: Color.fromARGB(255, 255, 0, 0).withOpacity(0.6), // Red glow
                    spreadRadius: 10,
                    blurRadius: 5,
                  ),
                ]
              : [],
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isGlowing = !_isGlowing;
            });
            widget.onTapCallback();
          },
          child: FittedBox(
            fit: BoxFit.fill,
            child: CustomImageView(
              imagePath: widget.imagePath,
            ),
          ),
        ),
      ),
    );
  }
}
