import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/presentation/auditory_screen/audioToImage.dart';
import 'package:svar_new/presentation/auditory_screen/animation_play.dart';
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
                        SizedBox(height: 56.v),
                        _buildOptionGRP(
                            context, provider, type, dtcontainer, params),
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

  Widget buildDynamicOptions(String quizType, AuditoryProvider provider,
      dynamic dtcontainer, String params) {
    switch (quizType) {
      case "ImageToAudio":
        return dtcontainer.getAudioList().length <= 3
            ? Padding(
                padding: EdgeInsets.only(right: 70.h),
                child: Container(
                  height: 192.v,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Stack(
                    children: [
                      // Main content
                      Column(
                        children: [
                          // Title image at the top
                          // Add spacing between the title and Row

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  provider.setSelected(0);
                                  if (dtcontainer.getCorrectOutput() ==
                                      dtcontainer.getAudioList()[0]) {
                                    leveltracker = leveltracker + 1;
                                    if (leveltracker > 1) {
                                      provider.incrementLevelCount("completed");
                                    } else {
                                      provider.incrementLevelCount(params);
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
                                child: AnimatedContainer(
                                  duration: Duration(seconds: 1),
                                  height: 180.v,
                                  child: CustomImageView(
                                    onTap: () {
                                      playAudio(dtcontainer.getAudioList()[0]);
                                    },
                                    height: 100.v,
                                    fit: BoxFit.contain,
                                    imagePath: ImageConstant.imgVol,
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  provider.setSelected(1);
                                  if (dtcontainer
                                          .getCorrectOutput()
                                          .toString() ==
                                      dtcontainer.getAudioList()[1]) {
                                    leveltracker = leveltracker + 1;
                                    if (leveltracker > 1) {
                                      provider.incrementLevelCount("completed");
                                    } else {
                                      provider.incrementLevelCount(params);
                                    }
                                    bool response = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                GifDisplayScreen()));
                                    if (response) {
                                      Navigator.pop(context, true);
                                    }
                                  } else {
                                    _toggleGlowB();
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: Duration(seconds: 1),
                                  height: 180.v,
                                  child: CustomImageView(
                                    onTap: () {
                                      playAudio(dtcontainer.getAudioList()[1]);
                                    },
                                    height: 100.v,
                                    fit: BoxFit.contain,
                                    imagePath: ImageConstant.imgVol,
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          dtcontainer.getAudioList().length > 2
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () async {
                                        provider.setSelected(2);
                                        if (dtcontainer.getCorrectOutput() ==
                                            dtcontainer.getAudioList()[2]) {
                                          leveltracker = leveltracker + 1;
                                          if (leveltracker > 1) {
                                            provider.incrementLevelCount(
                                                "completed");
                                          } else {
                                            provider
                                                .incrementLevelCount(params);
                                          }
                                          bool response =
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          GifDisplayScreen()));
                                          if (response) {
                                            Navigator.pop(context, true);
                                          }
                                        } else {
                                          _toggleGlowA();
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(seconds: 1),
                                        height: 80.v,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.v, horizontal: 10.h),
                                        child: CustomImageView(
                                          onTap: () {
                                            playAudio(
                                                dtcontainer.getAudioList()[2]);
                                          },
                                          height: 100.v,
                                          fit: BoxFit.contain,
                                          imagePath: ImageConstant.imgVol,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    dtcontainer.getAudioList().length > 3
                                        ? GestureDetector(
                                            onTap: () async {
                                              provider.setSelected(3);
                                              if (dtcontainer
                                                      .getCorrectOutput()
                                                      .toString() ==
                                                  dtcontainer
                                                      .getAudioList()[3]) {
                                                leveltracker = leveltracker + 1;
                                                if (leveltracker > 1) {
                                                  provider.incrementLevelCount(
                                                      "completed");
                                                } else {
                                                  provider.incrementLevelCount(
                                                      params);
                                                }
                                                bool response = await Navigator
                                                        .of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            GifDisplayScreen()));
                                                if (response) {
                                                  Navigator.pop(context, true);
                                                }
                                              } else {
                                                _toggleGlowB();
                                              }
                                            },
                                            child: AnimatedContainer(
                                              duration: Duration(seconds: 1),
                                              height: 80.v,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.v,
                                                  horizontal: 10.h),
                                              child: CustomImageView(
                                                onTap: () {
                                                  playAudio(dtcontainer
                                                      .getAudioList()[3]);
                                                },
                                                height: 100.v,
                                                fit: BoxFit.contain,
                                                imagePath: ImageConstant.imgVol,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    Spacer(),
                                  ],
                                )
                              : SizedBox(),
                        ],
                      ),
                      // Custom button with image at the bottom
                      Positioned(
                        bottom: 0, // Position at the bottom
                        right:
                            0, // Adjust to position it at the right side, or use left: 0 for left side
                        child: GestureDetector(
                          onTap: () {
                            // Define what happens when the button is tapped
                          },
                          child: CustomImageView(
                            imagePath: ImageConstant
                                .imgTipbtn, // Replace with the correct image constant
                            height: 40.v, // Adjust size as needed
                            width: 40.h, // Adjust size as needed
                            fit: BoxFit.contain,
                          ),
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
                    children: [
                      SizedBox(
                          height: 8.v), // Add spacing between the image and Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // First Option
                          AnimatedContainer(
                            duration: Duration(seconds: 1),
                            height: 125.v,
                            width: 120.h,
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  isFailure
                                      ? "assets/images/svg/Red-Opt-2.svg" // Change to failure SVG
                                      : "assets/images/svg/Opt-2.svg", // Default SVG
                                  fit: BoxFit.cover,
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
                                          if (dtcontainer.getCorrectOutput() ==
                                              dtcontainer.getTextList()[0]) {
                                            // success widget push
                                            leveltracker = leveltracker + 1;
                                            if (leveltracker > 1) {
                                              provider.incrementLevelCount(
                                                  "completed");
                                            } else {
                                              provider
                                                  .incrementLevelCount(params);
                                            }
                                            bool response = await Navigator.of(
                                                    context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        GifDisplayScreen()));
                                            if (response) {
                                              Navigator.pop(context, true);
                                            }
                                          } else {
                                            // Set failure state
                                            setState(() {
                                              isFailure = true;
                                            });
                                          }
                                        },
                                        child: Text(
                                          dtcontainer.getTextList()[0],
                                          style: TextStyle(fontSize: 40),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(),
                          // Second Option
                          AnimatedContainer(
                            duration: Duration(seconds: 1),
                            height: 125.v,
                            width: 120.h,
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  isFailure
                                      ? "assets/images/svg/Red-Opt-2.svg" // Change to failure SVG
                                      : "assets/images/svg/Opt-2.svg", // Default SVG
                                  fit: BoxFit.cover,
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
                                          if (dtcontainer.getCorrectOutput() ==
                                              dtcontainer.getTextList()[1]) {
                                            // success widget push
                                            leveltracker = leveltracker + 1;
                                            if (leveltracker > 1) {
                                              provider.incrementLevelCount(
                                                  "completed");
                                            } else {
                                              provider
                                                  .incrementLevelCount(params);
                                            }
                                            bool response = await Navigator.of(
                                                    context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        GifDisplayScreen()));
                                            if (response) {
                                              Navigator.pop(context, true);
                                            }
                                          } else {
                                            // Set failure state
                                            setState(() {
                                              isFailure = true;
                                            });
                                          }
                                        },
                                        child: Text(
                                          dtcontainer.getTextList()[1],
                                          style: TextStyle(fontSize: 40),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(),
                          // Check if there are more than 2 options
                          if (dtcontainer.getTextList().length > 2)
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              height: 125.v,
                              width: 120.h,
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    isFailure
                                        ? "assets/images/svg/Red-Opt-2.svg" // Change to failure SVG
                                        : "assets/images/svg/Opt-2.svg", // Default SVG
                                    fit: BoxFit.cover,
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
                                                dtcontainer.getTextList()[2]) {
                                              // success widget push
                                              leveltracker = leveltracker + 1;
                                              if (leveltracker > 1) {
                                                provider.incrementLevelCount(
                                                    "completed");
                                              } else {
                                                provider.incrementLevelCount(
                                                    params);
                                              }
                                              bool response = await Navigator
                                                      .of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          GifDisplayScreen()));
                                              if (response) {
                                                Navigator.pop(context, true);
                                              }
                                            } else {
                                              // Set failure state
                                              setState(() {
                                                isFailure = true;
                                              });
                                            }
                                          },
                                          child: Text(
                                            dtcontainer.getTextList()[2],
                                            style: TextStyle(fontSize: 40),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Check if there are more than 3 options
                          if (dtcontainer.getTextList().length > 3) Spacer(),
                          if (dtcontainer.getTextList().length > 3)
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              height: 125.v,
                              width: 120.h,
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    isFailure
                                        ? "assets/images/svg/Red-Opt-2.svg" // Change to failure SVG
                                        : "assets/images/svg/Opt-2.svg", // Default SVG
                                    fit: BoxFit.cover,
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
                                                dtcontainer.getTextList()[3]) {
                                              // success widget push
                                              leveltracker = leveltracker + 1;
                                              if (leveltracker > 1) {
                                                provider.incrementLevelCount(
                                                    "completed");
                                              } else {
                                                provider.incrementLevelCount(
                                                    params);
                                              }
                                              bool response = await Navigator
                                                      .of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          GifDisplayScreen()));
                                              if (response) {
                                                Navigator.pop(context, true);
                                              }
                                            } else {
                                              // Set failure state
                                              setState(() {
                                                isFailure = true;
                                              });
                                            }
                                          },
                                          child: Text(
                                            dtcontainer.getTextList()[3],
                                            style: TextStyle(fontSize: 40),
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
                    ],
                  ),
                  // Custom button with image at the bottom, change color on failure
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Define what happens when the button is tapped
                      },
                      child: CustomImageView(
                        imagePath // Red or different image on failure
                            : ImageConstant.imgTipbtn, // Default image
                        height: 40.v,
                        width: 40.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
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
                padding: EdgeInsets.only(right: 10.h),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: MediaQuery.of(context).size.height *
                      0.3, // Adjusting height dynamically
                  width: MediaQuery.of(context).size.width *
                      0.3, // Adjusting width dynamically
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
                height: MediaQuery.of(context).size.height *
                    0.3, // Adjusting height dynamically
                width: MediaQuery.of(context).size.width *
                    0.3, // Adjusting width dynamically
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
