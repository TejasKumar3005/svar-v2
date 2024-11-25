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
import 'package:svar_new/widgets/tutorial_coach_mark/lib/src/widgets/animated_focus_light.dart';

class IdentificationScreen extends StatefulWidget {
  const IdentificationScreen({Key? key, this.clickTarget}) : super(key: key);

  final Future<void> Function(TargetFocus?)? clickTarget;

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
  TargetFocus? _targetFocus;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  OverlayEntry? _overlayEntry;
  int nextIndex = 0;
 

  // List to collect GlobalKeys of OptionWidgets
  final List<GlobalKey> optionKeys = [];
  TutorialCoachMark? tutorialCoachMark;

  @override
  void dispose() {
    _player.dispose();
    _videoPlayerController?.dispose();
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

   Future _tapHandler({
    bool targetTap = false,
    bool overlayTap = false,
  }) async {
    print("tapped");
    nextIndex++;
    if (targetTap) {
      await widget.clickTarget?.call(_targetFocus);
    }
    // return _revertAnimation();
  }

  // Initialize the tutorial
  void _initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black.withOpacity(0.5),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0,
      onFinish: () {
        print("Tutorial finished");
      },
      onSkip: () {
        print("Tutorial skipped");
        return true;
      },
    );
  }

  // Create tutorial targets for each OptionWidget
  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    for (int i = 0; i < optionKeys.length; i++) {
      final GlobalKey optionKey = optionKeys[i];

      OptionWidget? optionWidget = optionKey.currentWidget as OptionWidget?;
      if (optionWidget == null) {
        continue; // Or handle accordingly
      }

      ContentAlign align = optionWidget.align;

      targets.add(
        TargetFocus(
          identify: "Option_${i + 1}",
          keyTarget: optionKey,
          contents: [
            TargetContent(
              align: align,
              builder: (context, controller) {
                return _buildTutorialContent(
                  "This is option ${i + 1}",
                  isCorrect: false,
                );
              },
            ),
          ],
        ),
      );
    }

    for (int i = 0; i < optionKeys.length; i++) {
      final GlobalKey optionKey = optionKeys[i];

      OptionWidget? optionWidget = optionKey.currentWidget as OptionWidget?;
      if (optionWidget == null) {
        continue; 
      }

      ContentAlign align = optionWidget.align;

      targets.add(
        TargetFocus(
          identify: "Option_${i + 1}",
          keyTarget: optionKey,
          contents: [
            TargetContent(
              align: ContentAlign.ontop,
              builder: (context, controller) {
                return _buildTutorialContent(
                  "This is the correct option ",
                  isCorrect: true,
                );
              },
            ),
          ],
        ),
      );
    }

    return targets;
  }

  // Build the content for each tutorial step
  Widget _buildTutorialContent(String text, {required bool isCorrect}) {
    return 
    IgnorePointer(
      child:
    Container(
      width: MediaQuery.of(context).size.width * 0.8,
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
      )
    );
  }

  // Show the tutorial
  void showTutorial() {
    tutorialCoachMark?.show(context: context);
  }

  int sel = 0;

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<IdentificationProvider>();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
    dynamic dtcontainer = obj[1];
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
                          ImageConstant.imgAuditorybg,
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
                                        // Initialize and show the tutorial when tip button is clicked
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
                    type, provider, dtcontainer, params, optionKeys),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build dynamic options
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
                    children: List.generate(dtcontainer.getAudioList().length,
                        (index) {
                      final GlobalKey optionKey = GlobalKey();
                      keys.add(optionKey);
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: OptionWidget(
                            optionKey: optionKey,
                            child: AudioWidget(
                              audioLinks: [dtcontainer.getAudioList()[index]],
                            ),
                            isCorrect: () => dtcontainer.getCorrectOutput() ==
                                dtcontainer.getAudioList()[index],
                            align: ContentAlign.onside,
                            
                            tutorialOrder: index+1,
                          ),
                        ),
                      );
                    }),
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
                                ...List.generate(dtcontainer.getTextList().length,
                                    (index) {
                                  final GlobalKey optionKey = GlobalKey();
                                  keys.add(optionKey);
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OptionWidget(
                                        optionKey: optionKey,
                                        align: ContentAlign.ontop,
                                       
                                        child: TextContainer(
                                          text: dtcontainer.getTextList()[index],
                                        ),
                                        isCorrect: () {
                                          return dtcontainer.getCorrectOutput() ==
                                              dtcontainer.getTextList()[index];
                                        },
                                        tutorialOrder: index,
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
                  ),
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
                  ...List.generate(dtcontainer.getImageUrlList().length, (index) {
                    final GlobalKey optionKey = GlobalKey();
                    keys.add(optionKey);

                    return Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: OptionWidget(
                              optionKey: optionKey,
                              child: ImageWidget(
                                imagePath: dtcontainer.getImageUrlList()[index],
                              ),
                              isCorrect: () {
                                return dtcontainer.getCorrectOutput() ==
                                    dtcontainer.getImageUrlList()[index];
                              },
                              align: ContentAlign.ontop,
                              tutorialOrder: index,
                            
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
}
