import 'package:flutter/material.dart';
import 'dart:async';

class GifDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GifWidget(),
      ),
    );
  }
}

class GifWidget extends StatefulWidget {
  @override
  _GifWidgetState createState() => _GifWidgetState();
}

class _GifWidgetState extends State<GifWidget>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.7;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;
        Navigator.pop(context , true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(seconds: 1),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.red.withOpacity(0.5),
          BlendMode.multiply,
        ),
        child: Image.asset(
          'assets/animation.gif',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
