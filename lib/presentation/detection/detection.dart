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
  final GlobalKey<AudioWidgetState> _childKey = GlobalKey<AudioWidgetState>();
  String quizType = "video";
  int selectedOption = -1;
  PlayAudio playAudio = PlayAudio();

  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController1;
  ChewieController? _chewieController2;
  bool isVideoReady1 = false;
  bool isVideoReady2 = false;
  Timer? volumeTimer;
  double currentProgress = 0.0;
  double totalDuration = 0.0;
  @override
  void initState() {
    // if (widget.type == "MutedUnmuted") {
    //   initiliaseVideo(widget.data["video_url"][0], 1);
    //   initiliaseVideo(widget.data["video_url"][1], 2);
    // }
    super.initState();
  }

  void initiliaseVideo(String videoUrl, int video) {
    File? file;
    CachingManager().getCachedFile(videoUrl).then((value) {
      file = value;
    });
    if (video == 1) {
      _videoPlayerController1 = VideoPlayerController.networkUrl(Uri.parse(
        videoUrl,
      ))
        ..initialize().then((_) {
          setState(() {
            isVideoReady1 = true;
          });
        });
      _videoPlayerController1.addListener(() {
        if (_videoPlayerController1.value.position ==
            _videoPlayerController1.value.duration) {
          Navigator.pop(context, true);
        }
      });
      _chewieController1 = ChewieController(
        videoPlayerController: _videoPlayerController1,
        autoPlay: true,
        looping: true,
        showControls: false,
        showControlsOnInitialize: false,
        showOptions: false,
      );
    } else {
      _videoPlayerController2 = VideoPlayerController.networkUrl(Uri.parse(
        videoUrl,
      ))
        ..initialize().then((_) {
          setState(() {
            isVideoReady2 = true;
          });
        });

      _videoPlayerController2.addListener(() {
        if (_videoPlayerController2.value.position ==
            _videoPlayerController2.value.duration) {
          Navigator.pop(context, true);
        }
      });
      _chewieController2 = ChewieController(
        videoPlayerController: _videoPlayerController2,
        autoPlay: true,
        looping: true,
        showControls: false,
        showControlsOnInitialize: false,
        showOptions: false,
      );
    }
  }

  OverlayEntry? _overlayEntry;
  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
    dynamic dtcontainer = obj[1] as dynamic;
    return Scaffold(
      body
          // ? VideoPlayerScreen(
          //     videoUrl:
          //   )
          : Container(
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
      // case "video":
      //   return VideoPlayerScreen(
      //     videoUrl: widget.data["video_url"],
      //   );
      case "HalfMuted":
        return HalfMuted(context);
      case "MutedUnmuted":
        return MutedUnmuted(context);

      default:
        return Container();
    }
  }

  Widget MutedUnmuted(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
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
              child: isVideoReady1
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController1.value.aspectRatio,
                      child: Center(
                          child: Chewie(controller: _chewieController1!)),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          color: PrimaryColors().deepOrangeA700)),
            ),
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
              child: isVideoReady2
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController2.value.aspectRatio,
                      child: Center(
                          child: Chewie(controller: _chewieController2!)),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                          color: PrimaryColors().deepOrangeA700)),
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
              child: OptionWidget(
                child: OptionButton(type: ButtonType.Video1, onPressed: () {}),
                isCorrect: () {
                  return true;
                },
              ),
            ),
            Expanded(
              child: OptionWidget(
                child: OptionButton(type: ButtonType.Video2, onPressed: () {}),
                isCorrect: () {
                  return false;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget HalfMuted(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
    dynamic dtcontainer = obj[1] as dynamic;
    var provider = Provider.of<UserDataProvider>(context, listen: false);
  return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AudioWidget(
          key: _childKey,
          audioLinks: dtcontainer.getVideoUrls(),
        ),
        SizedBox(
          height: 20.v,
        ),
        OptionWidget(
            child: OptionButton(type: ButtonType.Stop, onPressed: () {}),
            isCorrect: () {
              List<double> total_length = _childKey.currentState!.lengths;
              double ans =
                  total_length[0] / (total_length[1] + total_length[0]);
              print(
                  "ans is $ans current progress is ${_childKey.currentState!.progress}");
              if (_childKey.currentState!.progress > ans &&
                  _childKey.currentState!.progress < ans + 0.1) {
                return true;
              } else {
                return false;
              }
            })
      ],
    );
  }
}
