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
import 'package:svar_new/widgets/custom_button.dart';

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
  // Variable to store the correct answer

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

    // Fetch correct answer from the database
    fetchCorrectAnswer();
  }

  // Function to fetch the correct answer from the database
  void fetchCorrectAnswer() {
    // Assuming you have a method in your database controller to get the correct answer
    String correctOutput = widget.dtcontainer.getCorrectOutput();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> playAudio(String url) async {
    try {
      await _player.play(UrlSource(url));
    } catch (e) {
      print('Error initializing player: $e');
    }
  }
void _handleOptionTap(int index, String optionType) {
  // Fetch the correct output from dtcontainer
  String correctOutput = widget.dtcontainer.getCorrectOutput();
  String selectedOption = widget.dtcontainer.getAudioList()[index];

  // Check if the selected option matches the correct output
  if (correctOutput == selectedOption) {
    // Correct answer logic here
    print('Correct answer selected');
  } else {
    // If the selected option is incorrect, apply red glow
    if (optionType == "A") {
      _toggleGlowA(true); // Incorrect answer, apply red glow to option A
    } else if (optionType == "B") {
      _toggleGlowB(true); // Incorrect answer, apply red glow to option B
    }
  }
}


  void _toggleGlowA(bool isError) {
    setState(() {
      _isGlowingA = true;
    });

    // Apply red glow for incorrect answer, or remove glow after 1 second
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isGlowingA = false;
      });
    });
  }

  void _toggleGlowB(bool isError) {
    setState(() {
      _isGlowingB = true;
    });

    // Apply red glow for incorrect answer, or remove glow after 1 second
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
              Positioned.fill(
                child: SvgPicture.asset(
                  ImageConstant.imgAuditorybg,
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
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.h,
                                  vertical: 5.v,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 255, 128, 0),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomButton(
                                      type: ButtonType.ImagePlay,
                                      onPressed: () async {
                                        AudioSampleExtractor extractor =
                                            AudioSampleExtractor();
                                        samples = await extractor
                                            .getNetorkAudioSamples(widget
                                                .dtcontainer
                                                .getAudioUrl());
                                        playAudio(widget.dtcontainer.getAudioUrl()[0]);
                                      },
                                    ),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    CustomImageView(
                                      width: MediaQuery.of(context).size.width *
                                              0.4 -
                                          90,
                                      height: 60,
                                      fit: BoxFit.fill,
                                      imagePath: "assets/images/spectrum.png",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 50.v),
                          Row(
                            children: [
                              _buildAnimatedContainer(
                                  widget.dtcontainer.getImageUrlList()[0],
                                  () => _handleOptionTap(widget.dtcontainer.getImageUrlList()[0], "A")),
                              SizedBox(width: 50.h),
                              _buildAnimatedContainer(
                                  widget.dtcontainer.getImageUrlList()[1],
                                  () => _handleOptionTap(widget.dtcontainer.getImageUrlList()[1], "B")),
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
        height: 202.0,
        decoration: AppDecoration.fillCyan.copyWith(
          border: Border.all(
            color: appTheme.black900,
            width: 2.adaptSize,
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/radial_ray_bluegreen.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadiusStyle.roundedBorder10,
          boxShadow: (_isGlowingA && imagePath == widget.dtcontainer.getImageUrlList()[0]) ||
                  (_isGlowingB && imagePath == widget.dtcontainer.getImageUrlList()[1])
              ? [
                  BoxShadow(
                    color: Color.fromARGB(255, 255, 0, 0).withOpacity(0.6), // Red glow
                    spreadRadius: 10,
                    blurRadius: 5,
                  ),
                ]
              : [],
        ),
        child: GestureDetector(
          onTap: onTapCallback,
          child: FittedBox(
            fit: BoxFit.fill,
            child: CustomImageView(
              imagePath: imagePath,
            ),
          ),
        ),
      ),
    );
  }
}
