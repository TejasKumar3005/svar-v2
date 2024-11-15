// detection_screen.dart

import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playAudio.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/widgets/tutorial_coach_mark/lib/tutorial_coach_mark.dart';
import 'package:rive/rive.dart';

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

  TutorialCoachMark? tutorialCoachMark;

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
  TutorialCoachMark? tutorialCoachMark;
  Timer? volumeTimer;
  double currentProgress = 0.0;
  double totalDuration = 0.0;

  // **Define a list to hold all GlobalKeys from OptionWidgets**
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
      body: Stack( // Wrap the body in a Stack to position the tip button
        children: [
          Container(
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
          // **Tip Button**
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                // Initialize and show the tutorial
                _initTutorial();
                showTutorial();
              },
              child: CustomImageView(
                imagePath: ImageConstant.imgTipbtn,
                height: 60.v,
                width: 60.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
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
          optionKeys: optionKeys, // Pass the optionKeys list
        );
      case "MutedUnmuted":
        return MutedUnmuted(context,
            optionKeys: optionKeys); // Pass the optionKeys list
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

    // **Ensure the optionKeys list has enough keys**
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
                    return dtcontainer.getMuted() == 1;
                  },
                  optionKey: optionKeys[0], // Assign the key
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
                    return dtcontainer.getMuted() == 0;
                  },
                  optionKey: optionKeys[1], // Assign the key
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

  // **Implement the tutorial methods in Detection class**

  void _initTutorial() {
    tutorialCoachMark = TutorialCoachMark(

      targets: _createTargets(),
      colorShadow: Colors.black.withOpacity(0.5),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        print("Tutorial finished");
      },
      onSkip: () {
        print("Tutorial skipped");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    for (int i = 0; i < optionKeys.length; i++) {
      final key = optionKeys[i];
      final twidget = key.currentWidget as OptionWidget?;
      if (twidget != null) {
        targets.add(
          TargetFocus(
            identify: "tutorial_step_${i + 1}",
            keyTarget: key,
            contents: [
              TargetContent(
                align: twidget.align,
                builder: (context, controller) {
                  return _buildTutorialContent(
                    "",
                    isCorrect: false,
                    child: twidget.child,
                  );
                },
              ),
            ],
          ),
        );
      }
    }

    // Add a target for the correct option
    for (int i = 0; i < optionKeys.length; i++) {
      final key = optionKeys[i];
      final twidget = key.currentWidget as OptionWidget?;
      if (twidget != null && twidget.isCorrect()) {
        targets.add(
          TargetFocus(
            identify: "correct_option",
            keyTarget: key,
            contents: [
              TargetContent(
                align: ContentAlign.ontop,
                builder: (context, controller) {
                  return _buildTutorialContent(
                    _getCorrectAnswerMessage(1),
                    isCorrect: true,
                    child: twidget.child,
                  );
                },
              ),
            ],
          ),
        );
        break; // Assuming only one correct option
      }
    }

    return targets;
  }

  Widget _buildTutorialContent(String text,
      {required bool isCorrect, required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: RiveAnimation.asset(
              'assets/rive/hand_click.riv',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          if (isCorrect)
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
        ],
      ),
    );
  }

  String _getCorrectAnswerMessage(int step) {
    switch (step) {
      case 1:
        return "This is the correct answer!";
      case 2:
        return "Well done!";
      default:
        return "Great job!";
    }
  }

  void showTutorial() {
    if (tutorialCoachMark != null) {
      tutorialCoachMark!.show(context: context);
    }
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
    // **Ensure the optionKeys list has enough keys**
    while (widget.optionKeys.length < 2) {
      widget.optionKeys.add(GlobalKey());
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
            audioLinks: widget.audioLinks,
          ),
          isCorrect: () => false,
          optionKey: optionKeys[0], // Assign the key
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
              print("Error: total_length is empty.");
              return false;
            }

            double audioLength = total_length[0];
            double ans = 0.5;

            double currentProgress = _childKey.currentState!.progress;
            print("Current progress is $currentProgress");

            const double tolerance = 0.4;
            bool condition =
                currentProgress > ans && currentProgress < ans + tolerance;
            print("Condition result: $condition");

            return condition;
          },
          optionKey: widget.optionKeys[1], // Assign the key
          tutorialOrder: 2,
          align: ContentAlign.ontop,
        ),
      ],
    );
  }
}
