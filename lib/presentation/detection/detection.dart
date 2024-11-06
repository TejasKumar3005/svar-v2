import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/network/cacheManager.dart';
import 'package:svar_new/core/utils/playAudio.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/Identification_screen/celebration_overlay.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/discrimination/customthumb.dart';
import 'package:svar_new/presentation/phoneme_level_one/video_player_screen.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/widgets/audio_widget.dart';
import 'package:svar_new/widgets/tutorial_coach_mark/lib/tutorial_coach_mark.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isMuted;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.isMuted,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    try {
      await _videoPlayerController.initialize();
      _videoPlayerController.setVolume(widget.isMuted ? 0.0 : 1.0);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        showControls: false,
        showControlsOnInitialize: false,
        showOptions: false,
        allowMuting: false,
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print("Error initializing video: $e");
    }
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: Chewie(
              controller: _chewieController,
            ),
          )
        : Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrangeAccent, // Replace with your primary color
            ),
          );
  }
}

class SimpleVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isMuted;

  const SimpleVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.isMuted,
  }) : super(key: key);

  @override
  _SimpleVideoPlayerState createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  // Inside SimpleVideoPlayer
  Future<void> _initializePlayer() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true, // Allows audio mixing with other audio streams
      ),
    );

    try {
      await _controller.initialize();
      _controller.setVolume(widget.isMuted ? 0.0 : 1.0);

      _controller.play();

      _controller.addListener(() {
        if (_controller.value.isPlaying) {
          print("${widget.videoUrl} is playing");
        } else {
          print("${widget.videoUrl} is paused");
        }
      });

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print("Error initializing video: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}

class Detection extends StatefulWidget {
  const Detection({Key? key}) : super(key: key);

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
  PlayAudio playAudio = PlayAudio();

  Timer? volumeTimer;
  double currentProgress = 0.0;
  double totalDuration = 0.0;

  // **Step 1: Define a list to hold all GlobalKeys from OptionWidgets**
  final List<GlobalKey> optionKeys = [];

  @override
  void initState() {
    super.initState();

    // Defer the video initialization to after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
      String type = obj[0] as String;
      dynamic dtcontainer = obj[1] as dynamic;
      print(dtcontainer.getVideoUrls().toString());
      if (type == "MutedUnmuted") {
        // Initialization is handled in the VideoPlayerWidget
        setState(() {
          quizType = type;
        });
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the timer if it exists
    volumeTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/discri_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
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
            detectionQuiz(context, type),
          ],
        ),
      ),
    );
  }

  Widget detectionQuiz(BuildContext context, String quizType) {
    switch (quizType) {
      case "HalfMuted":
        return HalfMutedWidget(
          audioLinks:
              (ModalRoute.of(context)?.settings.arguments as List<dynamic>)[1]
                  .getVideoUrls(),
          // **Step 2: Pass the optionKeys list to the child widget**
          optionKeys: optionKeys,
        );
      case "MutedUnmuted":
        return MutedUnmuted(
          context,
          // **Step 2: Pass the optionKeys list to the child widget**
          optionKeys: optionKeys,
        );
      default:
        return Container();
    }
  }

  Widget MutedUnmuted(BuildContext context,
      {required List<GlobalKey> optionKeys}) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    dynamic dtcontainer = obj[1] as dynamic;
    List<String> videoUrls = dtcontainer.getVideoUrls();
    int mutedVideoIndex = dtcontainer.getMuted();

    // **Step 3: Initialize and assign keys to OptionWidgets**
    // Ensure that the optionKeys list has enough keys
    // Here, we need two keys for two videos
    while (optionKeys.length < 2) {
      optionKeys.add(GlobalKey());
    }

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
                child: SimpleVideoPlayer(
                  videoUrl: videoUrls[0],
                  isMuted: mutedVideoIndex == 0,
                ),
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
                child: SimpleVideoPlayer(
                  videoUrl: videoUrls[1],
                  isMuted: mutedVideoIndex == 1,
                ),
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
                  child: OptionButton(
                    type: ButtonType.Video1,
                    onPressed: () {
                      // Handle button press
                    },
                  ),
                  isCorrect: () {
                    return (obj[1] as dynamic).getMuted() == 1;
                  },
                  // **Assign the first key from the list**
                  optionKey: optionKeys[0],
                  tutorialOrder: 1,
                  align: ContentAlign.ontop,
                ),
              ),
            ),
            SizedBox(width: 20), // Add spacing between buttons if needed
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.40, // Dynamically set width
                child: OptionWidget(
                  child: OptionButton(
                    type: ButtonType.Video2,
                    onPressed: () {
                      // Handle button press
                    },
                  ),
                  isCorrect: () {
                    return (obj[1] as dynamic).getMuted() == 0;
                  },
                  // **Assign the second key from the list**
                  optionKey: optionKeys[1],
                  tutorialOrder: 2,
                  align: ContentAlign.ontop,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget HalfMutedWidget({
    required List<GlobalKey> optionKeys,
    required List<String> audioLinks,
  }) {
    // **Step 3: Initialize and assign keys to OptionWidgets**
    // Assuming you have one OptionWidget in HalfMutedWidget
    while (optionKeys.length < 3) {
      optionKeys.add(GlobalKey());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 40.v,
        ),
        OptionWidget(
          child: AudioWidget(
            audioLinks: audioLinks,
          ),
          isCorrect: () => false,
          optionKey: optionKeys[0], // Apply key
          tutorialOrder: 1,
          align: ContentAlign.onside,
        ),
        SizedBox(
          height: 20.v,
        ),
        OptionWidget(
          child: OptionButton(
            type: ButtonType.Stop,
            onPressed: () {},
          ),
          isCorrect: () {
            if (_audioWidgetKey.currentState == null) return false;

            List<double> total_length = _audioWidgetKey.currentState!.lengths;
            if (total_length.isEmpty) {
              // Ensure there is at least 1 element in the list (the audio length)
              print("Error: total_length is empty.");
              return false;
            }

            double audioLength = total_length[
                0]; // Since there's only one length, take the first element
            double ans =
                0.5; // Since you're muting the first half, the threshold is 0.5

            double currentProgress = _audioWidgetKey.currentState!.progress;
            print("Current progress is $currentProgress");

            const double tolerance = 0.4;
            bool condition =
                currentProgress > ans && currentProgress < ans + tolerance;
            print("Condition result: $condition");

            return condition;
          },
          // **Assign the third key from the list**
          optionKey: optionKeys[1],
          tutorialOrder: 2,
          align: ContentAlign.ontop,
        ),
      ],
    );
  }

}


class HalfMutedWidget extends StatefulWidget {
  final List<String> audioLinks;
  final List<GlobalKey> optionKeys;

  const HalfMutedWidget({
    Key? key,
    required this.audioLinks,
    required this.optionKeys,
  }) : super(key: key);

  @override
  _HalfMutedWidgetState createState() => _HalfMutedWidgetState();
}

class _HalfMutedWidgetState extends State<HalfMutedWidget> {
  final GlobalKey<AudioWidgetState> _childKey = GlobalKey<AudioWidgetState>();
  Timer? _volumeTimer;

  @override
  void initState() {
    super.initState();
    // Start the volume control after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startVolumeControl();
    });
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
        OptionWidget(
          child: AudioWidget(
            audioLinks: widget.audioLinks,
          ),
          isCorrect: () => false,
          optionKey: widget.optionKeys[0], // Apply key
          tutorialOrder: 1,
          align: ContentAlign.onside,
        ),
        SizedBox(
          height: 20.v,
        ),
        OptionWidget(
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
          // **Assign the third key from the list (index 2)**
          optionKey: widget.optionKeys[1],
          tutorialOrder: 2,
          align: ContentAlign.ontop,
        ),
      ],
    );
  }
}
