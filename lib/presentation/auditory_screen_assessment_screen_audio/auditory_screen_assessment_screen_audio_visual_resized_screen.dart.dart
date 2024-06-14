import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_screen_audio/provider/auditory_screen_assessment_screen_audio_visual_resized_provider.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';

class AuditoryScreenAssessmentScreenAudioVisualResizScreen
    extends StatefulWidget {
  final dynamic dtcontainer;
  const AuditoryScreenAssessmentScreenAudioVisualResizScreen(
      {Key? key, required this.dtcontainer})
      : super(
          key: key,
        );

  @override
  AuditoryScreenAssessmentScreenAudioVisualResizScreenState createState() =>
      AuditoryScreenAssessmentScreenAudioVisualResizScreenState();

  static Widget builder(BuildContext context, dynamic dtcontainer) {
    return ChangeNotifierProvider(
      create: (context) =>
          AuditoryScreenAssessmentScreenAudioVisualResizedProvider(),
      child: AuditoryScreenAssessmentScreenAudioVisualResizScreen(
        dtcontainer: null,
      ),
    );
  }
}

class AuditoryScreenAssessmentScreenAudioVisualResizScreenState
    extends State<AuditoryScreenAssessmentScreenAudioVisualResizScreen> {
  late AudioPlayer _player;

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
  }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  int sel = 0;

  @override
  Widget build(BuildContext context) {
    // var provider = context
    //     .watch<AuditoryScreenAssessmentScreenAudioVisualResizedProvider>();
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
                          child: Container(
                            height: 120.v,
                            decoration: AppDecoration.fillCyan.copyWith(
                                border: Border.all(
                                  color: appTheme.black900,
                                  width: 2.adaptSize,
                                ),
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/radial_ray_bluegreen.png")),
                                borderRadius:
                                    BorderRadiusStyle.roundedBorder10),
                            child: GestureDetector(
                              onTap: () {
                                if (widget.dtcontainer.getCorrectOutput() ==
                                    widget.dtcontainer.getImageUrlList()[0]) {
                                  // success
                                } else {
                                  // failure
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
                          child: Container(
                              height: 100.v,
                              decoration: AppDecoration.fillCyan.copyWith(
                                  border: Border.all(
                                    color: appTheme.black900,
                                    width: 2.adaptSize,
                                  ),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/radial_ray_bluegreen.png")),
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder10),
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.dtcontainer.getCorrectOutput() ==
                                      widget.dtcontainer.getImageUrlList()[0]) {
                                    // success
                                  } else {
                                    // failure
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
                    SizedBox(height: 50.v),
                    CustomImageView(
                      imagePath: ImageConstant.imgNextBtn,
                    )
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
