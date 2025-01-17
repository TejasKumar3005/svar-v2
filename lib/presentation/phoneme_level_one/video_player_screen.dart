import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/network/cacheManager.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _showPlayButton = false;

  
  @override
  void initState() {
    super.initState();
      SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializePlayer();
  }

  void _initializePlayer() async {
    CachingManager cachingManager=CachingManager();

    // _videoPlayerController = VideoPlayerController.file((await cachingManager.getCachedFile(widget.videoUrl))!);

    if (kIsWeb) {
      // For web, use the network URL directly
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    } else {
      // For non-web platforms, use the cached file
      final cachedFile = await cachingManager.getCachedFile(widget.videoUrl);
      if (cachedFile != null) {
        _videoPlayerController = VideoPlayerController.file(cachedFile);
      } else {
        // Handle the case where the file is not cached
        print('Error: Cached file not found');
      }
    }
    await _videoPlayerController.initialize();
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position == _videoPlayerController.value.duration) {
        Navigator.pop(context, true);
      }
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      fullScreenByDefault: true,
      allowFullScreen: false,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
      _showPlayButton = false;
    });
  }

  void _onTap() {
    setState(() {
      _showPlayButton = !_showPlayButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: _onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _chewieController != null && _videoPlayerController.value.isInitialized
                  ? Chewie(controller: _chewieController!)
                  : Center(child: CircularProgressIndicator()),
              if (_showPlayButton)
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Icon(
                    _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 100.0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}