import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/presentation/identification_screen/audioToImage.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:video_player/video_player.dart';
import 'provider/identification_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/Options.dart';

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
  Map<String, GlobalKey<OptionWidgetState>> optionKeys = {};
  Map<String, GlobalKey> imagePlayButtonKeys = {};
  ChewieController? _chewieController;
  OverlayEntry? _overlayEntry;

  // Flag to ensure all AudioWidget tutorials complete before starting OptionWidget tutorials
  bool areAudioTutorialsComplete = false;
  int completedAudioTutorials = 0;

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Initialize _player and leveltracker in initState
    _player = AudioPlayer();
    leveltracker = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    dynamic dtcontainer = obj[1] as dynamic;
    int totalAudioTutorials = dtcontainer.getAudioList().length;

    // Initialize keys only if they haven't been created yet
    if (optionKeys.isEmpty) {
      for (int i = 0; i < totalAudioTutorials; i++) {
        String keyId = 'option_$i';
        optionKeys[keyId] = GlobalKey<OptionWidgetState>();
        imagePlayButtonKeys[keyId] = GlobalKey();
      }
    }
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
                          ImageConstant.imgAuditorybg,
                          fit: BoxFit.cover,
                        ),
                      ),
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
                                      onTap: () {},
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
                child: buildDynamicOptions(type, provider, dtcontainer, params),
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
        int totalAudioTutorials = dtcontainer.getAudioList().length;
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
                        String keyId = 'option_$index';
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: OptionWidget(
                              child: AudioWidget(
                                audioLinks: [dtcontainer.getAudioList()[index]],
                                imagePlayButtonKey: imagePlayButtonKeys[keyId]!,
                                tutorialIndex: index + 1,
                                onTutorialComplete: () {
                                  setState(() {
                                    completedAudioTutorials += 1;
                                    if (completedAudioTutorials ==
                                        totalAudioTutorials) {
                                      areAudioTutorialsComplete = true;
                                      optionKeys.forEach((_, key) {
                                        final state = key.currentState;
                                        if (state != null) {
                                          state.startTutorialIfAllowed();
                                        }
                                      });
                                    }
                                  });
                                },
                              ),
                              isCorrect: () =>
                                  dtcontainer.getCorrectOutput() ==
                                  dtcontainer.getAudioList()[index],
                              optionKey: optionKeys[keyId]!,
                              tutorialOrder: index + 1,
                              areAudioTutorialsComplete:
                                  areAudioTutorialsComplete,
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
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OptionWidget(
                                        child: TextContainer(
                                          text:
                                              dtcontainer.getTextList()[index],
                                        ),
                                        isCorrect: () {
                                          return dtcontainer
                                                  .getCorrectOutput() ==
                                              dtcontainer.getTextList()[index];
                                        },
                                        optionKey: GlobalKey(),
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
                    return Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: OptionWidget(
                              child: ImageWidget(
                                imagePath: dtcontainer.getImageUrlList()[index],
                              ),
                              isCorrect: () {
                                return dtcontainer.getCorrectOutput() ==
                                    dtcontainer.getImageUrlList()[index];
                              },
                              optionKey: GlobalKey(),
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
}
