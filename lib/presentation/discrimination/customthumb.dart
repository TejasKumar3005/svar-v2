import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class RectangularImageThumb extends SliderComponentShape {
  final double thumbWidth;
  final double thumbHeight;
  final String thumbImagePath;

  RectangularImageThumb({
    required this.thumbWidth,
    required this.thumbHeight,
    required this.thumbImagePath,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
  }

  

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final ImageConfiguration imageConfiguration = ImageConfiguration();
    final ImageProvider imageProvider = AssetImage(thumbImagePath);
    final ImageStream imageStream = imageProvider.resolve(imageConfiguration);
    final ImageStreamListener imageStreamListener = ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        final ui.Image image = imageInfo.image;
        final Paint paint = Paint();
        context.canvas.drawImageRect(
          image,
          Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromCenter(center: center, width: thumbWidth, height: thumbHeight),
          paint,
        );
      },
    );

    imageStream.addListener(imageStreamListener);
  }
}
