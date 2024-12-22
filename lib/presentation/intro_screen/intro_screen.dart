import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/routes/app_routes.dart'; // Import the file where AppRoutes is defined

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();

  static Widget builder(BuildContext context) {
    return SupportScreen();
  }
}

class _SupportScreenState extends State<SupportScreen> {
  late VideoPlayerController _backgroundVideoController;

  // Combined data structure for GIFs and their corresponding texts
  final List<Map<String, String>> _content = [
    {
      'gif': 'assets/video/interface-boy.gif',
      'text': 'Welcome to Support! I\'m here to help.',
    },
    {
      'gif': 'assets/video/Untitled-2.gif',
      'text': 'How can I assist you today?',
    },
  ];

  int _currentIndex = 0;
  late Timer _contentTimer;

  @override
  void initState() {
    super.initState();

    _backgroundVideoController =
        VideoPlayerController.asset('assets/video/bgg_animation.mp4')
          ..initialize().then((_) {
            setState(() {
              _backgroundVideoController.play();
              _backgroundVideoController.setLooping(true);
            });
          });

    // Set up a timer to cycle through content every 5 seconds
    _contentTimer = Timer.periodic(Duration(seconds: 5), (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _content.length;
      });
    });
  }

  @override
  void dispose() {
    _contentTimer.cancel();
    _backgroundVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Video
          _backgroundVideoController.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _backgroundVideoController.value.size.width,
                      height: _backgroundVideoController.value.size.height,
                      child: VideoPlayer(_backgroundVideoController),
                    ),
                  ),
                )
              : Container(color: Colors.black),

          // Top Circle with GIF
          Positioned(
            top: 50,
            left: 50,
            right: 50,
            child: Container(
              width: 400,
              height: 400,
              child: ClipOval(
                child: Image.asset(
                  _content[_currentIndex]['gif']!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Bottom Text with Animation
          Positioned(
            bottom: 150,
            left: 20,
            right: 20,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Text(
                _content[_currentIndex]['text']!,
                key: ValueKey<int>(_currentIndex), // Important for animation
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: CustomButton(
              type: ButtonType.Next,
              onPressed: () async {
                // Navigate to the next screen
                Navigator.of(context).pushNamed(AppRoutes.loginSignup);
              },
            ),
          ),
        ],
      ),
    );
  }
}
