import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/network/cacheManager.dart';
import 'package:svar_new/core/utils/playAudio.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/identification_screen/celebration_overlay.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/discrimination/customthumb.dart';
import 'package:svar_new/presentation/phoneme_level_one/video_player_screen.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/widgets/audio_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/phoneme_level_one/level_one.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter/services.dart' show rootBundle;
class Detection extends StatefulWidget {
  const Detection({
    Key? key,
  }) : super(key: key);

  @override
  State<Detection> createState() => _DetectionState();

  static Widget builder(BuildContext context) {
    return const Detection();
  }
}

class _DetectionState extends State<Detection> {
  final GlobalKey<AudioWidgetState> _audioWidgetKey =
      GlobalKey<AudioWidgetState>();
  String quizType = "video";
  int selectedOption = -1;
  int level = 0;  
  PlayAudio playAudio = PlayAudio();
  late UserData userData;
  VideoPlayerController? _videoPlayerController1;
  VideoPlayerController? _videoPlayerController2;
  ChewieController? _chewieController1;
  ChewieController? _chewieController2;
  bool isVideoReady1 = false;
  bool isVideoReady2 = false;
  Timer? volumeTimer;
  double currentProgress = 0.0;
  double totalDuration = 0.0;
   rive.Artboard? _riveArtboard;
  rive.StateMachineController? _controller;
  rive.SMIInput<bool>? _correctInput;
  rive.SMIInput<bool>? _incorrectInput;


  @override
  void initState() {
    super.initState();
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
    _loadRiveFile();
    // Defer the video initialization to after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
      String type = obj[0] as String;
      dynamic dtcontainer = obj[1] as dynamic;
      print(dtcontainer.getVideoUrls().toString());
      if (type == "MutedUnmuted") {
        int mutedVideoIndex = dtcontainer.getMuted();
        _initializeVideoFlow(dtcontainer.getVideoUrls(), mutedVideoIndex);
      }
    });
  }

  // Initialize both videos sequentially
  Future<void> _initializeVideoFlow(List<String> videoUrls, int mutedVideoIndex) async {
    await initiliaseVideo(videoUrls[0], 1, mutedVideoIndex);
    await initiliaseVideo(videoUrls[1], 2, mutedVideoIndex);
  }

  @override
  void dispose() {
    // Dispose of the video controllers and Chewie controllers
    _videoPlayerController1?.dispose();
    _chewieController1?.dispose();
    _videoPlayerController2?.dispose();
    _chewieController2?.dispose();
    // Dispose of the timer if it exists
    volumeTimer?.cancel();
    super.dispose();
  }
   Future<void> _loadRiveFile() async {
    try {
      final bytes = await rootBundle.load('assets/rive/Celebration_animation.riv');
      final file = rive.RiveFile.import(bytes);
      final artboard = file.mainArtboard;
      _controller = rive.StateMachineController.fromArtboard(artboard, 'State Machine 1');

      if (_controller != null) {
        artboard.addController(_controller!);
        _correctInput = _controller!.findInput<bool>('correct');
        _incorrectInput = _controller!.findInput<bool>('incorrect');
      }
      
      setState(() => _riveArtboard = artboard);
    } catch (e) {
      print('Error loading Rive file: $e');
    }
  }

  void _triggerAnimation(bool isCorrect) {
    if (_correctInput != null && _incorrectInput != null) {
      setState(() {
        _correctInput!.value = isCorrect;
        _incorrectInput!.value = !isCorrect;
      });
    }
  }


  Future<void> initiliaseVideo(String videoUrl, int video, int mutedVideoIndex) async {
    if (video == 1 && _videoPlayerController1 == null) {
      _videoPlayerController1 = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      try {
        await _videoPlayerController1!.initialize();
        if (mounted) {
          setState(() {
            isVideoReady1 = true;
          });

          // Create the Chewie controller once the video is initialized
          _chewieController1 = ChewieController(
            videoPlayerController: _videoPlayerController1!,
            autoPlay: true,
            looping: true,
            showControls: false,
            showControlsOnInitialize: false,
            showOptions: false,
            allowMuting: false,
            autoInitialize: true,
          );

          // Set the volume after initialization
          bool isMuted = (mutedVideoIndex == 0);
          _videoPlayerController1?.setVolume(isMuted ? 0.0 : 1.0);
        }
      } catch (e) {
        print("Error initializing video 1: $e");
      }
    } else if (video == 2 && _videoPlayerController2 == null) {
      _videoPlayerController2 = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      try {
        await _videoPlayerController2!.initialize();
        if (mounted) {
          setState(() {
            isVideoReady2 = true;
          });

          // Create the Chewie controller once the video is initialized
          _chewieController2 = ChewieController(
            videoPlayerController: _videoPlayerController2!,
            autoPlay: true,
            looping: true,
            showControls: false,
            showControlsOnInitialize: false,
            showOptions: false,
            allowMuting: false,
            autoInitialize: true,
          );

          // Set the volume after initialization
          bool isMuted = (mutedVideoIndex == 1);
          _videoPlayerController2?.setVolume(isMuted ? 0.0 : 1.0);
        }
      } catch (e) {
        print("Error initializing video 2: $e");
      }
    }
  }

 @override
Widget build(BuildContext context) {
  var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
  String type = obj[0] as String;
  return Scaffold(
    body: Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            "assets/images/discri_bg.png",
            fit: BoxFit.cover,
          ),
        ),
        // Main Content
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
            horizontal: 15.h,
            vertical: 10.v,
          ),
          child: Column(
            children: [
              DisciAppBar(context),
              SizedBox(
                height: 26.v,
              ),
              Expanded( // Important: Wrap the quiz in an Expanded
                child: Stack( // Added Stack to hold the Rive animation
                  children: [
                    Center(child: detectionQuiz(context, type)),
                    // Positioned(
                    //                 bottom: 16.h,
                    //                 left: 16.h,
                    //                 child: _riveArtboard == null
                    //                     ? const Center(child: CircularProgressIndicator())
                    //                     : rive.RiveAnimation.direct(
                    //                         rive.RiveFile.import(await rootBundle.load('assets/rive/Celebration_animation.riv')),
                    //                         fit: BoxFit.contain,
                    //                       ),
                    //               ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget detectionQuiz(BuildContext context, String quizType) {
    switch (quizType) {
      // case "video":
      //   return VideoPlayerScreen(
      //     videoUrl: widget.data["video_url"],
      //   );
      case "HalfMuted":
        return HalfMutedWidget(
          key: _audioWidgetKey,
          audioLinks:
              (ModalRoute.of(context)?.settings.arguments as List<dynamic>)[1]
                  .getVideoUrls(),
        );
      case "MutedUnmuted":
        return MutedUnmuted(context);
      default:
        return Container();
    }
  }

  Widget MutedUnmuted(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    level = obj[4] as int;  
    dynamic dtcontainer = obj[1] as dynamic;
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.symmetric(
            vertical: 5.v,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              ("Tap on the video which has sound").toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 26.v,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                child: isVideoReady1
                    ? AspectRatio(
                        aspectRatio: _videoPlayerController1!.value.aspectRatio,
                        child: Center(
                            child: Chewie(controller: _chewieController1!)),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: PrimaryColors().deepOrangeA700)),
              ),
            ),
            SizedBox(
                width:
                    20), // Add spacing between the two Expanded containers if needed
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                child: isVideoReady2
                    ? AspectRatio(
                        aspectRatio: _videoPlayerController2!.value.aspectRatio,
                        child: Center(
                            child: Chewie(controller: _chewieController2!)),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            color: PrimaryColors().deepOrangeA700)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15.v,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.40, // Dynamically set width
                child: OptionWidget(
                   triggerAnimation: _triggerAnimation,
                  child: OptionButton(
                    type: ButtonType.Video1,
                    onPressed: () {
                      // Implement your logic here
                    },
                  ),
                  isCorrect: () {
                       if((obj[1] as dynamic).getMuted() == 1){
                         userData.incrementLevelCount("Detection", level);
                        
                       }
                    return (obj[1] as dynamic).getMuted() == 1;
                  },
                ),
              ),
            ),
            SizedBox(width: 20), // Add spacing between buttons if needed
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.40, // Dynamically set width
                child: OptionWidget(
                    triggerAnimation: _triggerAnimation,
                  child: OptionButton(
                    type: ButtonType.Video2,
                    onPressed: () {
                      // Implement your logic here
                    },
                  ),
                  isCorrect: () {

                    if((obj[1] as dynamic).getMuted() == 0){
                      userData.incrementLevelCount("Detection", level);
                    
                    }
                    
                    return (obj[1] as dynamic).getMuted() == 0;
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

///
/// New StatefulWidget: HalfMutedWidget
///
class HalfMutedWidget extends StatefulWidget {
  final List<String> audioLinks;

  const HalfMutedWidget({
    Key? key,
    required this.audioLinks,
  }) : super(key: key);

  @override
  _HalfMutedWidgetState createState() => _HalfMutedWidgetState();
}

class _HalfMutedWidgetState extends State<HalfMutedWidget> {
  final GlobalKey<AudioWidgetState> _childKey = GlobalKey<AudioWidgetState>();
  Timer? _volumeTimer;
   rive.Artboard? _riveArtboard;
  rive.StateMachineController? _controller;
  rive.SMIInput<bool>? _correctInput;
  rive.SMIInput<bool>? _incorrectInput;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
    // Start the volume control after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startVolumeControl();
    });
  }

  Future<void> _loadRiveFile() async {
    try {
      final bytes = await rootBundle.load('assets/rive/Celebration_animation.riv');
      final file = rive.RiveFile.import(bytes);
      final artboard = file.mainArtboard;
      _controller = rive.StateMachineController.fromArtboard(artboard, 'State Machine 1');

      if (_controller != null) {
        artboard.addController(_controller!);
        _correctInput = _controller!.findInput<bool>('correct');
        _incorrectInput = _controller!.findInput<bool>('incorrect');
      }

      setState(() => _riveArtboard = artboard);
    } catch (e) {
      print('Error loading Rive file: $e');
    }
  }

  void _triggerAnimation(bool isCorrect) {
    if (_correctInput != null && _incorrectInput != null) {
      setState(() {
        _correctInput!.value = isCorrect;
        _incorrectInput!.value = !isCorrect;
      });
    }
  }

  void _startVolumeControl() {
    _volumeTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_childKey.currentState != null) {
        double progress = _childKey.currentState!.progress;
        if (progress < 0.5) {
          // Mute for the first half
          globalAudioPlayer.setVolume(0.0);
        } else {
          // Unmute for the second half
          globalAudioPlayer.setVolume(1.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _volumeTimer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 40.v,
        ),
        AudioWidget(
          key: _childKey,
          audioLinks: widget.audioLinks,
        ),
        SizedBox(
          height: 20.v,
        ),
        OptionWidget(
            triggerAnimation: _triggerAnimation,
          child: OptionButton(
            type: ButtonType.Stop,
            onPressed: () {
              // Stop the audio playback
              globalAudioPlayer.stop();
            },
          ),
          isCorrect: () {
            if (_childKey.currentState == null) return false;

            List<double> total_length = _childKey.currentState!.lengths;
            if (total_length.isEmpty) {
              // Ensure there is at least 1 element in the list (the audio length)
              print("Error: total_length is empty.");
              return false;
            }

            double audioLength = total_length[
                0]; // Since there's only one length, take the first element
            double ans =
                0.5; // Since you're muting the first half, the threshold is 0.5

            double currentProgress = _childKey.currentState!.progress;
            print("Current progress is $currentProgress");


            const double tolerance = 0.4;
            bool condition =
                currentProgress > ans && currentProgress < ans + tolerance;
            print("Condition result: $condition");

            return condition;
          },
        ),
      ],
    );
  }
}
