// identification_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'provider/identification_provider.dart';
import 'package:svar_new/presentation/Identification_screen/audioToImage.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/options.dart';
import 'package:svar_new/widgets/tutorial_coach_mark/lib/tutorial_coach_mark.dart';
import 'package:rive/rive.dart';

class IdentificationScreen extends StatefulWidget {
  const IdentificationScreen({Key? key}) : super(key: key);

  @override
  AuditoryScreenState createState() => AuditoryScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IdentificationProvider(),
      child: IdentificationScreen(),
    );
  }
}

class AuditoryScreenState extends State<IdentificationScreen> {
  late AudioPlayer _player;
  late int leveltracker;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  OverlayEntry? _overlayEntry;

  // List to hold all GlobalKeys from OptionWidgets
  final List<GlobalKey<OptionWidgetState>> optionKeys = [];

  // TutorialCoachMark instance
  TutorialCoachMark? tutorialCoachMark;

  @override
  void dispose() {
    _player.dispose();
    _videoPlayerController?.dispose();
    // _chewieController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Replace this with your condition to show the tutorial
    bool shouldShowTutorial = true; // Set this based on your logic

    if (shouldShowTutorial) {
      Future.delayed(Duration(milliseconds: 500), _initTutorial);
      Future.delayed(Duration(milliseconds: 1000), showTutorial);
    }

    _player = AudioPlayer();

    leveltracker = 0;
  }

  int sel = 0;

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<IdentificationProvider>();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
    dynamic dtcontainer = obj[1] as dynamic;
    String params = obj[2] as String;

    return type != "AudioToImage"
        ? (type == "AudioToAudio"
            ? Container()
            : SafeArea(
                child: Scaffold(
                  extendBody: true,
                  extendBodyBehindAppBar: true,
                  backgroundColor: appTheme.gray300,
                  body: Stack(
                    children: [
                      Positioned.fill(
                        child: SvgPicture.asset(
                          ImageConstant
                              .imgAuditorybg, // Replace with your SVG path
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Main content
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.h,
                          vertical: 10.v,
                        ),
                        child: Column(
                          children: [
                            DisciAppBar(context),
                            Expanded(
                              child: Stack(
                                children: [
                                  Center(
                                    child: _buildOptionGRP(
                                      context,
                                      provider,
                                      type,
                                      dtcontainer,
                                      params,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        : AudiotoimageScreen(
            dtcontainer: dtcontainer,
            params: params,
          );
  }

  /// Section Widget
  Widget _buildOptionGRP(BuildContext context, IdentificationProvider provider,
      String type, dynamic dtcontainer, String params) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.h),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 192.v,
                  padding: EdgeInsets.all(1.h),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusStyle.roundedBorder15,
                        child: SvgPicture.asset(
                          "assets/images/svg/QUestion.svg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (type == "WordToFig")
                        Center(
                          child: Text(
                            dtcontainer.getImageUrl(),
                            style: TextStyle(fontSize: 90),
                          ),
                        )
                      else
                        CustomImageView(
                          imagePath: dtcontainer.getImageUrl(),
                          radius: BorderRadiusStyle.roundedBorder15,
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: buildDynamicOptions(
                    type, provider, dtcontainer, params),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDynamicOptions(String quizType, IdentificationProvider provider,
      dynamic dtcontainer, String params) {
    switch (quizType) {
      case "ImageToAudio":
        return dtcontainer.getAudioList().length <= 4
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      ...List.generate(dtcontainer.getAudioList().length,
                          (index) {
                        final GlobalKey<OptionWidgetState> optionKey =
                            GlobalKey<OptionWidgetState>();
                        optionKeys.add(optionKey);
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: OptionWidget(
                              child: AudioWidget(
                                audioLinks: [dtcontainer.getAudioList()[index]],
                              ),
                              isCorrect: () =>
                                  dtcontainer.getCorrectOutput() ==
                                  dtcontainer.getAudioList()[index],
                              optionKey: optionKey,
                              align: ContentAlign.onside,
                              tutorialOrder: index + 1,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              )
            : SizedBox();

      case "FigToWord":
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 192.v,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (dtcontainer.getTextList().length <= 4)
                                ...List.generate(
                                    dtcontainer.getTextList().length, (index) {
                                  final GlobalKey<OptionWidgetState> optionKey =
                                      GlobalKey<OptionWidgetState>();
                                  optionKeys.add(optionKey);
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      OptionWidget(
                                        child: TextContainer(
                                          text: dtcontainer.getTextList()[index],
                                        ),
                                        isCorrect: () {
                                          return dtcontainer.getCorrectOutput() ==
                                              dtcontainer.getTextList()[index];
                                        },
                                        optionKey: optionKey,
                                        align: ContentAlign.ontop,
                                        tutorialOrder: index + 1,
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  );
                                })
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );

      case "WordToFig":
        return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (dtcontainer.getImageUrlList().length <= 4)
                  ...List.generate(dtcontainer.getImageUrlList().length,
                      (index) {
                    final GlobalKey<OptionWidgetState> optionKey =
                        GlobalKey<OptionWidgetState>();
                    optionKeys.add(optionKey);
                    return Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: OptionWidget(
                              child: ImageWidget(
                                imagePath:
                                    dtcontainer.getImageUrlList()[index],
                              ),
                              isCorrect: () {
                                return dtcontainer.getCorrectOutput() ==
                                    dtcontainer.getImageUrlList()[index];
                              },
                              align: ContentAlign.ontop,
                              optionKey: optionKey,
                              tutorialOrder: index + 1,
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    );
                  }),
              ],
            ));

      default:
        return Row();
    }
  }

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
