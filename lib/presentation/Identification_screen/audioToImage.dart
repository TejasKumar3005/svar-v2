import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/Identification_screen/animation_play.dart';
import 'package:svar_new/presentation/Identification_screen/celebration_overlay.dart';
import 'package:svar_new/presentation/Identification_screen/provider/identification_provider.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:svar_new/core/utils/audioSampleExtractor.dart';
class AudiotoimageScreen extends StatefulWidget {
  final dynamic dtcontainer;
  final String params;
  const AudiotoimageScreen(
      {Key? key, required this.dtcontainer, required this.params})
      : super(
          key: key,
        );

  @override
  AudiotoimageScreenState createState() => AudiotoimageScreenState();

  static Widget builder(BuildContext context, dynamic dtcontainer) {
    return AudiotoimageScreen(
      dtcontainer: null,
      params: '',
    );
  }
}

class AudiotoimageScreenState extends State<AudiotoimageScreen> {
  late AudioPlayer _player;
  late bool _isGlowingA;
  late bool _isGlowingB;
  late int leveltracker;

  Future<void> playAudio(String url) async {
    try {
      AudioCache.instance = AudioCache(prefix: '');
      _player = AudioPlayer();
      await _player.play(UrlSource(url));
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _player = AudioPlayer();
    _isGlowingA = false;
    _isGlowingB = false;
    leveltracker = 0;
  }

  int sel = 0;
  List<double> samples = [];
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<IdentificationProvider>();
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
                        onTap: () async {
                          AudioSampleExtractor extractor = AudioSampleExtractor();
                          samples = await extractor.getNetorkAudioSamples(widget.dtcontainer.getAudioUrl());
                          setState(() {
                            
                          });
                          playAudio(widget.dtcontainer.getAudioUrl());

                          // Get the audio samples using the audiowaveform package
                        


                        },
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              "assets/images/svg/Audio-Bar.svg",
                              height: 50.v,
                              width: MediaQuery.of(context).size.width / 2,
                              fit: BoxFit.fill,
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: PolygonWaveform(
                                samples: samples, // Use the updated samples
                                height: 20.v,
                                width: MediaQuery.of(context).size.width / 2,
                                inactiveColor: Colors.white.withOpacity(0.5),
                                activeColor: Colors.white,
                              ),
                            ),
                          ],
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
                                  _overlayEntry =
                                      celebrationOverlay(context, () {
                                    _overlayEntry?.remove();
                                  });
                                  Overlay.of(context).insert(_overlayEntry!);
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
                                    _overlayEntry =
                                        celebrationOverlay(context, () {
                                      _overlayEntry?.remove();
                                    });
                                    Overlay.of(context).insert(_overlayEntry!);
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