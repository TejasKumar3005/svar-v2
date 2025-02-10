import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playAudio.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:svar_new/presentation/settings_screen/setting.dart';

class ExerciseDetection extends StatefulWidget {
  const ExerciseDetection({
    Key? key,
  }) : super(key: key);

  @override
  State<ExerciseDetection> createState() => _DetectionState();

  static Widget builder(BuildContext context) {
    return const ExerciseDetection();
  }
}

class _DetectionState extends State<ExerciseDetection> {
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

  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;

  @override
  void initState() {
    super.initState();
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);

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

  void _onRiveInit(Artboard artboard) async {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 2');

    if (controller != null) {
      artboard.addController(controller);
      riveController = controller;

      // Print all state machines for debugging
      print("\nAll State Machines in artboard:");
      for (var stateMachine in artboard.stateMachines) {
        print("State Machine: ${stateMachine.name}");
      }

      // Get the triggers
      _correctTrigger = controller.findInput<bool>('correct') as SMITrigger;
      _incorrectTrigger = controller.findInput<bool>('incorrect') as SMITrigger;

      print("Controller added: $controller");
    }
  }

  void _triggerAnimation(bool isCorrect) {
    print("\nTrying to fire ${isCorrect ? 'correct' : 'incorrect'} trigger");

    if (isCorrect) {
      if (_correctTrigger != null) {
        print("Firing correct trigger");
        _correctTrigger!.fire();
        print("Correct trigger fired");
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pop(context);
        });
      }
    } else {
      if (_incorrectTrigger != null) {
        _incorrectTrigger!.fire();
        print("Incorrect trigger fired");
      }
    }
  }

  // Initialize both videos sequentially
  Future<void> _initializeVideoFlow(
      List<String> videoUrls, int mutedVideoIndex) async {
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

  Future<void> initiliaseVideo(
      String videoUrl, int video, int mutedVideoIndex) async {
    if (video == 1 && _videoPlayerController1 == null) {
      _videoPlayerController1 =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl));

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
      _videoPlayerController2 =
          VideoPlayerController.networkUrl(Uri.parse(videoUrl));

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
            DisciAppBar(context), // No need for any callbacks now,
            SizedBox(
              height: 26.v,
            ),
            Expanded(
              // Important: Wrap the quiz in an Expanded
              child: Stack(
                // Added Stack to hold the Rive animation
                children: [
                  Center(child: detectionQuiz(context, type)),
                  if (type == "MutedUnmuted")
                    Stack(
                      children: [
                        Positioned(
                          bottom: 0.h,
                          left: 0.h,
                          child: IgnorePointer(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: RiveAnimation.asset(
                                'assets/rive/Celebration_animation.riv',
                                onInit: _onRiveInit,
                                fit: BoxFit.contain,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
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

    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
    ;
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
                  triggerAnimation: (value) {
                    _triggerAnimation(value);
                  },
                  child: OptionButton(
                    type: ButtonType.Video1,
                    onPressed: () {
                      // Implement your logic here
                    },
                  ),
                  isCorrect: () {
                    var condition = (obj[1] as dynamic).getMuted() == 1;

                    var data_pro =
                        Provider.of<ExerciseProvider>(context, listen: false);
                    if (condition) {
                      data_pro.incrementLevel(startExerciseIndex);
                      if (data["completedAt"] == null) {
                        UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                            .updateExerciseData(
                              euid: data["uid"],
                              date: data["date"],
                            )
                            .then((value) => print("Exercise data updated"));
                      }
                    }

                    return condition;
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
                  triggerAnimation: (value) {
                    _triggerAnimation(value);
                  },
                  child: OptionButton(
                    type: ButtonType.Video2,
                    onPressed: () {
                      // Implement your logic here
                    },
                  ),
                  isCorrect: () {
                    var condition = (obj[1] as dynamic).getMuted() == 0;

                    var data_pro =
                        Provider.of<ExerciseProvider>(context, listen: false);
                    if (condition) {
                      data_pro.incrementLevel(startExerciseIndex);
                      if (data["completedAt"] == null) {
                        UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                            .updateExerciseData(
                              euid: data["uid"],
                              date: data["date"],
                            )
                            .then((value) => print("Exercise data updated"));
                      }
                    }

                    return condition;
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
  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startVolumeControl();
    });
  }

  void _onRiveInit(Artboard artboard) async {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 2');

    if (controller != null) {
      artboard.addController(controller);
      riveController = controller;
      _correctTrigger = controller.findInput<bool>('correct') as SMITrigger;
      _incorrectTrigger = controller.findInput<bool>('incorrect') as SMITrigger;
    }
  }

  void _triggerAnimation(bool isCorrect) {
    if (isCorrect && _correctTrigger != null) {
      _correctTrigger!.fire();
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) Navigator.pop(context);
      });
    } else if (!isCorrect && _incorrectTrigger != null) {
      _incorrectTrigger!.fire();
    }
  }

  void _startVolumeControl() {
    _volumeTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_childKey.currentState != null && mounted) {
        try {
          double progress = _childKey.currentState!.progress.value;
          globalAudioPlayer.setVolume(progress < 0.5 ? 0.0 : 1.0);
        } catch (e) {
          print('Error in volume control: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    _volumeTimer?.cancel();
    riveController?.dispose();
    globalAudioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    return SafeArea(
      child: Container(
        // Changed to Container
        // Removed Scaffold
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned(
                  left: 40, // Align to the left
                  top: 0, // Align to the top (you can adjust this)
                  bottom: 0, // Align to the bottom (or set a specific height)
                  width: constraints.maxWidth *
                      0.7, // Occupy half the width (adjust as needed)
                  
    // Add left padding
    child: IgnorePointer(
      child: RiveAnimation.asset(
        'assets/rive/Celebration_animation.riv',
        onInit: _onRiveInit,
        fit: BoxFit.cover, 
      ),
    ),
  ),
                
                Column(
                  children: [
                    SizedBox(height: 40.v),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth * 0.4,
                            maxHeight: constraints.maxHeight * 0.3,
                          ),
                          child: AudioWidget(
                            key: _childKey,
                            audioLinks: widget.audioLinks,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.v),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: OptionWidget(
                          triggerAnimation: _triggerAnimation,
                          child: OptionButton(
                            type: ButtonType.Stop,
                            onPressed: () => globalAudioPlayer.stop(),
                          ),
                          isCorrect: () {
                            if (_childKey.currentState == null) return false;

                            List<double> total_length =
                                _childKey.currentState!.lengths;
                            if (total_length.isEmpty) return false;

                            double currentProgress =
                                _childKey.currentState!.progress.value;
                            const double tolerance = 0.4;
                            bool condition = currentProgress > 0.5 &&
                                currentProgress < 0.5 + tolerance;

                            if (condition) {
                              data_pro.incrementLevel(startExerciseIndex);
                              if (data["completedAt"] == null) {
                                UserData(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .updateExerciseData(
                                  euid: data["uid"],
                                  date: data["date"],
                                );
                              }
                            }
                            return condition;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
