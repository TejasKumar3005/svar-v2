

import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/camera_video_excercise/permission_dialog.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_model.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';
import 'package:video_player/video_player.dart';

class VideoCamScreen extends StatefulWidget {
  const VideoCamScreen({super.key});

  @override
  State<VideoCamScreen> createState() => _VideoCamScreenState();
  
  static Widget builder(BuildContext context) {
    return VideoCamScreen();
  }
}

class _VideoCamScreenState extends State<VideoCamScreen> {

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  OverlayEntry? _overlayEntry;

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      _initializeCamera();
    } else {
      // Handle the case when the permission is not granted
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_overlayEntry == null) {
      _overlayEntry = persmissionOverlay(context,()=>_overlayEntry?.remove());
      Overlay.of(context).insert(_overlayEntry!);

    }
  });
    }
  }

  void _initializeCamera() async {
    // Obtain a list of available cameras on the device.
  final cameras = await availableCameras();
  
  // Select the front camera, if available.
  final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _showPlayButton = false;


  @override
  void initState() {
    super.initState();

    _requestCameraPermission();
    var prov=Provider.of<LingLearningProvider>(context,listen: false);

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse("assets/phonemes/${PhonmesListModel().hindiToEnglishPhonemeMap[prov.selectedCharacter]}.mp4"))
      ..initialize().then((_) {
        setState(() {});
      });
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        Navigator.pop(context, true);
      }
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
    );
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
      body:Container(
        width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/cambg.png",
                      ),
                      fit: BoxFit.cover,
                    ),

                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.h,
                      vertical: 10.v,
                    ),
                    child: Column(
                      children: [
                        AuditoryAppBar(context),
                        SizedBox(height: 56.v),
                        Row(
                          children: [

                            Container(
                      height: 219.v,
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: _initializeControllerFuture == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
                      
                    ),
        GestureDetector(

        onTap: _onTap,
        child: _videoPlayerController.value.isInitialized
            ? SizedBox(
              height: 219.v,
                width: MediaQuery.of(context).size.width * 0.40,
              child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Center(child: Chewie(controller: _chewieController!)),
                ),
            )
            : Center(child: CircularProgressIndicator()),
      ),
                    
                          ],
                        )
                      ],
                    ),
                  ),
      )
    );
  }
}