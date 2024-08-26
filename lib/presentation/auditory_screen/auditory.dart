import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/presentation/auditory_screen/audioToImage.dart';
import 'package:svar_new/presentation/auditory_screen/animation_play.dart';
import 'package:svar_new/presentation/auditory_screen/celebration_overlay.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:video_player/video_player.dart';
import 'provider/auditory_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuditoryScreen extends StatefulWidget {
  const AuditoryScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AuditoryScreenState createState() => AuditoryScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuditoryProvider(),
      child: AuditoryScreen(),
    );
  }
}

class AuditoryScreenState extends State<AuditoryScreen> {
  late bool _isGlowingA;
  late bool _isGlowingB;
  late AudioPlayer _player;
  late int leveltracker;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  OverlayEntry? _overlayEntry;

  Future<void> playAudio(String url) async {
    try {
      AudioCache.instance = AudioCache(prefix: '');
      _player = AudioPlayer();
      await _player.play(UrlSource(url));
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
    var provider = context.watch<AuditoryProvider>();
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
              body: Stack(
                children: [
                  // SVG background
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
                        AuditoryAppBar(context),
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
                                    // Define what happens when the button is tapped
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
          )
        : AudiotoimageScreen(
            dtcontainer: dtcontainer,
            params: params,
          );
  }

  /// Section Widget
  Widget _buildOptionGRP(BuildContext context, AuditoryProvider provider,
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

  Widget buildDynamicOptions(String quizType, AuditoryProvider provider,
      dynamic dtcontainer, String params) {
    switch (quizType) {
      case "ImageToAudio":
        return dtcontainer.getAudioList().length <= 4
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0), // Adjust padding as needed
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.5, // Adjust height as needed
                  width: MediaQuery.of(context).size.width *
                      0.8, // Adjust width as needed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (dtcontainer.getAudioList().length <= 3)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            dtcontainer.getAudioList().length,
                            (index) => GestureDetector(
                              onTap: () async {
                                provider.setSelected(index);
                                if (dtcontainer.getCorrectOutput() ==
                                    dtcontainer.getAudioList()[index]) {
                                  leveltracker = leveltracker + 1;
                                  if (leveltracker > 1) {
                                    provider.incrementLevelCount("completed");
                                  } else {
                                    provider.incrementLevelCount(params);
                                  }
                                  _overlayEntry =
                                      celebrationOverlay(context, () {
                                    _overlayEntry?.remove();
                                  });
                                  Overlay.of(context).insert(_overlayEntry!);
                                } else {
                                  index % 2 == 0
                                      ? _toggleGlowA()
                                      : _toggleGlowB();
                                }
                              },
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                height: 180.v,
                                child: CustomImageView(
                                  onTap: () {
                                    playAudio(
                                        dtcontainer.getAudioList()[index]);
                                  },
                                  height: 100.v,
                                  fit: BoxFit.contain,
                                  imagePath: ImageConstant.imgVol,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (dtcontainer.getAudioList().length == 4)
                        Expanded(
                          child: GridView.builder(
                            // Add padding if needed
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // For a 2x2 grid
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                              childAspectRatio:
                                  1.5, // Adjust the aspect ratio to fit all four buttons
                            ),
                            itemCount: dtcontainer.getAudioList().length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  provider.setSelected(index);
                                  if (dtcontainer.getCorrectOutput() ==
                                      dtcontainer.getAudioList()[index]) {
                                    leveltracker = leveltracker + 1;
                                    if (leveltracker > 1) {
                                      provider.incrementLevelCount("completed");
                                    } else {
                                      provider.incrementLevelCount(params);
                                    }
                                    _overlayEntry =
                                        celebrationOverlay(context, () {
                                      _overlayEntry?.remove();
                                    });
                                    Overlay.of(context).insert(_overlayEntry!);
                                  } else {
                                    index % 2 == 0
                                        ? _toggleGlowA()
                                        : _toggleGlowB();
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: Duration(seconds: 1),
                                  child: CustomImageView(
                                    onTap: () {
                                      playAudio(
                                          dtcontainer.getAudioList()[index]);
                                    },
                                    height:
                                        50.v, // Adjust the height of the images
                                    width:
                                        50.h, // Adjust the width of the images
                                    fit: BoxFit.contain,
                                    imagePath: ImageConstant.imgVol,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                     
                    ],
                  ),
                ),
              )
            : SizedBox();

      case "FigToWord":
        return StatefulBuilder(
          builder: (context, setState) {
            bool isFailure = false; // State to track failure

            return Container(
              height: 192.v,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 250.h,
                                      height: 250.v,
                                      child: SvgPicture.asset(
                                        isFailure
                                            ? "assets/images/svg/Red-Opt-2.svg"
                                            : "assets/images/svg/Opt-2.svg",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (dtcontainer
                                                      .getCorrectOutput() ==
                                                  dtcontainer
                                                      .getTextList()[0]) {
                                                // Success logic
                                              } else {
                                                setState(() {
                                                  isFailure = true;
                                                });
                                              }
                                            },
                                            child: Text(
                                              dtcontainer.getTextList()[0],
                                              style: TextStyle(
                                                fontSize: 40.v,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 250.h,
                                      height: 250.v,
                                      child: SvgPicture.asset(
                                        isFailure
                                            ? "assets/images/svg/Red-Opt-2.svg"
                                            : "assets/images/svg/Opt-2.svg",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              if (dtcontainer
                                                      .getCorrectOutput() ==
                                                  dtcontainer
                                                      .getTextList()[1]) {
                                                // Success logic
                                              } else {
                                                setState(() {
                                                  isFailure = true;
                                                });
                                              }
                                            },
                                            child: Text(
                                              dtcontainer.getTextList()[1],
                                              style: TextStyle(
                                                fontSize: 40.v,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (dtcontainer.getTextList().length > 2)
                              Expanded(
                                // flex: 1,
                                child: AnimatedContainer(
                                  duration: Duration(seconds: 1),
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Stack(
                                    children: [
                                      SvgPicture.asset(
                                        isFailure
                                            ? "assets/images/svg/Red-Opt-2.svg"
                                            : "assets/images/svg/Opt-2.svg",
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                      Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (dtcontainer
                                                        .getCorrectOutput() ==
                                                    dtcontainer
                                                        .getTextList()[2]) {
                                                  // Success logic
                                                } else {
                                                  setState(() {
                                                    isFailure = true;
                                                  });
                                                }
                                              },
                                              child: Text(
                                                dtcontainer.getTextList()[2],
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (dtcontainer.getTextList().length > 3)
                              Expanded(
                                // flex: 1,
                                child: AnimatedContainer(
                                  duration: Duration(seconds: 1),
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  child: Stack(
                                    children: [
                                      SvgPicture.asset(
                                        isFailure
                                            ? "assets/images/svg/Red-Opt-2.svg"
                                            : "assets/images/svg/Opt-2.svg",
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                      Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (dtcontainer
                                                        .getCorrectOutput() ==
                                                    dtcontainer
                                                        .getTextList()[3]) {
                                                  // Success logic
                                                } else {
                                                  setState(() {
                                                    isFailure = true;
                                                  });
                                                }
                                              },
                                              child: Text(
                                                dtcontainer.getTextList()[3],
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Custom button with image at the bottom, change color on failure
                ],
              ),
            );
          },
        );

      case "WordToFig":
        debugPrint("entering in the word to fig section");
        return Container(
          height: MediaQuery.of(context).size.height *
              0.4, // Adjusting height dynamically
          width: MediaQuery.of(context).size.width *
              0.8, // Adjusting the width to fit better
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Distribute space evenly
            children: [
              Padding(
                padding: EdgeInsets.only(right: 0.h),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: 170.v, // Adjusting height dynamically
                  width: 170.h, // Adjusting width dynamically
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        "assets/images/svg/Opt-2.svg",
                        fit: BoxFit
                            .contain, // Ensuring the image doesn't overflow
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (dtcontainer.getCorrectOutput() ==
                                    dtcontainer.getImageUrlList()[0]) {
                                  leveltracker = leveltracker + 1;
                                  if (leveltracker > 1) {
                                    provider.incrementLevelCount("completed");
                                  } else {
                                    provider.incrementLevelCount(params);
                                  }
                                  _overlayEntry =
                                      celebrationOverlay(context, () {
                                    _overlayEntry?.remove();
                                  });
                                  Overlay.of(context).insert(_overlayEntry!);
                                } else {
                                  _toggleGlowA();
                                }
                              },
                              child: Image.network(
                                dtcontainer.getImageUrlList()[0],
                                fit: BoxFit
                                    .contain, // Ensuring the image scales correctly
                                height: 70.v,
                                width: 90.v,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Adjust space between the two blocks
              AnimatedContainer(
                duration: Duration(seconds: 1),
                height: 170.v, // Adjusting height dynamically
                width: 170.h, // Adjusting width dynamically
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      "assets/images/svg/Opt-2.svg",
                      fit:
                          BoxFit.contain, // Ensuring the image doesn't overflow
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (dtcontainer.getCorrectOutput() ==
                                  dtcontainer.getImageUrlList()[1]) {
                                leveltracker = leveltracker + 1;
                                if (leveltracker > 1) {
                                  provider.incrementLevelCount("completed");
                                } else {
                                  provider.incrementLevelCount(params);
                                }
                                _overlayEntry = celebrationOverlay(context, () {
                                  _overlayEntry?.remove();
                                });
                                Overlay.of(context).insert(_overlayEntry!);
                              } else {
                                _toggleGlowA();
                              }
                            },
                            child: Image.network(
                              dtcontainer.getImageUrlList()[1],
                              fit: BoxFit
                                  .contain, // Ensuring the image scales correctly
                              height: 70.v,
                              width: 90.v,
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
        );

      default:
        return Row();
    }
  }
}
