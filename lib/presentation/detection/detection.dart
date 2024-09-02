import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playAudio.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/discrimination/customthumb.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';

class Detection extends StatefulWidget {
  final String type; // Add type as a parameter
  final Map<String, dynamic> data;

  const Detection({Key? key, required this.type,required this.data}) : super(key: key);

  @override
  State<Detection> createState() => _DetectionState();

  static Widget builder(BuildContext context) {
    // Provide default values for demonstration purposes
    return Detection(type: 'default',data: {},);
  }
}

class _DetectionState extends State<Detection> {
  String quizType = "video";
  int selectedOption = -1;
  PlayAudio playAudio = PlayAudio();
  List<String> audios = [
    "assets/audios/1.mp3",
    "assets/audios/2.mp3",
    "assets/audios/3.mp3",
    "assets/audios/4.mp3",
  ];
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool isVideoReady = false;
  void initiliaseVideo(String videoUrl) {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
      videoUrl,
    ))
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
  Widget build(BuildContext context) {
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
            detectionQuiz(context, widget.type),
          ],
        ),
      ),
    );
  }

  Widget detectionQuiz(BuildContext context, String quizType) {
    switch (quizType) {
      case "video":
        return MutedUnmuted(context);
      case "HalfMuted":
        return HalfMuted(context);
      case "MutedUnmuted":
        return MutedUnmuted(context);

      default:
        return Container();
    }
  }

  Widget MutedUnmuted(BuildContext context) {
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
              "Pick the odd One Out",
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
              child: isVideoReady
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child:
                          Center(child: Chewie(controller: _chewieController!)),
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
              child: isVideoReady
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child:
                          Center(child: Chewie(controller: _chewieController!)),
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
            CustomButton(type: ButtonType.Video1, onPressed: () {}),
            CustomButton(type: ButtonType.Video2, onPressed: () {}),
          ],
        ),
      ],
    );
  }

  Widget HalfMuted(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildOption("A", PrimaryColors().deepOrangeA200, 0),
        SizedBox(
          height: 20.v,
        ),
        CustomButton(
          type: ButtonType.Stop,
          onPressed: () {},
        ),
        SizedBox(
          height: 20.v,
        ),
        Container(
          height: 40,

          width: MediaQuery.of(context).size.width *
              0.6, // Adjust this value to control the width of the slider
          child: Center(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor:
                    PrimaryColors().blue20001, // Green part of the slider
                inactiveTrackColor:
                    Colors.white, // Light blue part of the slider
                trackHeight: 20.0,

                thumbShape: RectangularImageThumb(
                  thumbWidth: 50.0, // Set the width of the thumb
                  thumbHeight: 50.0, // Set the height of the thumb
                  thumbImagePath:
                      'assets/images/thumb.png', // Path to the thumb image
                ),
                thumbColor: PrimaryColors().orange800,
                // Orange circle
                overlayColor: Colors.orange
                    .withOpacity(0.2), // Overlay color when dragging
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
              ),
              child: Slider(
                value: 0.2,
                onChanged: (value) {},
                min: 0.0,
                max: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption(String text, Color color, int index) {
    {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text + ")",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 10.h,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedOption = index;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.symmetric(
                horizontal: 3.h,
                vertical: 5.v,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    type: ButtonType.ImagePlay,
                    onPressed: () {
                      // AudioSampleExtractor audioSampleExtractor =
                      //     AudioSampleExtractor();
                      // audioSampleExtractor.getAssetAudioSamples(audios[index]);
                      playAudio.playMusic(audios[index], "mp3", false);
                    },
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  CustomImageView(
                    width: MediaQuery.of(context).size.width * 0.4 - 90,
                    height: 60,
                    fit: BoxFit.fill,
                    imagePath: "assets/images/spectrum.png",
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}
