

import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/custom_button.dart';

Widget circularScore(String per) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: Color(0xFF30646E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 3,
        )
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomImageView(
              height: 60,
              width: 60,
              imagePath: "assets/images/confetti.png",
              fit: BoxFit.contain,
            ),
            SizedBox(width: 10), // Optional spacing
            Text(
              "Score",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10), // Optional spacing
            Transform.rotate(
              angle: 3.14 / 2,
              child: CustomImageView(
                height: 60,
                width: 60,
                imagePath: "assets/images/confetti.png",
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        SizedBox(height: 20), // Optional spacing
        Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Color(0xFFC2C2C2),
                      width: 6,
                    )
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageView(
                        height: 70,
                        width: 70,
                        imagePath: "assets/images/done.png",
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "${per}%",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GradientCircularProgress(
              progress: double.parse(per), // Set your progress here
              gradientColors: [Color(0xFFFFBD5A), Color(0xFFF0884A), Color(0xFFFF5F00)], // Gradient colors
              strokeWidth: 10.0, // Width of the stroke
            ),
          ],
        ),
        // SizedBox(height: 20), // Optional spacing
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     CustomButton(type: ButtonType.Next, onPressed: () {}),
        //   ],
        // )
      ],
    ),
  );
}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;
  final double strokeWidth;

  GradientCircularProgressPainter({
    required this.progress,
    required this.gradientColors,
    this.strokeWidth = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final Gradient gradient = SweepGradient(
      startAngle: -1.5708, // -pi/2
      endAngle: 1.5708 * 3, // pi/2 * 3
      colors: gradientColors,
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double angle = 2 * 3.14159265359 * (progress / 100);
    canvas.drawArc(rect, -1.5708, angle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class GradientCircularProgress extends StatelessWidget {
  final double progress;
  final List<Color> gradientColors;
  final double strokeWidth;

  GradientCircularProgress({
    required this.progress,
    required this.gradientColors,
    this.strokeWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(150.0, 150.0), // Size of the circular progress
      painter: GradientCircularProgressPainter(
        progress: progress,
        gradientColors: gradientColors,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
