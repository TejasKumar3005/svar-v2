import 'package:chewie/chewie.dart';
import 'package:just_audio/just_audio.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_screen_audio/auditory_screen_assessment_screen_audio_visual_resized_screen.dart.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_visual/animation_play.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:video_player/video_player.dart';
import 'provider/auditory_screen_assessment_screen_visual_audio_resiz_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';

class AuditoryScreenAssessmentScreenVisualAudioResizScreen
    extends StatefulWidget {
  const AuditoryScreenAssessmentScreenVisualAudioResizScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AuditoryScreenAssessmentScreenVisualAudioResizScreenState createState() =>
      AuditoryScreenAssessmentScreenVisualAudioResizScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          AuditoryScreenAssessmentScreenVisualAudioResizProvider(),
      child: AuditoryScreenAssessmentScreenVisualAudioResizScreen(),
    );
  }
}

class AuditoryScreenAssessmentScreenVisualAudioResizScreenState
    extends State<AuditoryScreenAssessmentScreenVisualAudioResizScreen> {
  late bool _isGlowingA;
  late bool _isGlowingB;
  late AudioPlayer _player;
  late int leveltracker;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  Future<void> playAudio(String url) async {
    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _isGlowingA = false;
    _isGlowingB = false;
    leveltracker = 0;
  }

  void _toggleGlowA() {
    setState(() {
      _isGlowingA = true;
    });

    // Revert the glow effect after 1 second
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isGlowingA = false;
      });
    });
  }

  void _toggleGlowB() {
    setState(() {
      _isGlowingB = true;
    });

    // Revert the glow effect after 1 second
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isGlowingB = false;
      });
    });
  }

  int sel = 0;
  @override
  Widget build(BuildContext context) {
    var provider =
        context.watch<AuditoryScreenAssessmentScreenVisualAudioResizProvider>();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
    dynamic dtcontainer = obj[1] as dynamic;
    String params = obj[2] as String;

    return type != "AudioToImage"
        ? SafeArea(
            child: Scaffold(
                extendBody: true,
                extendBodyBehindAppBar: true,
                backgroundColor: appTheme.gray300,
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        ImageConstant.imgAuditorybg,
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
                        _buildOptionGRP(
                            context, provider, type, dtcontainer, params),
                      ],
                    ),
                  ),
                )),
          )
        : AuditoryScreenAssessmentScreenAudioVisualResizScreen(
            dtcontainer: dtcontainer,
            params: params,
          );
  }

  /// Section Widget
  Widget _buildOptionGRP(
      BuildContext context,
      AuditoryScreenAssessmentScreenVisualAudioResizProvider provider,
      String type,
      dynamic dtcontainer,
      String params) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              height: 192.v,
              width: MediaQuery.of(context).size.width * 0.35,
              padding: EdgeInsets.all(1.h),
              decoration: AppDecoration.outlineBlack9001.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder15,
              ),
              child: type == "WordToFig"
                  ? Center(
                      child: Text(
                      dtcontainer.getImageUrl(),
                      style: TextStyle(fontSize: 90),
                    ))
                  : CustomImageView(
                      imagePath:
                          dtcontainer.getImageUrl(), //  ImageConstant.imgClap,
                      radius: BorderRadiusStyle.roundedBorder15,
                    )),
          buildDynamicOptions(type, provider, dtcontainer, params)
        ],
      ),
    );
  }

  Widget buildDynamicOptions(
      String quizType,
      AuditoryScreenAssessmentScreenVisualAudioResizProvider provider,
      dynamic dtcontainer,
      String params) {
    switch (quizType) {
      case "ImageToAudio":
        //debugPrint("entering in image to audio section!");
        return Padding(
            padding: EdgeInsets.only(right: 70.h),
            child: Container(
                height: 192.v,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onDoubleTap: () {
                        provider.setSelected(0);
                        if (dtcontainer.getCorrectOutput() ==
                            dtcontainer.getAudioList()[0]) {
                          // push the widget which will shown after success
                          //      Navigator.push(context, null);
                          leveltracker = leveltracker + 1;
                          if (leveltracker > 1) {
                            provider.incrementLevelCount("completed");
                          } else {
                            provider.incrementLevelCount(params);
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GifDisplayScreen()));
                        } else {
                          // push the widget which will shown after failure
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text("Incorrect option choosen")),
                          // );
                          _toggleGlowA();
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 80.v,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.v, horizontal: 10.h),
                        decoration: AppDecoration.outlineBlack.copyWith(
                          border: Border.all(
                            width: provider.sel == 0 ? 2.0.h : 1.0.h,
                            color: provider.sel == 0
                                ? appTheme.green900
                                : appTheme.black900,
                          ),
                          borderRadius: BorderRadiusStyle.roundedBorder10,
                          boxShadow: _isGlowingA
                              ? [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 202, 1, 1)
                                        .withOpacity(0.6),
                                    spreadRadius: 10,
                                    blurRadius: 5,
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            CustomButton(
                                type: ButtonType.ImagePlay,
                                onPressed: () {
                                  // debugPrint("audio is playing");
                                  // debugPrint(widget.dtcontainer.getAudioList()[0]);
                                  playAudio(dtcontainer.getAudioList()[0]);
                                  // Navigator.pop(context);
                                }),
                            Spacer(),
                            CustomImageView(
                              height: 65.v,
                              fit: BoxFit.contain,
                              width: (MediaQuery.of(context).size.width * 0.3 -
                                  85.h),
                              imagePath: ImageConstant.imgSpectrum,
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onDoubleTap: () {
                        provider.setSelected(1);
                        if (dtcontainer.getCorrectOutput().toString() ==
                            dtcontainer.getAudioList()[1]) {
                          // push the widget which will shown after success
                          leveltracker = leveltracker + 1;
                          if (leveltracker > 1) {
                            provider.incrementLevelCount("completed");
                          } else {
                            provider.incrementLevelCount(params);
                          }
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GifDisplayScreen()));
                        } else {
                          // push the widget which will shown after failure
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text("Incorrect option choosen")),
                          // );
                          _toggleGlowB();
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 80.v,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.v, horizontal: 10.h),
                        decoration: AppDecoration.outlineBlack9003.copyWith(
                          border: Border.all(
                            width: provider.sel == 1 ? 2.3.h : 1.3.h,
                            color: provider.sel == 1
                                ? appTheme.green900
                                : appTheme.black900,
                          ),
                          borderRadius: BorderRadiusStyle.roundedBorder10,
                          boxShadow: _isGlowingB
                              ? [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 202, 1, 1)
                                        .withOpacity(0.6),
                                    spreadRadius: 10,
                                    blurRadius: 5,
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            CustomButton(
                                type: ButtonType.ImagePlay,
                                onPressed: () {
                                  // debugPrint("audio is playing");
                                  // debugPrint(widget.dtcontainer.getAudioList()[1]);
                                  playAudio(dtcontainer.getAudioList()[1]);
                                }),
                            Spacer(),
                            CustomImageView(
                              height: 65.v,
                              fit: BoxFit.contain,
                              width: (MediaQuery.of(context).size.width * 0.3 -
                                  85.h),
                              imagePath: ImageConstant.imgSpectrum,
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacer()
                  ],
                )));

      case "FigToWord":
        return Container(
          height: 192.v,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                height: 125.v,
                padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                decoration: AppDecoration.outlineBlack9003.copyWith(
                  color: appTheme.deepOrangeA200,
                  border: Border.all(
                    width: provider.sel == 1 ? 2.3.h : 1.3.h,
                    color: provider.sel == 1
                        ? appTheme.green900
                        : appTheme.black900,
                  ),
                  image: DecorationImage(
                      image: AssetImage("assets/images/radial_ray_orange.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadiusStyle.roundedBorder10,
                  boxShadow: _isGlowingA
                      ? [
                          BoxShadow(
                            color:
                                Color.fromARGB(255, 202, 1, 1).withOpacity(0.6),
                            spreadRadius: 10,
                            blurRadius: 5,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (dtcontainer.getCorrectOutput() ==
                              dtcontainer.getTextList()[0]) {
                            // success widget push
                            leveltracker = leveltracker + 1;
                            if (leveltracker > 1) {
                              provider.incrementLevelCount("completed");
                            } else {
                              provider.incrementLevelCount(params);
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GifDisplayScreen()));
                          } else {
                            // failure widget push
                            _toggleGlowA();
                          }
                        },
                        child: Text(
                          dtcontainer.getTextList()[0],
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                height: 125.v,
                padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                decoration: AppDecoration.outlineBlack9003.copyWith(
                  color: appTheme.teal90001,
                  border: Border.all(
                    width: provider.sel == 1 ? 2.3.h : 1.3.h,
                    color: provider.sel == 1
                        ? appTheme.green900
                        : appTheme.black900,
                  ),
                  image: DecorationImage(
                      image: AssetImage("assets/images/radial_ray_green.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadiusStyle.roundedBorder10,
                  boxShadow: _isGlowingB
                      ? [
                          BoxShadow(
                            color:
                                Color.fromARGB(255, 202, 1, 1).withOpacity(0.6),
                            spreadRadius: 10,
                            blurRadius: 5,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (dtcontainer.getCorrectOutput() ==
                              dtcontainer.getTextList()[1]) {
                            // success widget push
                            leveltracker = leveltracker + 1;
                            if (leveltracker > 1) {
                              provider.incrementLevelCount("completed");
                            } else {
                              provider.incrementLevelCount(params);
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GifDisplayScreen()));
                          } else {
                            // failure widget push
                            _toggleGlowB();
                          }
                        },
                        child: Text(
                          dtcontainer.getTextList()[1],
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case "WordToFig":
        debugPrint("entering in the word to fig section");

        return Container(
          height: 192.v,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 40.h),
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  height: 130.v,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                  decoration: AppDecoration.outlineBlack9003.copyWith(
                    border: Border.all(
                      width: provider.sel == 1 ? 2.3.h : 1.3.h,
                      color: provider.sel == 1
                          ? appTheme.green900
                          : appTheme.black900,
                    ),
                    image: DecorationImage(
                        image:
                            AssetImage("assets/images/radial_ray_yellow.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                    boxShadow: _isGlowingA
                        ? [
                            BoxShadow(
                              color: Color.fromARGB(255, 202, 1, 1)
                                  .withOpacity(0.6),
                              spreadRadius: 10,
                              blurRadius: 5,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (dtcontainer.getCorrectOutput() ==
                            dtcontainer.getImageUrlList()[0]) {
                          // success widget loader
                          // debugPrint("correct option is choosen");
                          leveltracker = leveltracker + 1;
                          if (leveltracker > 1) {
                            provider.incrementLevelCount("completed");
                          } else {
                            provider.incrementLevelCount(params);
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GifDisplayScreen()));
                        } else {
                          // failure widget loader
                          debugPrint("incorrect option is choosen");
                          _toggleGlowA();
                        }
                      },
                      child: Image.network(
                        dtcontainer.getImageUrlList()[0],
                        fit: BoxFit.contain,
                        height: 70.v,
                        width: 90.v,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                height: 130.v,
                padding: EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                decoration: AppDecoration.outlineBlack9003.copyWith(
                  border: Border.all(
                    width: provider.sel == 1 ? 2.3.h : 1.3.h,
                    color: provider.sel == 1
                        ? appTheme.green900
                        : appTheme.black900,
                  ),
                  image: DecorationImage(
                      image: AssetImage("assets/images/radial_ray_yellow.png"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadiusStyle.roundedBorder10,
                  boxShadow: _isGlowingB
                      ? [
                          BoxShadow(
                            color:
                                Color.fromARGB(255, 239, 7, 7).withOpacity(0.6),
                            spreadRadius: 10,
                            blurRadius: 5,
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (dtcontainer.getCorrectOutput() ==
                          dtcontainer.getImageUrlList()[1]) {
                        // success widget loader
                        debugPrint("correct option is choosen");
                        leveltracker = leveltracker + 1;
                        if (leveltracker > 1) {
                          provider.incrementLevelCount("completed");
                        } else {
                          provider.incrementLevelCount(params);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GifDisplayScreen()));
                      } else {
                        // failure widget loader
                        _toggleGlowB();
                      }
                    },
                    child: Image.network(
                      dtcontainer.getImageUrlList()[1],
                      fit: BoxFit.contain,
                      height: 70.v,
                      width: 90.v,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return Row();
    }
  }
}
