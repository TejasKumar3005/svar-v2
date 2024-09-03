import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/Identification_screen/animation_play.dart';
import 'package:svar_new/presentation/Identification_screen/celebration_overlay.dart';
import 'package:svar_new/presentation/Identification_screen/provider/identification_provider.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:svar_new/core/utils/audioSampleExtractor.dart';

class AudiotoimageScreen extends StatefulWidget {
  final dynamic dtcontainer;
  final String params;

  const AudiotoimageScreen({
    Key? key,
    required this.dtcontainer,
    required this.params,
  }) : super(key: key);

  @override
  AudiotoimageScreenState createState() => AudiotoimageScreenState();

  static Widget builder(BuildContext context, dynamic dtcontainer) {
    return AudiotoimageScreen(
      dtcontainer: dtcontainer,
      params: '',
    );
  }
}

class AudiotoimageScreenState extends State<AudiotoimageScreen> {
  late AudioPlayer _player;
  late bool _isGlowingA;
  late bool _isGlowingB;
  late int leveltracker;
  int sel = 0;
  List<double> samples = [];
  OverlayEntry? _overlayEntry;

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

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> playAudio(String url) async {
    try {
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
          child: Stack(
            children: [
              // Use SVG background image
             Positioned.fill(
                    child: SvgPicture.asset(
                      ImageConstant.imgAuditorybg, // Replace with your SVG path
                      fit: BoxFit.cover,
                    ),
                  ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
                child: Column(
                  children: [
                    AuditoryAppBar(context),
                    Spacer(flex: 2),
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
                                setState(() {});
                                playAudio(widget.dtcontainer.getAudioUrl());
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
                                      samples: samples,
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
                              _buildAnimatedContainer(
                                  widget.dtcontainer.getImageUrlList()[0], _toggleGlowA),
                              SizedBox(width: 50.h),
                              _buildAnimatedContainer(
                                  widget.dtcontainer.getImageUrlList()[1], _toggleGlowB),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(flex: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(String imagePath, VoidCallback onTapCallback) {
    return Expanded(
      child: AnimatedContainer(
        duration: Duration(seconds: 1),
        height: 120.v,
        decoration: AppDecoration.fillCyan.copyWith(
          border: Border.all(
            color: appTheme.black900,
            width: 2.adaptSize,
          ),
          image: DecorationImage(
              image: AssetImage("assets/images/radial_ray_bluegreen.png")),
          borderRadius: BorderRadiusStyle.roundedBorder10,
          boxShadow: _isGlowingA
              ? [
                  BoxShadow(
                    color: Color.fromARGB(255, 202, 1, 1).withOpacity(0.6),
                    spreadRadius: 10,
                    blurRadius: 5,
                  ),
                ]
              : [],
        ),
        child: GestureDetector(
          onTap: onTapCallback,
          child: CustomImageView(
            fit: BoxFit.contain,
            imagePath: imagePath,
          ),
        ),
      ),
    );
  }
}
