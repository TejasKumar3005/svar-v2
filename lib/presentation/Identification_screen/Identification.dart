// identification_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
  final List<GlobalKey> optionKeys = [];

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
                          ImageConstant.imgAuditorybg, // Replace with your SVG path
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
                                        // Trigger the tutorial via the provider
                                        provider.startTutorial();
                                        // Initialize and show the tutorial
                                        WidgetsBinding.instance.addPostFrameCallback(
                                            (_) => _showTutorial());
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
                    type, provider, dtcontainer, params, optionKeys),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDynamicOptions(String quizType, IdentificationProvider provider,
      dynamic dtcontainer, String params, List<GlobalKey> keys) {
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
                      ...List.generate(dtcontainer.getAudioList().length, (index) {
                        final GlobalKey optionKey = GlobalKey();
                        // Add the key to the list
                        keys.add(optionKey);

                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: OptionWidget(
                              child: AudioWidget(
                                audioLinks: [dtcontainer.getAudioList()[index]],
                                imagePlayButtonKey: GlobalKey(),
                                tutorialIndex: index + 1,
                              ),
                              isCorrect: () =>
                                  dtcontainer.getCorrectOutput() ==
                                  dtcontainer.getAudioList()[index],
                              optionKey: optionKey,
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
            // State to track failure

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
                                ...List.generate(dtcontainer.getTextList().length,
                                    (index) {
                                  final GlobalKey optionKey = GlobalKey();
                                  // Add the key to the list
                                  keys.add(optionKey);

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        tutorialOrder: index + 1,
                                      ),
                                      SizedBox(
                                          width:
                                              10), // Adds gap between each OptionWidget
                                      // Adds gap between each OptionWidget
                                    ],
                                  );
                                })
                            ],
                          ),
                        ),
                      ],
                    ),
                  )

                  // Custom button with image at the bottom, change color on failure
                ],
              ),
            );
          },
        );

      case "WordToFig":
        debugPrint("entering in the word to fig section");
        return Container(
            height: MediaQuery.of(context).size.height * 0.4, // Adjusting height dynamically
            width: MediaQuery.of(context).size.width * 0.8, // Adjusting the width to fit better
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Distribute space evenly
              children: [
                if (dtcontainer.getImageUrlList().length <= 4)
                  ...List.generate(dtcontainer.getImageUrlList().length, (index) {
                    final GlobalKey optionKey = GlobalKey();
                    // Add the key to the list
                    keys.add(optionKey);

                    return Expanded(
                      // Each item will take up available space based on the flex value
                      flex: 1, // Adjust the flex as needed to control the width ratio
                      child: Row(
                        children: [
                          Expanded(
                            flex:
                                2, // Adjust the flex value for the OptionWidget
                            child: OptionWidget(
                              child: ImageWidget(
                                imagePath: dtcontainer.getImageUrlList()[index],
                              ),
                              isCorrect: () {
                                return dtcontainer.getCorrectOutput() ==
                                    dtcontainer.getImageUrlList()[index];
                              },
                              optionKey: optionKey, // Add this
                              tutorialOrder: index + 1, // Add this
                            ),
                          ),
                          SizedBox(
                              width: 10), // Adds gap between each OptionWidget
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

  /// Method to initialize and show the tutorial
  void _showTutorial() {
    if (tutorialCoachMark != null) return; // Prevent multiple tutorials

    tutorialCoachMark = TutorialCoachMark(
     
      targets: _createTargets(),
      colorShadow: const Color.fromARGB(255, 0, 0, 0),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        // Notify the provider to stop the tutorial
        Provider.of<IdentificationProvider>(context, listen: false)
            .stopTutorial();
        tutorialCoachMark = null;
      },
      onSkip: () {
        // Notify the provider to stop the tutorial
        Provider.of<IdentificationProvider>(context, listen: false)
            .stopTutorial();
        tutorialCoachMark = null;
        return true;
      },
    );

    tutorialCoachMark?.show(context:context);
  }

  /// Create tutorial targets based on the collected GlobalKeys
  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    for (int i = 0; i < optionKeys.length; i++) {
      targets.add(
        TargetFocus(
          identify: "tutorial_step_${i + 1}",
          keyTarget: optionKeys[i],
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: _buildTutorialContent(
                _getTutorialMessage(i + 1),
                isCorrect: false,
              ),
            ),
          ],
        ),
      );
    }

    return targets;
  }

  String _getTutorialMessage(int step) {
    switch (step) {
      case 1:
        return "Here are your answer options!";
      case 2:
        return "Click on the option you think is correct";
      case 3:
        return "If wrong, the option will glow red";
      case 4:
        return "If correct, you'll see a celebration!";
      default:
        return "Try to answer the question";
    }
  }

  Widget _buildTutorialContent(String text, {required bool isCorrect}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green : Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
}
