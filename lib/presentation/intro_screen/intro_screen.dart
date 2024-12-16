import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();

  static Widget builder(BuildContext context) {
    return SupportScreen();
  }
}

class _SupportScreenState extends State<SupportScreen> {
  late VideoPlayerController _backgroundVideoController;
  late VideoPlayerController _circleVideoController;

  @override
  void initState() {
    super.initState();

    _backgroundVideoController = VideoPlayerController.asset('/Users/anurag1104/Desktop/svar-v2/assets/video/bgg_animation.mp4')
      ..initialize().then((_) {
        setState(() {
          _backgroundVideoController.play();
          _backgroundVideoController.setLooping(true);
        });
      });

    _circleVideoController = VideoPlayerController.asset('assets/circle_video.mp4')
      ..initialize().then((_) {
        setState(() {
          _circleVideoController.play();
          _circleVideoController.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    _backgroundVideoController.dispose();
    _circleVideoController.dispose();
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
          // Top Circle with Video
          Positioned(
            top: 50,
            left: 50,
            right: 50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: _circleVideoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _circleVideoController.value.aspectRatio,
                        child: VideoPlayer(_circleVideoController),
                      )
                    : Container(color: Colors.white),
              ),
            ),
          ),
          // Bottom Text
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Text(
              'Support Text',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}