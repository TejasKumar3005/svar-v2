import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rive/rive.dart' hide LinearGradient, Image;
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/network/cacheManager.dart';
import 'package:svar_new/core/utils/playAudio.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/patient_report/app_theme.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:svar_new/presentation/settings_screen/setting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';

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

  // New state variables for next exercise functionality
  bool exerciseCompleted = false;
  bool hasMoreExercises = false;
  int currentExerciseIndex = 0;

  bool parent_mode = true;

  // Variable to store the selected sample data for consistency
  dynamic selectedSampleData;

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

      // Use sample data when parent_mode is true
      if (parent_mode) {
        final random = Random();
        switch (type) {
          case "MutedUnmuted":
            dtcontainer =
                sampleMutedUnmuted[random.nextInt(sampleMutedUnmuted.length)];
            selectedSampleData = dtcontainer; // Store for later use
            break;
          case "HalfMuted":
            dtcontainer =
                sampleHalfMuted[random.nextInt(sampleHalfMuted.length)];
            selectedSampleData = dtcontainer; // Store for later use
            break;
          default:
            // Keep original dtcontainer if no sample available
            dtcontainer = obj[1] as dynamic;
            break;
        }
      }

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

      // Get the triggers
      _correctTrigger = controller.findInput<bool>('correct') as SMITrigger;
      _incorrectTrigger = controller.findInput<bool>('incorrect') as SMITrigger;
    }
  }

  void _triggerAnimation(bool isCorrect) {
    if (isCorrect) {
      if (_correctTrigger != null) {
        _correctTrigger!.fire();
        if (!parent_mode) {
          setState(() {
            exerciseCompleted = true;
          });
        }

        // Only auto-navigate if there are no more exercises for today
        if (!hasMoreExercises) {
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted && !parent_mode && exerciseCompleted) {
              Navigator.pop(context);
            }
          });
        }
      }
    } else {
      if (_incorrectTrigger != null) {
        _incorrectTrigger!.fire();
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
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    currentExerciseIndex = obj[3] as int;

    // Check if there are more exercises left for today
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    _checkForMoreExercises(data_pro);

    String type = obj[0] as String;
    print("Type: $type");
    String text = type == "HalfMuted"
        ? "Wait quietly. Tap the stop button as soon as you hear the sound."
        : "Watch the videos. Tap the one that has sound.";

    String audioFile = type == "HalfMuted" ? "v6.wav" : "v7.wav";
  }

  void _checkForMoreExercises(ExerciseProvider data_pro) {
    // Get the current exercise's date
    if (currentExerciseIndex >= data_pro.todaysExercises.length) return;

    Map<String, dynamic> currentExercise =
        data_pro.todaysExercises[currentExerciseIndex];
    String exerciseDate = currentExercise['date'] ?? '';

    if (exerciseDate.isEmpty) return;

    // Filter exercises to only include exercises from the same date as current exercise
    List<Map<String, dynamic>> sameDateExercises = data_pro.todaysExercises
        .where((exercise) => exercise['date'] == exerciseDate)
        .toList();

    // Find the current exercise's position in the same date filtered list
    int currentIndexInSameDateExercises = sameDateExercises.indexWhere(
        (exercise) =>
            data_pro.todaysExercises.indexOf(exercise) == currentExerciseIndex);

    if (currentIndexInSameDateExercises != -1) {
      // Check if any exercises after current one are incomplete (completedAt is null)
      hasMoreExercises = sameDateExercises
          .skip(currentIndexInSameDateExercises + 1)
          .any((exercise) => exercise['completedAt'] == null);
    }

    print("Exercise date: $exerciseDate");
    print("Has more exercises for this date: $hasMoreExercises");
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
    // Use CachingManager to get the cached file if available, else fallback to network
    Future<VideoPlayerController> _getController(String url) async {
      if (kIsWeb || Platform.isIOS) {
        // On web, always use network URL
        return VideoPlayerController.networkUrl(Uri.parse(url));
      }
      try {
        final cachingManager = CachingManager();
        final cachedFile = await cachingManager.getCachedFile(url);

        if (cachedFile != null && cachedFile.existsSync()) {
          return VideoPlayerController.file(cachedFile);
        }
      } catch (e) {
        print("Error using cache for video: $e");
      }
      // Fallback to network if cache fails or is invalid
      return VideoPlayerController.networkUrl(Uri.parse(url));
    }

    if (video == 1 && _videoPlayerController1 == null) {
      try {
        _videoPlayerController1 = await _getController(videoUrl);
        await _videoPlayerController1!.initialize();
        if (mounted) {
          setState(() {
            isVideoReady1 = true;
          });

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

          bool isMuted = (mutedVideoIndex == 0);
          _videoPlayerController1?.setVolume(isMuted ? 0.0 : 1.0);
        }
      } catch (e) {
        print("Error initializing video 1: $e");
      }
    } else if (video == 2 && _videoPlayerController2 == null) {
      try {
        _videoPlayerController2 = await _getController(videoUrl);
        await _videoPlayerController2!.initialize();
        if (mounted) {
          setState(() {
            isVideoReady2 = true;
          });

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
    dynamic dtcontainer = obj[1] as dynamic;

    // Use stored sample data when parent_mode is true
    if (parent_mode && selectedSampleData != null) {
      dtcontainer = selectedSampleData;
    }
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // Replace gradient with background image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/quiz_bg.jpeg'), // Update with your actual image path
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 30.0, bottom: 20),
            child: Column(
              children: [
                DisciAppBar(
                  context,
                  parent_mode: parent_mode,
                  onParentModeChanged: (value) {
                    // Get original data from route arguments
                    var obj = ModalRoute.of(context)?.settings.arguments
                        as List<dynamic>;
                    String type = obj[0] as String;
                    dynamic originalDtcontainer = obj[1] as dynamic;

                    setState(() {
                      parent_mode = value;
                      if (!parent_mode) {
                        // Switching to exercise mode
                        selectedSampleData = null; // Clear sample data
                        isVideoReady1 = false;
                        isVideoReady2 = false;
                        exerciseCompleted = false;
                      } else {
                        // Switching back to preview mode
                        exerciseCompleted = false;
                        // Reset to sample data when switching back to preview
                        final random = Random();
                        switch (type) {
                          case "MutedUnmuted":
                            selectedSampleData = sampleMutedUnmuted[
                                random.nextInt(sampleMutedUnmuted.length)];
                            break;
                          case "HalfMuted":
                            selectedSampleData = sampleHalfMuted[
                                random.nextInt(sampleHalfMuted.length)];
                            break;
                        }
                      }
                    });

                    // Dispose and re-initialize videos
                    _videoPlayerController1?.dispose();
                    _chewieController1?.dispose();
                    _videoPlayerController2?.dispose();
                    _chewieController2?.dispose();

                    _videoPlayerController1 = null;
                    _chewieController1 = null;
                    _videoPlayerController2 = null;
                    _chewieController2 = null;

                    if (type == "MutedUnmuted") {
                      if (parent_mode) {
                        // Use new sample data for preview
                        _initializeVideoFlow(selectedSampleData.getVideoUrls(),
                            selectedSampleData.getMuted());
                      } else {
                        // Use original data for exercise
                        _initializeVideoFlow(originalDtcontainer.getVideoUrls(),
                            originalDtcontainer.getMuted());
                      }
                    }
                  },
                ),
                Expanded(
                  child: Stack(
                    children: [
                      detectionQuiz(context, type, dtcontainer),
                      Stack(
                        children: [
                          Positioned(
                            bottom: 0.h,
                            left: -30.h,
                            child: IgnorePointer(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width,
                                child: RiveAnimation.asset(
                                  key: Key(parent_mode.toString()),
                                  'assets/rive/Celebration_animation.riv',
                                  onInit: _onRiveInit,
                                  fit: BoxFit.fitHeight,
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ),
                          ),

                          // Next button - positioned on the right side of Rive animation
                          if (exerciseCompleted &&
                              hasMoreExercises &&
                              !parent_mode)
                            Positioned(
                              bottom: MediaQuery.of(context).size.height * 0.01,
                              right: 20,
                              child: AnimatedScale(
                                  scale: 1,
                                  duration: Duration(milliseconds: 500),
                                  child: CustomButton(
                                      width: 150,
                                      child: Text(
                                        "Next",
                                        style: GoogleFonts.inter(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      type: ButtonType.Next,
                                      onPressed: _moveToNextExercise)),
                            ),
                        ],
                      ),
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

  Widget detectionQuiz(
      BuildContext context, String quizType, dynamic dtcontainer) {
    switch (quizType) {
      case "HalfMuted":
        return HalfMutedWidget(
          key: Key(parent_mode.toString()),
          audioLinks: dtcontainer.getVideoUrls(),
          triggerAnimation: _triggerAnimation,
          parentMode: parent_mode,
        );
      case "MutedUnmuted":
        return MutedUnmuted(context, dtcontainer, Key(parent_mode.toString()));
      default:
        return Container();
    }
  }

  Widget MutedUnmuted(BuildContext context, dynamic dtcontainer, Key key) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

    return Padding(
      key: key,
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Column(
        children: [
          // Instruction Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.h),
            child: Container(
              width: double.infinity,

              // Remove decoration to make it transparent over the placeholder
              child: Text(
                "Watch the videos. Tap the one that has sound.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Comic Sans MS", // Child-friendly font
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Color.fromARGB(255, 132, 140, 74),
                ),
              ),
            ),
          ),

          // Centered content area
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First Video Card
                  _buildVideoCard(
                    isReady: isVideoReady1,
                    controller: _chewieController1,
                    videoController: _videoPlayerController1,
                    buttonType: ButtonType.Video1,
                    index: 1,
                    obj: obj,
                    startExerciseIndex: startExerciseIndex,
                    data: data,
                    dtcontainer: dtcontainer,
                  ),

                  SizedBox(height: 20.v),

                  // Second Video Card
                  _buildVideoCard(
                    isReady: isVideoReady2,
                    controller: _chewieController2,
                    videoController: _videoPlayerController2,
                    buttonType: ButtonType.Video2,
                    index: 2,
                    obj: obj,
                    startExerciseIndex: startExerciseIndex,
                    data: data,
                    dtcontainer: dtcontainer,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard({
    required bool isReady,
    required ChewieController? controller,
    required VideoPlayerController? videoController,
    required ButtonType buttonType,
    required int index,
    required List<dynamic> obj,
    required int startExerciseIndex,
    required Map<String, dynamic> data,
    required dynamic dtcontainer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Video Container
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,

            padding: const EdgeInsets.all(12.0), // Paddi
            child: Card(
              elevation: 6.0,
              shadowColor: Colors.blueGrey.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                color: Color(0xFFE3F2FD),
                child: isReady
                    ? AspectRatio(
                        aspectRatio: videoController!.value.aspectRatio,
                        child: Center(child: Chewie(controller: controller!)),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          color: PrimaryColors().deepOrangeA700,
                          strokeWidth: 3,
                        ),
                      ),
              ),
            ),
          ),

          // Selection Button
          OptionWidget(
            triggerAnimation: (value) {
              _triggerAnimation(value);
            },
            child: OptionButton(
              type: index == 1 ? ButtonType.Video1 : ButtonType.Video2,
              onPressed: () {
                // Implement your logic here
              },
            ),
            isCorrect: () {
              var condition = (index == 1)
                  ? dtcontainer.getMuted() == 1
                  : dtcontainer.getMuted() == 0;

              var data_pro =
                  Provider.of<ExerciseProvider>(context, listen: false);
              if (condition) {
                data_pro.incrementLevel(startExerciseIndex);

                UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                    .updateExerciseData(
                        euid: data["uid"],
                        date: data["date"],
                        performance: {
                      "correct_attempt": condition,
                      "time": DateTime.now().toString(),
                    }).then((value) => print("Exercise data updated"));
              }
              return condition;
            },
          ),
        ],
      ),
    );
  }

  void _moveToNextExercise() {
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);

    // Get the current exercise's date
    if (currentExerciseIndex >= data_pro.todaysExercises.length) return;

    Map<String, dynamic> currentExercise =
        data_pro.todaysExercises[currentExerciseIndex];
    String exerciseDate = currentExercise['date'] ?? '';

    if (exerciseDate.isEmpty) return;

    // Find next incomplete exercise for the same date
    int nextExerciseIndex = -1;
    for (int i = currentExerciseIndex + 1;
        i < data_pro.todaysExercises.length;
        i++) {
      if (data_pro.todaysExercises[i]['date'] == exerciseDate &&
          data_pro.todaysExercises[i]['completedAt'] == null) {
        nextExerciseIndex = i;
        break;
      }
    }

    if (nextExerciseIndex != -1) {
      // Navigate to the next exercise
      Map<String, dynamic> nextExercise =
          data_pro.todaysExercises[nextExerciseIndex];
      String exerciseType = nextExercise["exerciseType"];

      // Pop current screen first
      Navigator.pop(context);

      // Navigate to appropriate exercise type
      navigateToExerciseType(exerciseType, nextExerciseIndex, context);
    } else {
      // No more exercises, just pop
      Navigator.pop(context);
    }
  }
}

class HalfMutedWidget extends StatefulWidget {
  final List<String> audioLinks;
  void Function(bool) triggerAnimation;
  final bool parentMode;

  HalfMutedWidget({
    Key? key,
    required this.audioLinks,
    required this.triggerAnimation,
    required this.parentMode,
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
  late bool _muteFirstHalf; // Randomized muting configuration
  late String _instructionText; // Dynamic instruction text
  late bool parentMode; // Access to parent mode variable

  @override
  void initState() {
    super.initState();
    // Initialize parent mode from widget
    parentMode = widget.parentMode;

    // Randomly determine which half to mute
    _muteFirstHalf = Random().nextBool();

    // Set instruction text based on muting configuration
    _instructionText = _muteFirstHalf
        ? "Wait quietly. Sound will play in the second half. Tap stop when you hear it."
        : "Listen carefully. Sound will stop halfway. Tap stop when the sound stops.";

    print(
        "Muting configuration: ${_muteFirstHalf ? 'First half muted' : 'Second half muted'}");

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

  void _startVolumeControl() {
    // Create a periodic timer that runs every 500ms
    _volumeTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      // Check if the audio widget state is available and widget is still mounted
      if (_childKey.currentState != null && mounted) {
        try {
          // Get the current progress value from the audio widget
          double progress = _childKey.currentState!.progress.value;

          // Set volume based on randomized muting configuration:
          double volume;
          if (_muteFirstHalf) {
            // Mute first half, play second half
            volume = progress < 0.5 ? 0.0 : 1.0;
          } else {
            // Play first half, mute second half
            volume = progress < 0.5 ? 1.0 : 0.0;
          }

          globalAudioPlayer.setVolume(volume);
        } catch (e) {
          // Log any errors that occur during volume control
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h),
                child: Container(
                  width: double.infinity,

                  // Remove decoration to make it transparent over the placeholder
                  child: Text(
                    _instructionText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Comic Sans MS", // Child-friendly font
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Color.fromARGB(255, 132, 140, 74),
                    ),
                  ),
                ),
              ),

              // Centered content area
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Audio player widget
                      Container(
                        width: constraints.maxWidth * 0.8,
                        height: constraints.maxHeight * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: AudioWidget(
                          key: _childKey,
                          audioLinks: widget.audioLinks,
                        ),
                      ),

                      SizedBox(height: 60.v),

                      // Stop button
                      Container(
                        width: constraints.maxWidth * 0.6,
                        height: 60.v,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF5E9FE0),
                              Color(0xFF3D7EDB),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: OptionWidget(
                          triggerAnimation: widget.triggerAnimation,
                          child: OptionButton(
                            type: ButtonType.Stop,
                            onPressed: () {
                              // Implement your logic here
                            },
                          ),
                          isCorrect: () {
                            if (_childKey.currentState == null) return false;

                            List<double> total_length =
                                _childKey.currentState!.lengths;
                            if (total_length.isEmpty) return false;

                            double currentProgress =
                                _childKey.currentState!.progress.value;
                            const double tolerance = 0.15;

                            bool condition;
                            if (_muteFirstHalf) {
                              // User should tap when sound starts (around 50% mark)
                              condition = currentProgress > 0.5 &&
                                  currentProgress < 0.5 + tolerance;
                            } else {
                              // User should tap when sound stops (around 50% mark)
                              condition = currentProgress > 0.5 &&
                                  currentProgress < 0.5 + tolerance;
                            }

                            print(
                                "Progress: $currentProgress, Condition: $condition, Mute first half: $_muteFirstHalf");

                            if (condition && !parentMode) {
                              data_pro.incrementLevel(startExerciseIndex);

                              UserData(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .updateExerciseData(
                                      euid: data["uid"],
                                      date: data["date"],
                                      performance: {
                                    "correct_attempt": condition,
                                    "time": DateTime.now().toString(),
                                    "mute_configuration": _muteFirstHalf
                                        ? "first_half_muted"
                                        : "second_half_muted",
                                    "progress_when_stopped": currentProgress,
                                  });
                            }
                            return condition;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
