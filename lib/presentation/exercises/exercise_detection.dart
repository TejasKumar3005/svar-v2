import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient,Image;
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
  final GlobalKey<AudioWidgetState> _audioWidgetKey = GlobalKey<AudioWidgetState>();
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
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 2');

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
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pop(context);
        });
      }
    } else {
      if (_incorrectTrigger != null) {
        _incorrectTrigger!.fire();
      }
    }
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
      body: SafeArea(
        child: Stack(
          children: [
              Positioned.fill(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // Replace gradient with background image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/quiz_bg.jpeg'), // Update with your actual image path
            fit: BoxFit.fill,
          ),
                          
                        ),
                        ),
                        ),
            Container(
                width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h,),
                    child: DisciAppBar(context),
                  ),
                  Expanded(
                    child: Stack(
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
                                    height: MediaQuery.of(context).size.height*0.4,
                                    width: MediaQuery.of(context).size.width,
                                    child: RiveAnimation.asset(
                                      'assets/rive/Celebration_animation.riv',
                                      onInit: _onRiveInit,
                                      fit: BoxFit.fitHeight,
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
            
          ],
        ),
      ),
    );
  }

  Widget detectionQuiz(BuildContext context, String quizType) {
    switch (quizType) {
      case "HalfMuted":
        return HalfMutedWidget(
          key: _audioWidgetKey,
          audioLinks: (ModalRoute.of(context)?.settings.arguments as List<dynamic>)[1].getVideoUrls(),
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
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Instruction Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.h),
              child: Container(
                width: double.infinity,
            
                // Remove decoration to make it transparent over the placeholder
                child: Text(
                    "TAP ON THE VIDEO WHICH HAS SOUND",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Colors.black87, // Adjust text color to be visible on placeholder
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.v),
            
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
            ),
          ],
        ),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Video Container
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              color: Colors.black.withOpacity(0.05),
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
          
          // Selection Button
          InkWell(
            onTap: () {
              // Button tap logic is handled by OptionWidget
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.v),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5E9FE0),
                    Color(0xFF3D7EDB),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: OptionWidget(
                triggerAnimation: (value) {
                  _triggerAnimation(value);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 8.h),
                    Text(
                      "Video $index",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                isCorrect: () {
                  var condition = (index == 1) 
                      ? (obj[1] as dynamic).getMuted() == 1
                      : (obj[1] as dynamic).getMuted() == 0;
                      
                  var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
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
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 2');

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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Animation positioned at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: constraints.maxHeight * 0.3,
                child: IgnorePointer(
                  child: RiveAnimation.asset(
                    'assets/rive/Celebration_animation.riv',
                    onInit: _onRiveInit,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              
              // Main content
              Column(
                children: [
                  SizedBox(height: 40.v),
                  
                  // Instruction container
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15.v, horizontal: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "PRESS STOP WHEN THE SOUND CHANGES",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40.v),
                  
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
                      triggerAnimation: _triggerAnimation,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () => globalAudioPlayer.stop(),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.stop_circle,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(width: 10.h),
                                Text(
                                  "STOP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      isCorrect: () {
                        if (_childKey.currentState == null) return false;

                        List<double> total_length = _childKey.currentState!.lengths;
                        if (total_length.isEmpty) return false;

                        double currentProgress = _childKey.currentState!.progress.value;
                        const double tolerance = 0.4;
                        bool condition = currentProgress > 0.5 && currentProgress < 0.5 + tolerance;

                        if (condition) {
                          data_pro.incrementLevel(startExerciseIndex);
                          if (data["completedAt"] == null) {
                            UserData(uid: FirebaseAuth.instance.currentUser!.uid)
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
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
