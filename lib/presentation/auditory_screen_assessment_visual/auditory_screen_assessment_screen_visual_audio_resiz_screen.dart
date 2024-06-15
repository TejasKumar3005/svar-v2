import 'package:just_audio/just_audio.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_screen_audio/auditory_screen_assessment_screen_audio_visual_resized_screen.dart.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/auditory_screen_assessment_screen_visual_audio_resiz_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';

class AuditoryScreenAssessmentScreenVisualAudioResizScreen
    extends StatefulWidget {
  final String type;
  final dynamic dtcontainer;

  const AuditoryScreenAssessmentScreenVisualAudioResizScreen(
      {Key? key, required String this.type, required this.dtcontainer})
      : super(
          key: key,
        );

  @override
  AuditoryScreenAssessmentScreenVisualAudioResizScreenState createState() =>
      AuditoryScreenAssessmentScreenVisualAudioResizScreenState();

  static Widget builder(BuildContext context, {required String type}) {
    return ChangeNotifierProvider(
      create: (context) =>
          AuditoryScreenAssessmentScreenVisualAudioResizProvider(),
      child: AuditoryScreenAssessmentScreenVisualAudioResizScreen(
        type: type,
        dtcontainer: null,
      ),
    );
  }
}

class AuditoryScreenAssessmentScreenVisualAudioResizScreenState
    extends State<AuditoryScreenAssessmentScreenVisualAudioResizScreen> {
  late final String type;
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
    type = widget.type;
    _player = AudioPlayer();
  }

  int sel = 0;
  @override
  Widget build(BuildContext context) {
    var provider =
        context.watch<AuditoryScreenAssessmentScreenVisualAudioResizProvider>();

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
                      horizontal: 20.h,
                      vertical: 10.v,
                    ),
                    child: Column(
                      children: [
                        AuditoryAppBar(context),
                        SizedBox(height: 56.v),
                        _buildOptionGRP(context, provider, type),
                        Spacer(),
                        Center(
                          child: CustomButton(
                              type: ButtonType.Next, onPressed: () {}),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                )),
          )
        : AuditoryScreenAssessmentScreenAudioVisualResizScreen(
            dtcontainer: widget.dtcontainer,
          );
  }

  /// Section Widget
  Widget _buildOptionGRP(
      BuildContext context,
      AuditoryScreenAssessmentScreenVisualAudioResizProvider provider,
      String type) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: 192.v,
              width: MediaQuery.of(context).size.width * 0.4,
              padding: EdgeInsets.all(1.h),
              decoration: AppDecoration.outlineBlack9001.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder15,
              ),
              child: widget.type == "WordToFig"
                  ? Center(
                      child: Text(
                      widget.dtcontainer.getImageUrl(),
                      style: TextStyle(fontSize: 90),
                    ))
                  : CustomImageView(
                      imagePath: widget.dtcontainer
                          .getImageUrl(), //  ImageConstant.imgClap,
                      radius: BorderRadiusStyle.roundedBorder15,
                    )),
          buildDynamicOptions(widget.type, provider)
        ],
      ),
    );
  }

  Widget buildDynamicOptions(String quizType,
      AuditoryScreenAssessmentScreenVisualAudioResizProvider provider) {
    switch (quizType) {
      case "ImageToAudio":
        //debugPrint("entering in image to audio section!");
        return Container(
            height: 192.v,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                Spacer(),
                GestureDetector(
                  onDoubleTap: () {
                    provider.setSelected(0);
                    if (widget.dtcontainer.getCorrectOutput() ==
                        widget.dtcontainer.getAudioList()[0]) {
                      // push the widget which will shown after success
                      //      Navigator.push(context, null);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Correct option choosen")),
                        );
                    } else {
                      // push the widget which will shown after failure
                       ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Incorrect option choosen")),
                        );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 80.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack.copyWith(
                        border: Border.all(
                          width: provider.sel == 0 ? 2.3.h : 1.3.h,
                          color: provider.sel == 0
                              ? appTheme.green900
                              : appTheme.black900,
                        ),
                        borderRadius: BorderRadiusStyle.roundedBorder10),
                    child: Row(
                      children: [
                        CustomButton(
                            type: ButtonType.ImagePlay,
                            onPressed: () {
                              // debugPrint("audio is playing");
                              // debugPrint(widget.dtcontainer.getAudioList()[0]);
                              playAudio(widget.dtcontainer.getAudioList()[0]);
                              // Navigator.pop(context);
                            }),
                        Spacer(),
                        CustomImageView(
                          height: 65.v,
                          fit: BoxFit.contain,
                          width:
                              (MediaQuery.of(context).size.width * 0.4 - 80.h),
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
                    if (widget.dtcontainer.getCorrectOutput().toString() ==
                        widget.dtcontainer.getAudioList()[1]) {
                      // push the widget which will shown after success
                      //      Navigator.push(context, null);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Correct option choosen")),
                        );
                    } else {
                      // push the widget which will shown after failure
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Incorrect option choosen")),
                        );
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 80.v,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.v, horizontal: 10.h),
                    decoration: AppDecoration.outlineBlack9003.copyWith(
                        border: Border.all(
                          width: provider.sel == 1 ? 2.3.h : 1.3.h,
                          color: provider.sel == 1
                              ? appTheme.green900
                              : appTheme.black900,
                        ),
                        borderRadius: BorderRadiusStyle.roundedBorder10),
                    child: Row(
                      children: [
                        CustomButton(
                            type: ButtonType.ImagePlay,
                            onPressed: () {
                              // debugPrint("audio is playing");
                              // debugPrint(widget.dtcontainer.getAudioList()[1]);
                              playAudio(widget.dtcontainer.getAudioList()[1]);
                            }),
                        Spacer(),
                        CustomImageView(
                          height: 65.v,
                          fit: BoxFit.contain,
                          width:
                              (MediaQuery.of(context).size.width * 0.4 - 80.h),
                          imagePath: ImageConstant.imgSpectrum,
                        )
                      ],
                    ),
                  ),
                ),
                Spacer()
              ],
            ));
      case "FigToWord":
        return Container(
          height: 192.v,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            children: [
              Container(
                height: 130.v,
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
                        image:
                            AssetImage("assets/images/radial_ray_orange.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadiusStyle.roundedBorder10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.dtcontainer.getCorrectOutput() ==
                              widget.dtcontainer.getTextList()[0]) {
                            // success widget push
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Correct option choosen")),
                        );
                          } else {
                            // failure widget push
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Incorrect option choosen")),
                        );
                          }
                        },
                        child: Text(
                          widget.dtcontainer.getTextList()[0],
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 130.v,
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
                    borderRadius: BorderRadiusStyle.roundedBorder10),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.dtcontainer.getCorrectOutput() ==
                              widget.dtcontainer.getTextList()[1]) {
                            // success widget push
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Correct option choosen")),
                        );
                          } else {
                            // failure widget push
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Incorrect option choosen")),
                        );
                          }
                        },
                        child: Text(
                          widget.dtcontainer.getTextList()[1],
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
            children: [
              Container(
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
                        image:
                            AssetImage("assets/images/radial_ray_yellow.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadiusStyle.roundedBorder10),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.dtcontainer.getCorrectOutput() ==
                          widget.dtcontainer.getImageUrlList()[0]) {
                        // success widget loader
                        debugPrint("correct option is choosen");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Correct option choosen")),
                        );
                      } else {
                        // failure widget loader
                        debugPrint("incorrect option is choosen");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Incorrect option choosen")),
                        );
                      }
                    },
                    child: Image.network(
                      widget.dtcontainer.getImageUrlList()[0],
                      fit: BoxFit.contain,
                      height: 70.v,
                      width: 50.v,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
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
                        image:
                            AssetImage("assets/images/radial_ray_yellow.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadiusStyle.roundedBorder10),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.dtcontainer.getCorrectOutput() ==
                          widget.dtcontainer.getImageUrlList()[1]) {
                        // success widget loader
                        debugPrint("correct option is choosen");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Correct option choosen")),
                        );
                      } else {
                        // failure widget loader
                        debugPrint("incorrect option is choosen");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Incorrect option choosen")),
                        );
                      }
                    },
                    child: Image.network(
                      widget.dtcontainer.getImageUrlList()[1],
                      fit: BoxFit.contain,
                      height: 70.v,
                      width: 50.v,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case "AudioToImage":
        return Center(
          child: Text("write now not implemented"),
        );
      default:
        return Row();
    }
  }
}
