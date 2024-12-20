import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/identification_screen/animation_play.dart';
import 'package:svar_new/presentation/identification_screen/celebration_overlay.dart';
import 'package:svar_new/presentation/identification_screen/provider/identification_provider.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/auditoryAppbar.dart';

import 'package:svar_new/core/utils/audioSampleExtractor.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/phoneme_level_one/level_one.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  late UserData userData;
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
    leveltracker = 0;
    
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
   
  }

  // Function to fetch the correct answer from the database

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
      int level = 0;
  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    level = obj[4] as int;
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
                              child: OptionWidget(
                                child: AudioWidget(
                                  audioLinks: widget.dtcontainer.getAudioUrl(),
                                ),
                                isCorrect: () {
                                 if(widget.dtcontainer.getCorrectOutput() == widget.dtcontainer.getAudioUrl()){
                                    userData.incrementLevelCount("Identification", level);
                                 }
                                  return widget.dtcontainer
                                          .getCorrectOutput() ==
                                      widget.dtcontainer.getAudioUrl();
                                },
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
                                            child: ImageWidget(
                                              imagePath: widget.dtcontainer
                                                  .getImageUrlList()[index],
                                            ),
                                            isCorrect: () {
                                              if(widget.dtcontainer.getCorrectOutput() == widget.dtcontainer.getImageUrlList()[index]){
                                                userData.incrementLevelCount("Identification", level);
                                              }
                                              return widget.dtcontainer
                                                      .getCorrectOutput() ==
                                                  widget.dtcontainer
                                                      .getImageUrlList()[index];
                                            },
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
