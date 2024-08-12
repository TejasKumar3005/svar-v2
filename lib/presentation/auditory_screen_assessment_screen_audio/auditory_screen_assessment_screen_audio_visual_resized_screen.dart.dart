import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_visual/animation_play.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';

class AuditoryScreenAssessmentScreenAudioVisualResizScreen
    extends StatefulWidget {
  final dynamic dtcontainer;
  final String params;
  const AuditoryScreenAssessmentScreenAudioVisualResizScreen(
      {Key? key, required this.dtcontainer, required this.params})
      : super(
          key: key,
        );

  @override
  AuditoryScreenAssessmentScreenAudioVisualResizScreenState createState() =>
      AuditoryScreenAssessmentScreenAudioVisualResizScreenState();

  static Widget builder(BuildContext context, dynamic dtcontainer) {
    return 
    AuditoryScreenAssessmentScreenAudioVisualResizScreen(
        dtcontainer: null,
        params: '',
      );
  }
}

class AuditoryScreenAssessmentScreenAudioVisualResizScreenState
    extends State<AuditoryScreenAssessmentScreenAudioVisualResizScreen> {
  late AudioPlayer _player;
  late bool _isGlowingA;
  late bool _isGlowingB;
  late int leveltracker;

  Future<void> playAudio(String url) async {
    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      print('Error initializing player: $e');
    }
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

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _isGlowingA = false;
    _isGlowingB = false;
    leveltracker = 0;
  }

  int sel = 0;

  @override
  Widget build(BuildContext context) {
    var provider = context
        .watch<AuditoryScreenAssessmentScreenAudioVisualResizedProvider>();
    return SafeArea(
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
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
          child: Column(
            children: [
              AuditoryAppBar(context),
              Spacer(
                flex: 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          playAudio(widget.dtcontainer.getAudioUrl());
                        },
                        child: CustomImageView(
                          height: 50.v,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width / 2,
                          imagePath: "assets/images/audio_spectrum.png",
                        ),
                      ),
                    ),
                    SizedBox(height: 50.v),
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            height: 120.v,
                            decoration: AppDecoration.fillCyan.copyWith(
                              border: Border.all(
                                color: appTheme.black900,
                                width: 2.adaptSize,
                              ),
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/radial_ray_bluegreen.png")),
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
                            child: GestureDetector(
                              onTap: () async {
                                if (widget.dtcontainer.getCorrectOutput() ==
                                    widget.dtcontainer.getImageUrlList()[0]) {
                                  // success
                                  leveltracker = leveltracker + 1;
                                  if (leveltracker > 1) {
                                    provider.incrementLevelCount("completed");
                                  } else {
                                    provider.incrementLevelCount(widget.params);
                                  }
                                  bool response = await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              GifDisplayScreen()));
                                  if (response) {
                                    Navigator.pop(context, true);
                                  }
                                } else {
                                  _toggleGlowA();
                                }
                              },
                              child: CustomImageView(
                                fit: BoxFit.contain,
                                imagePath:
                                    widget.dtcontainer.getImageUrlList()[0],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50.h,
                        ),
                        Expanded(
                          child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              height: 120.v,
                              decoration: AppDecoration.fillCyan.copyWith(
                                border: Border.all(
                                  color: appTheme.black900,
                                  width: 2.adaptSize,
                                ),
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/radial_ray_bluegreen.png")),
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
                              child: GestureDetector(
                                onTap: () async {
                                  if (widget.dtcontainer.getCorrectOutput() ==
                                      widget.dtcontainer.getImageUrlList()[1]) {
                                    // success
                                    leveltracker = leveltracker + 1;
                                    if (leveltracker > 1) {
                                      provider.incrementLevelCount("completed");
                                    } else {
                                      provider
                                          .incrementLevelCount(widget.params);
                                    }
                                    bool response = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                GifDisplayScreen()));
                                    if (response) {
                                      Navigator.pop(context, true);
                                    }
                                  } else {
                                    // failure
                                    _toggleGlowB();
                                  }
                                },
                                child: CustomImageView(
                                  fit: BoxFit.contain,
                                  imagePath:
                                      widget.dtcontainer.getImageUrlList()[1],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
