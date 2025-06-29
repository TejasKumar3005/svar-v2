import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/network/cacheManager.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class ExerciseVideo extends StatefulWidget {
  final String videoUrl;
  final Function onVideoComplete; // Callback function to run on completion

  ExerciseVideo({required this.videoUrl, required this.onVideoComplete}) {
    print('ExerciseVideo: Constructor called with URL: $videoUrl');
  }

  @override
  _ExerciseVideoState createState() {
    print('ExerciseVideo: createState() called');
    return _ExerciseVideoState();
  }
}

class _ExerciseVideoState extends State<ExerciseVideo> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _showPlayButton = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  _ExerciseVideoState() {
    print('ExerciseVideo: State constructor called');
  }

  @override
  void initState() {
    super.initState();
    print('ExerciseVideo: initState called');
    print('ExerciseVideo: Video URL: ${widget.videoUrl}');

    // Set landscape orientation for video playback
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    print('ExerciseVideo: About to call _initializePlayer()');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePlayer();
    });
  }

  Future<bool> _checkNetworkConnectivity() async {
    if (kIsWeb) return true; // Assume web has connectivity

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _initializePlayer() async {
    print('ExerciseVideo: _initializePlayer() method started');

    try {
      print('ExerciseVideo: Setting loading state');
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Clean up any existing controllers
      if (_chewieController != null) {
        print('ExerciseVideo: Disposing existing chewie controller');
        _chewieController?.dispose();
        _chewieController = null;
      }

      print('ExerciseVideo: Initializing video player for URL: ${widget.videoUrl}');

      if (kIsWeb || Platform.isIOS) {
        // Web: always use network URL
        print('ExerciseVideo: Running on web, using network URL');
        _videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      }
      else if (Platform.isAndroid) {
        // Android: use cached file if present, else fallback to network URL (do not check file type)
        print('ExerciseVideo: Running on Android, attempting to get cached file for URL: ${widget.videoUrl}');
        CachingManager cachingManager = CachingManager();
        print('ExerciseVideo: CachingManager instance created');

        try {
          print('ExerciseVideo: About to call getCachedFile()');
          final cachedFile = await cachingManager.getCachedFile(widget.videoUrl);
          print('ExerciseVideo: getCachedFile() completed');
          print("ExerciseVideo: cachedFile result: ${cachedFile?.path}");
          print("ExerciseVideo: cachedFile exists: ${cachedFile?.existsSync() ?? false}");

          if (cachedFile != null && cachedFile.existsSync()) {
          
            _videoPlayerController = VideoPlayerController.file(cachedFile);
          } else {
            
            final hasNetwork = await _checkNetworkConnectivity();
            if (!hasNetwork) {
              showConnectivitySnackBar(false);
              throw Exception('No internet connection available and video not cached');
            }
            _videoPlayerController =
                VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
          }
        } catch (cacheError) {
          print('ExerciseVideo: Error getting cached file: $cacheError');
          // Fallback to network on cache error
          print('ExerciseVideo: Cache error, falling back to network URL');
          final hasNetwork = await _checkNetworkConnectivity();
          if (!hasNetwork) {
          showConnectivitySnackBar(false);
          throw Exception('No internet connection available and video not cached');
          }
          _videoPlayerController =
              VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        }
      } else {
        // Other platforms: fallback to network URL
        print('ExerciseVideo: Unknown platform, using network URL');
        _videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      }

      // Initialize the video controller with error handling
      print('ExerciseVideo: About to initialize video controller');
      await _videoPlayerController.initialize();

      // Verify the video was properly initialized
      if (!_videoPlayerController.value.isInitialized) {
        throw Exception('Video controller failed to initialize');
      }

      print('ExerciseVideo: Video initialized successfully. Duration: ${_videoPlayerController.value.duration}');

      // Add listener for video completion and errors
      _videoPlayerController.addListener(_videoListener);

      // Create Chewie controller with auto-play enabled
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true, // Changed to true for better UX
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        fullScreenByDefault: true,
        allowFullScreen: false,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.white, size: 60),
                SizedBox(height: 16),
                Text(
                  'Video Error',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
      });

      print('ExerciseVideo: Video player setup completed successfully');
    } catch (e) {
      print('ExerciseVideo: Error initializing video player: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load video: ${e.toString()}';
      });
    }
  }

  void _videoListener() {
    if (!mounted) return;

    final value = _videoPlayerController.value;

    // Handle video completion
    if (value.position >= value.duration && value.duration.inMilliseconds > 0) {
      print("ExerciseVideo: Video completed");
      widget.onVideoComplete();
      _exitScreen();
    }

    // Handle video errors
    if (value.hasError) {
      print('ExerciseVideo: Video error: ${value.errorDescription}');
      setState(() {
        _hasError = true;
        _errorMessage = value.errorDescription ?? 'Unknown video error';
      });
    }
  }

  void _exitScreen() {
    print('ExerciseVideo: Exiting screen');
    // Restore portrait orientation before exiting
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).then((_) {
      Navigator.pop(context, true);
    });
  }

  @override
  void dispose() {
    print('ExerciseVideo: dispose() called');

    // Restore portrait orientation when disposing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Clean up video listener safely
    try {
      _videoPlayerController.removeListener(_videoListener);
    } catch (e) {
      print('ExerciseVideo: Error removing video listener: $e');
    }

    // Dispose controllers safely
    try {
      _videoPlayerController.dispose();
    } catch (e) {
      print('ExerciseVideo: Error disposing video controller: $e');
    }

    try {
      _chewieController?.dispose();
    } catch (e) {
      print('ExerciseVideo: Error disposing chewie controller: $e');
    }

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

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Error Loading Video',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _errorMessage,
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _exitScreen(),
            child: Text('Close'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _initializePlayer(),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
        'ExerciseVideo: build() called - _isLoading: $_isLoading, _hasError: $_hasError');

    return WillPopScope(
      onWillPop: () async {
        _exitScreen();
        return false; // Prevent default pop behavior
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: _hasError
              ? _buildErrorWidget()
              : _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading video...',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: _onTap,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _chewieController != null &&
                                  _videoPlayerController.value.isInitialized
                              ? Chewie(controller: _chewieController!)
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Preparing video...',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          if (_showPlayButton)
                            Center(
                              child: GestureDetector(
                                onTap: _togglePlayPause,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(20),
                                  child: Icon(
                                    _videoPlayerController.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 60.0,
                                  ),
                                ),
                              ),
                            ),
                          // Add back button for easy exit
                          Positioned(
                            top: 16,
                            left: 16,
                            child: GestureDetector(
                              onTap: _exitScreen,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
