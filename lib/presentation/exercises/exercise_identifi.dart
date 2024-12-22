import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/identification_screen/audioToImage.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/identification_screen/provider/identification_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/database/userController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:svar_new/presentation/phoneme_level_one/level_one.dart';

class ExerciseIdentification extends StatefulWidget {
  const ExerciseIdentification({Key? key})
      : super(
          key: key,
        );

  @override
  AuditoryScreenState createState() => AuditoryScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IdentificationProvider(),
      child: ExerciseIdentification(),
    );
  }
}

class AuditoryScreenState extends State<ExerciseIdentification> {
  late AudioPlayer _player;
  late int leveltracker;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  OverlayEntry? _overlayEntry;
  late UserData userData;

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

    leveltracker = 0;

    // Initialize userData with uid and context
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
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
                          ImageConstant
                              .imgAuditorybg, // Replace with your SVG path
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
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    dynamic dtcontainer = obj[1] as dynamic;
    int level = obj[3] as int;
    switch (quizType) {
      case "ImageToAudio":
        return dtcontainer.getAudioList().length <= 4
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0), // Adjust padding as needed
                child: Container(
                    height: MediaQuery.of(context).size.height *
                        0.5, // Adjust height as needed
                    width: MediaQuery.of(context).size.width * 0.8,
                    // Adjust width as needed
                    child: Column(
                      children: [
                        if (dtcontainer.getAudioList().length <= 4)
                          ...List.generate(dtcontainer.getAudioList().length,
                              (index) {
                            return Expanded(
                              // Each column item will take a proportional amount of available space
                              flex:
                                  1, // You can modify this value to divide space differently
                              child: Column(
                                children: [
                                  Expanded(
                                    // Adjust the flex value based on your layout needs
                                    child: OptionWidget(
                                      child: AudioWidget(
                                        audioLinks: [
                                          dtcontainer.getAudioList()[index],
                                        ],
                                      ),
                                      isCorrect: () {
                                        bool isCorrect = dtcontainer
                                                .getCorrectOutput() ==
                                            dtcontainer.getAudioList()[index];
                                        if (isCorrect) {
                                          var data_pro =
                                              Provider.of<ExerciseProvider>(
                                                  context,
                                                  listen: false);
                                          data_pro.incrementLevel();
                                          UserData(
                                            uid: FirebaseAuth.instance
                                                    .currentUser?.uid ??
                                                '',
                                          )
                                              .updateExerciseData(
                                                  date: obj[5], eid: obj[4])
                                              .then((value) => null);
                                        }
                                        return isCorrect;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          10), // Adds gap between each OptionWidget
                                ],
                              ),
                            );
                          }),
                      ],
                    )),
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
                                          bool isCorrect = dtcontainer
                                                  .getCorrectOutput() ==
                                              dtcontainer.getTextList()[index];
                                          if (isCorrect) {
                                            var data_pro =
                                                Provider.of<ExerciseProvider>(
                                                    context,
                                                    listen: false);
                                            data_pro.incrementLevel();
                                            UserData(
                                              uid: FirebaseAuth.instance
                                                      .currentUser?.uid ??
                                                  '',
                                            )
                                                .updateExerciseData(
                                                    date: obj[5], eid: obj[4])
                                                .then((value) => null);
                                          }
                                          return isCorrect;
                                        },
                                      ),
                                      SizedBox(
                                          width:
                                              10), // Adds gap between each OptionWidget
                                      // Adds gap between each OptionWidget
                                    ],
                                  );
                                })
                            ],
                          ),
                        ),
                      ],
                    ),
                  )

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
                if (dtcontainer.getImageUrlList().length <= 4)
                  ...List.generate(dtcontainer.getImageUrlList().length,
                      (index) {
                    return Expanded(
                      // Each item will take up available space based on the flex value
                      flex:
                          1, // Adjust the flex as needed to control the width ratio
                      child: Row(
                        children: [
                          Expanded(
                            flex:
                                2, // Adjust the flex value for the OptionWidget
                            child: OptionWidget(
                              child: ImageWidget(
                                imagePath: dtcontainer.getImageUrlList()[index],
                              ),
                              isCorrect: () {
                                bool isCorrect =
                                    dtcontainer.getCorrectOutput() ==
                                        dtcontainer.getImageUrlList()[index];
                                if (isCorrect) {
                                  var data_pro = Provider.of<ExerciseProvider>(
                                      context,
                                      listen: false);
                                  data_pro.incrementLevel();
                                  UserData(
                                    uid: FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        '',
                                  )
                                      .updateExerciseData(
                                          date: obj[5], eid: obj[4])
                                      .then((value) => null);
                                }
                                return isCorrect;
                              },
                            ),
                          ),
                          SizedBox(
                              width: 10), // Adds gap between each OptionWidget
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
