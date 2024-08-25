import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _VideoCamScreenState extends State<VideoCamScreen>
    with WidgetsBindingObserver {
  late CameraController _controller;
  bool _isCameraReady = false;
  late Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool isVideoReady = false;

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
          _overlayEntry =
              persmissionOverlay(context, () => _overlayEntry?.remove());
          Overlay.of(context).insert(_overlayEntry!);
        }
      });
    }
  }

  Future<void> _initializeCamera() async {
    // Obtain a list of available cameras on the device.
    final cameras = await availableCameras();

    // Select the front camera, if available.
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _controller = CameraController(
      frontCamera,
      kIsWeb ? ResolutionPreset.medium : ResolutionPreset.max,
    );
  try {
  await _controller.initialize();
     _controller.lockCaptureOrientation(DeviceOrientation.landscapeRight);
    setState(() {
      isCameraReady = true;
    });
    
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
      ),
    );
  }
    
  }

  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _requestCameraPermission();
    initiliaseVideo();
  }

  void initiliaseVideo() {
    var prov = Provider.of<LingLearningProvider>(context, listen: false);

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/faceattendance-a1720.appspot.com/o/audio%2F${PhonmesListModel().hindiToEnglishPhonemeMap[prov.selectedCharacter]}.mp4?alt=media"))
      ..initialize().then((_) {
        setState(() {
          isVideoReady = true;
        });
      });
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        Navigator.pop(context, true);
      }
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: false,
      showControlsOnInitialize: false,
      showOptions: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 219.v,
                    width: MediaQuery.of(context).size.width * 0.40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: !isCameraReady
                        ? Center(
                            child:
                                CircularProgressIndicator(color:  PrimaryColors().deepOrangeA700))
                        : Transform.flip(
                          flipY: true,
                          child: CameraPreview(_controller))),
                Container(
                  height: 219.v,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * 0.40,
                  child: isVideoReady
                      ? AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: Center(
                              child: Chewie(controller: _chewieController!)),
                        )
                      : Center(child: CircularProgressIndicator(color: PrimaryColors().deepOrangeA700)),
                ),
              ],
            ),
            Spacer()
          ],
        ),
      ),
    ));
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
      cameraController.lockCaptureOrientation(DeviceOrientation.landscapeLeft);
    _controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {}
    });

    if (mounted) {
      setState(() {});
    }
  }
}
