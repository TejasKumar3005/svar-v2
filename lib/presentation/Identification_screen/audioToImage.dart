import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/Identification_screen/provider/identification_provider.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/Options.dart';

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

  late int leveltracker;
  int sel = 0;
  List<double> samples = [];
  OverlayEntry? _overlayEntry;
  // Variable to store the correct answer
Map<String,GlobalKey<OptionWidgetState>> keymap = {};
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    keymap["option_0"] = new GlobalKey();
    _player = AudioPlayer();
    leveltracker = 0;


    // Fetch correct answer from the database
  }

  // Function to fetch the correct answer from the database

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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
                    DisciAppBar(context),
                    Spacer(flex: 2),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(
                            child: GestureDetector(
                          
                                child: AudioWidget(
                                  audioLinks: widget.dtcontainer.getAudioUrl(),
                                  imagePlayButtonKeys:keymap ,
                                  tutorialIndex: 1,
                                ),
                        
                            ),
                          ),
                          SizedBox(height: 50.v),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Align Row's children to the center
                              children: [
                                if (widget.dtcontainer
                                        .getImageUrlList()
                                        .length <=
                                    4)
                                  ...List.generate(
                                    widget.dtcontainer.getImageUrlList().length,
                                    (index) {
                                      return Row(
                                        children: [
                                          OptionWidget(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (widget.dtcontainer
                                                        .getCorrectOutput() ==
                                                    widget.dtcontainer
                                                            .getImageUrlList()[
                                                        index]) {
                                                  AnalyticsService().logEvent(
                                                      "level_complete", {
                                                    "name": "Identification",
                                                    "level": "1",
                                                  });
                                                }
                                              },
                                              child: ImageWidget(
                                                imagePath: widget.dtcontainer
                                                    .getImageUrlList()[index],
                                              ),
                                            ),
                                            isCorrect: () {
                                              return widget.dtcontainer
                                                      .getCorrectOutput() ==
                                                  widget.dtcontainer
                                                      .getImageUrlList()[index];
                                            },
                                            optionKey: GlobalKey(),
                                            tutorialOrder: index + 2,
                                          ),
                                          SizedBox(
                                            width:
                                                20, // Space between the widgets
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                              ],
                            ),
                          )
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
}
