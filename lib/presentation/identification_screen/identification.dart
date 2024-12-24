import 'provider/identification_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/identification_screen/audioToImage.dart';
import 'package:svar_new/presentation/identification_screen/celebration_overlay.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/widgets/audio_widget.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/widgets/image_option.dart';
import 'package:svar_new/widgets/text_option.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  late UserData userData;
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _correctInput;
  SMIInput<bool>? _incorrectInput;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _player = AudioPlayer();
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    try {
      final bytes = await rootBundle.load('assets/rive/Celebration_animation.riv');
      final file = RiveFile.import(bytes);
      final artboard = file.mainArtboard;
      _controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');

      if (_controller != null) {
        artboard.addController(_controller!);
        _correctInput = _controller!.findInput<bool>('correct');
        _incorrectInput = _controller!.findInput<bool>('incorrect');
      }

      setState(() => _riveArtboard = artboard);
    } catch (e) {
      print('Error loading Rive file: $e');
    }
  }

  void _triggerAnimation(bool isCorrect) {
    if (_correctInput != null && _incorrectInput != null) {
      setState(() {
        _correctInput!.value = isCorrect;
        _incorrectInput!.value = !isCorrect;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<IdentificationProvider>();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    String type = obj[0] as String;
    dynamic dtcontainer = obj[1] as dynamic;
    String params = obj[2] as String;
    int level = obj[3] as int;

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
                                      level,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 16.h,
                                    left: 16.h,
                                    child: _riveArtboard == null
                                        ? const Center(child: CircularProgressIndicator())
                                        : RiveAnimation.direct(
                                            RiveFile.import(await rootBundle.load('assets/rive/Celebration_animation.riv')),
                                            fit: BoxFit.contain,
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
        : AudiotoimageScreen(dtcontainer: dtcontainer, params: params);
  }

  Widget _buildOptionGRP(BuildContext context, IdentificationProvider provider,
      String type, dynamic dtcontainer, String params, int level) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.h),
      child: Row(
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
                  (type == "WordToFig")
                      ? Center(
                          child: Text(
                            dtcontainer.getImageUrl(),
                            style: const TextStyle(fontSize: 90),
                          ),
                        )
                      : CustomImageView(
                          imagePath: dtcontainer.getImageUrl(),
                          radius: BorderRadiusStyle.roundedBorder15,
                        ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
                child: buildDynamicOptions(type, provider, dtcontainer, params, level, _triggerAnimation)),
          ),
        ],
      ),
    );
  }

  Widget buildDynamicOptions(String quizType, IdentificationProvider provider,
      dynamic dtcontainer, String params, int level, Function(bool) triggerAnimation) {
    switch (quizType) {
      case "ImageToAudio":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: dtcontainer.getAudioList().length <= 2
              ? Column(
                  children:
                      List.generate(dtcontainer.getAudioList().length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: OptionWidget(
                        triggerAnimation: triggerAnimation,
                        child: AudioWidget(
                          audioLinks: [dtcontainer.getAudioList()[index]],
                        ),
                        isCorrect: () {
                          bool isCorrect = dtcontainer.getCorrectOutput() == dtcontainer.getAudioList()[index];
                          if (isCorrect) {
                            userData.incrementLevelCount("Identification", level);
                          }
                          return isCorrect;
                        },
                      ),
                    );
                  }),
                )
              : Center(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1.6,
                    ),
                    itemCount: dtcontainer.getAudioList().length,
                    itemBuilder: (context, index) {
                      return OptionWidget(
                        triggerAnimation: triggerAnimation,
                        child: AudioWidget(
                          audioLinks: [dtcontainer.getAudioList()[index]],
                          isGrid: true,
                        ),
                        isCorrect: () {
                          bool isCorrect = dtcontainer.getCorrectOutput() == dtcontainer.getAudioList()[index];
                          if (isCorrect) {
                            userData.incrementLevelCount("Identification", level);
                          }
                          return isCorrect;
                        },
                      );
                    },
                  ),
                ),
        );
      case "FigToWord":
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 192.v,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Center(
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
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OptionWidget(
                                    triggerAnimation: triggerAnimation,
                                    child: TextContainer(
                                      text: dtcontainer.getTextList()[index],
                                    ),
                                    isCorrect: () {
                                      bool isCorrect = dtcontainer.getCorrectOutput() == dtcontainer.getTextList()[index];
                                      if (isCorrect) {
                                        userData.incrementLevelCount("Identification", level);
                                      }
                                      return isCorrect;
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              );
                            })
                        ],
                      ),
                    ),
                  ],
                ),
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
                  return Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: OptionWidget(
                            triggerAnimation: triggerAnimation,
                            child: ImageWidget(
                              imagePath: dtcontainer.getImageUrlList()[index],
                            ),
                            isCorrect: () {
                              bool isCorrect = dtcontainer.getCorrectOutput() == dtcontainer.getImageUrlList()[index];
                              if (isCorrect) {
                                userData.incrementLevelCount("Identification", level);
                              }
                              return isCorrect;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  );
                }),
            ],
          ),
        );
      default:
        return const Row();
    }
  }
}

class OptionWidget extends StatefulWidget {
  final Widget child;
  final bool Function() isCorrect;
  final Function(bool) triggerAnimation;

  const OptionWidget({
    required this.child,
    required this.isCorrect,
    required this.triggerAnimation,
    Key? key,
  }) : super(key: key);

  @override
  _OptionWidgetState createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  bool _isGlowing = false;
  OverlayEntry? _overlayEntry;

  void click() {
    bool isCorrectResult = widget.isCorrect();
    widget.triggerAnimation(isCorrectResult); // Trigger animation

    if (isCorrectResult) {
      _overlayEntry = celebrationOverlay(context, () {
        _overlayEntry?.remove();
      });
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      setState(() {
        _isGlowing = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isGlowing = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isGlowing
            ? [
                BoxShadow(
                  color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.6),
                  spreadRadius: 8,
                  blurRadius: 5,
                ),
              ]
            : [],
      ),
      child: ClickProvider(child: widget.child, click: click),
    );
  }
}

class ClickProvider extends InheritedWidget {
  final VoidCallback click;

  const ClickProvider({
    Key? key,
    required Widget child,
    required this.click,
  }) : super(key: key, child: child);

  static ClickProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClickProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}