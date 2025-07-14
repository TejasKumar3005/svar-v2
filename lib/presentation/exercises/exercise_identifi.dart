import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/network/cacheManager.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/exercises/audioToImage.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/exercises/identification_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:svar_new/database/userController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

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
  bool parent_mode = true;

  ChewieController? _chewieController;

  late UserData userData;

  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;
  bool show_next_button = false;

  // New state variables for next exercise functionality
  bool exerciseCompleted = false;
  bool hasMoreExercises = false;
  int currentExerciseIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _player.dispose();

    _chewieController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Change orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _player = AudioPlayer();
    leveltracker = 0;

    // Initialize userData with uid and context
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    userData = UserData(uid: uid, buildContext: context);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    currentExerciseIndex = obj[3] as int;

    // Check if there are more exercises left for today
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    _checkForMoreExercises(data_pro);

    String type = obj[0] as String;
    print("Type: $type");

    // Play background music based on exercise type
    String audioFile = type == "ImageToAudio"
        ? "v1.wav"
        : type == "MaleFemale"
            ? "v2.wav"
            : type == "DiffHalf"
                ? "v3.wav"
                : type == "AudioToImage"
                    ? "v4.wav"
                    : "v5.wav";

    // Future.delayed(const Duration(seconds: 3), () async {
    //   await _player.play(AssetSource("assets/audio/bgm/$audioFile"));
    // });
  }

  void _checkForMoreExercises(ExerciseProvider data_pro) {
    // Get the current exercise's date
    if (currentExerciseIndex >= data_pro.todaysExercises.length) return;

    Map<String, dynamic> currentExercise =
        data_pro.todaysExercises[currentExerciseIndex];
    String exerciseDate = currentExercise['date'] ?? '';

    if (exerciseDate.isEmpty) return;

    // Filter exercises to only include exercises from the same date as current exercise
    List<Map<String, dynamic>> sameDateExercises = data_pro.todaysExercises
        .where((exercise) => exercise['date'] == exerciseDate)
        .toList();

    // Find the current exercise's position in the same date filtered list
    int currentIndexInSameDateExercises = sameDateExercises.indexWhere(
        (exercise) =>
            data_pro.todaysExercises.indexOf(exercise) == currentExerciseIndex);

    if (currentIndexInSameDateExercises != -1) {
      // Check if any exercises after current one are incomplete (completedAt is null)
      hasMoreExercises = sameDateExercises
          .skip(currentIndexInSameDateExercises + 1)
          .any((exercise) => exercise['completedAt'] == null);
    }

    print("Exercise date: $exerciseDate");
    print("Has more exercises for this date: $hasMoreExercises");
  }

  int sel = 0;

  void _onRiveInit(Artboard artboard) async {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 2');

    if (controller != null) {
      artboard.addController(controller);
      riveController = controller;

      // Print all state machines for debugging
      print("\nAll State Machines in artboard:");
      for (var stateMachine in artboard.stateMachines) {
        print("State Machine: ${stateMachine.name}");
      }
      _correctTrigger = controller.findInput<bool>('correct') as SMITrigger;
      _incorrectTrigger = controller.findInput<bool>('incorrect') as SMITrigger;

      print("Controller added: $controller");
    }
  }

  void _triggerAnimation(bool isCorrect) {
    print("\nTrying to fire ${isCorrect ? 'correct' : 'incorrect'} trigger");

    if (isCorrect) {
      if (!parent_mode) {
        setState(() {
          exerciseCompleted = true;
        });
      }

      // Only auto-navigate if there are no more exercises for today
      if (!hasMoreExercises) {
        if (_correctTrigger != null) {
          print("Firing correct trigger");
          _correctTrigger!.fire();
          print("Correct trigger fired");
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted && !parent_mode && exerciseCompleted) {
              Navigator.pop(context);
            }
          });
        }
      }
    } else {
      if (_incorrectTrigger != null) {
        _incorrectTrigger!.fire();
        print("Incorrect trigger fired");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<IdentificationProvider>();
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;

    String type = obj[0] as String;
    dynamic dtcontainer = obj[1] as dynamic;
    String params = obj[2] as String;

    // Use sample data when parent_mode is true
    if (parent_mode) {
      final random = Random();
      switch (type) {
        case "ImageToAudio":
          dtcontainer =
              sampleImageToAudio[random.nextInt(sampleImageToAudio.length)];
          break;
        case "DiffImageToAudio":
          dtcontainer = sampleDiffImageToAudio[
              random.nextInt(sampleDiffImageToAudio.length)];
          break;

        default:
          // Keep original dtcontainer if no sample available
          break;
      }
    }

    return type != "AudioToImage" && type != "DiffAudioToImage"
        ? (type == "AudioToAudio"
            ? Container()
            : Scaffold(
                extendBody: true,
                extendBodyBehindAppBar: true,
                backgroundColor: appTheme.gray300,
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  // Replace gradient with background image
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/quiz_bg.jpeg'), // Update with your actual image path
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 30.0, bottom: 20),
                    child: Column(
                      children: [
                        DisciAppBar(
                          context,
                          parent_mode: parent_mode,
                          onParentModeChanged: (value) {
                            setState(() {
                              parent_mode = value;
                              exerciseCompleted = false;
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            // Remove decoration to make it transparent over the placeholder
                            child: Text(
                              type == "ImageToAudio" ||
                                      type == "DiffImageToAudio"
                                  ? "Look at the image. Can you tell what sound it makes?"
                                  : type == "MaleFemale"
                                      ? "Listen to the voice carefully. Can you tell which one is male and which one is female?"
                                      : type == "DiffHalf"
                                          ? "Listen closely. Tap the button as soon as the sound changes."
                                          : "You will hear two sounds. Are they the same or different?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily:
                                    "Comic Sans MS", // Child-friendly font
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: Color.fromARGB(255, 132, 140, 74),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              FutureBuilder(
                                future: _buildOptionGRP(
                                  context,
                                  provider,
                                  type,
                                  dtcontainer,
                                  params,
                                ),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? snapshot.data!
                                      : SizedBox();
                                },
                              ),
                              // Rive animation positioned at bottom left
                              Stack(
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: IgnorePointer(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: RiveAnimation.asset(
                                          key: Key(parent_mode.toString()),
                                          'assets/rive/Celebration_animation.riv',
                                          onInit: _onRiveInit,
                                          fit: BoxFit.fitHeight,
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (exerciseCompleted &&
                                      hasMoreExercises &&
                                      !parent_mode)
                                    Positioned(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                      right: 20,
                                      child: AnimatedScale(
                                          scale: 1,
                                          duration: Duration(milliseconds: 500),
                                          child: CustomButton(
                                              width: 150,
                                              child: Text(
                                                "Next",
                                                style: GoogleFonts.inter(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              type: ButtonType.Next,
                                              onPressed: _moveToNextExercise)),
                                    ),
                                ],
                              ),
                              // Tip button
                              // Positioned(
                              //   bottom: 0,
                              //   right: 0,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       // Add tip button functionality
                              //     },
                              //     child: CustomImageView(
                              //       imagePath: ImageConstant.imgTipbtn,
                              //       height: 60.v,
                              //       width: 60.h,
                              //       fit: BoxFit.contain,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        : AudiotoimageScreen(
            dtcontainer: dtcontainer,
            params: type,
          );
  }

  /// Section Widget
  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'On Snap!',
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _moveToNextExercise() {
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);

    // Get the current exercise's date
    if (currentExerciseIndex >= data_pro.todaysExercises.length) return;

    Map<String, dynamic> currentExercise =
        data_pro.todaysExercises[currentExerciseIndex];
    String exerciseDate = currentExercise['date'] ?? '';

    if (exerciseDate.isEmpty) return;

    // Find next incomplete exercise for the same date
    int nextExerciseIndex = -1;
    for (int i = currentExerciseIndex + 1;
        i < data_pro.todaysExercises.length;
        i++) {
      if (data_pro.todaysExercises[i]['date'] == exerciseDate &&
          data_pro.todaysExercises[i]['completedAt'] == null) {
        nextExerciseIndex = i;
        break;
      }
    }

    if (nextExerciseIndex != -1) {
      // Navigate to the next exercise
      Map<String, dynamic> nextExercise =
          data_pro.todaysExercises[nextExerciseIndex];
      String exerciseType = nextExercise["exerciseType"];

      // Pop current screen first
      Navigator.pop(context);

      // Navigate to appropriate exercise type
      navigateToExerciseType(exerciseType, nextExerciseIndex, context);
    } else {
      // No more exercises, just pop
      Navigator.pop(context);
    }
  }

  Future<Widget> _buildOptionGRP(
      BuildContext context,
      IdentificationProvider provider,
      String type,
      dynamic dtcontainer,
      String params) async {
    File? file =
        await CachingManager().getCachedFile(dtcontainer.getImageUrl());

    print("file: ${file?.path}");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.h),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Changed from Row to Column for portrait mode
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  padding: EdgeInsets.all(1.h),
                  child: Stack(
                    children: [
                      if (type == "WordToFig")
                        Center(
                          child: Text(
                            dtcontainer.getImageUrl(),
                            style: TextStyle(fontSize: 90),
                          ),
                        )
                      else
                        CustomImageView(
                          imagePath: file != null
                              ? file.path
                              : dtcontainer.getImageUrl(),
                          radius: BorderRadiusStyle.roundedBorder15,
                        ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.3, // Adjusted height for portrait
                  child:
                      buildDynamicOptions(type, provider, dtcontainer, params),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDynamicOptions(String quizType, IdentificationProvider provider,
      dynamic dtcontainer, String params) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int currentExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[currentExerciseIndex];

    // dtcontainer is already set correctly in build method when parent_mode is true
    // Only override dtcontainer if not in parent_mode
    if (!parent_mode) {
      dtcontainer = obj[1] as dynamic;
    }

    switch (quizType) {
      case "ImageToAudio" || "DiffImageToAudio":
        return (dtcontainer as ImageToAudio).getAudioList().length <= 4
            ? Center(
                key: Key(parent_mode.toString()),
                child: Container(
                    height: MediaQuery.of(context).size.height *
                        0.4, // Adjust height as needed
                    width: MediaQuery.of(context).size.width,
                    // Adjusted for portrait mode
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (dtcontainer.getAudioList().length <= 4)
                          ...List.generate(dtcontainer.getAudioList().length,
                              (index) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.08,
                              margin: EdgeInsets.only(bottom: 4.v),
                              child: OptionWidget(
                                triggerAnimation: (value) {
                                  _triggerAnimation(value);
                                },
                                child: AudioWidget(
                                  audioLinks: [
                                    dtcontainer.getAudioList()[index],
                                  ],
                                ),
                                isCorrect: () {
                                  bool isCorrect =
                                      dtcontainer.getCorrectOutput() ==
                                          dtcontainer.getAudioList()[index];

                                  var data_pro = Provider.of<ExerciseProvider>(
                                      context,
                                      listen: false);

                                  if (isCorrect && !parent_mode) {
                                    data_pro
                                        .incrementLevel(currentExerciseIndex);

                                    UserData(
                                            uid: FirebaseAuth
                                                .instance.currentUser!.uid)
                                        .updateExerciseData(
                                            euid: data["uid"],
                                            date: data["date"],
                                            performance: {
                                          "correct_attempt": isCorrect,
                                          "time": DateTime.now().toString(),
                                        }).then((value) =>
                                            print("Exercise data updated"));
                                  }

                                  return isCorrect;
                                },
                              ),
                            );
                          }),
                      ],
                    )),
              )
            : SizedBox();

      // case "FigToWord":
      //   return StatefulBuilder(
      //     builder: (context, setState) {
      //       return Center(
      //         child: Container(
      //           height: MediaQuery.of(context).size.height * 0.3,
      //           width: MediaQuery.of(context).size.width,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               if (dtcontainer.getTextList().length <= 4)
      //                 ...List.generate(
      //                   dtcontainer.getTextList().length ~/ 2 +
      //                       dtcontainer.getTextList().length %
      //                           2, // Calculate rows needed
      //                   (rowIndex) {
      //                     return Padding(
      //                       padding: EdgeInsets.only(bottom: 2.v),
      //                       child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           // Create 2 items per row (if available)
      //                           ...List.generate(
      //                             2,
      //                             (colIndex) {
      //                               final index = rowIndex * 2 + colIndex;
      //                               if (index <
      //                                   dtcontainer.getTextList().length) {
      //                                 return Expanded(
      //                                   child: Padding(
      //                                     padding: EdgeInsets.symmetric(
      //                                         horizontal: 5.h),
      //                                     child: OptionWidget(
      //                                       triggerAnimation: (value) {
      //                                         _triggerAnimation(value);
      //                                       },
      //                                       child: TextContainer(
      //                                         text: dtcontainer
      //                                             .getTextList()[index],
      //                                       ),
      //                                       isCorrect: () {
      //                                         bool isCorrect = dtcontainer
      //                                                 .getCorrectOutput() ==
      //                                             dtcontainer
      //                                                 .getTextList()[index];

      //                                         var data_pro =
      //                                             Provider.of<ExerciseProvider>(
      //                                                 context,
      //                                                 listen: false);
      //                                         if (isCorrect && !parent_mode) {
      //                                           data_pro.incrementLevel(
      //                                               currentExerciseIndex);

      //                                             UserData(
      //                                                     uid: FirebaseAuth
      //                                                         .instance
      //                                                         .currentUser!
      //                                                         .uid)
      //                                                 .updateExerciseData(
      //                                                     euid: data["uid"],
      //                                                     date: data["date"],
      //                                                     performance: {
      //                                                   "correct_attempt":
      //                                                       isCorrect,
      //                                                   "time": DateTime.now()
      //                                                       .toString(),
      //                                                 }).then((value) => print(
      //                                                     "Exercise data updated"));
      //                                           }

      //                                         return isCorrect;
      //                                       },
      //                                     ),
      //                                   ),
      //                                 );
      //                               } else {
      //                                 return Expanded(child: SizedBox());
      //                               }
      //                             },
      //                           ),
      //                         ],
      //                       ),
      //                     );
      //                   },
      //                 ),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   );

      // case "WordToFig":
      //   debugPrint("entering in the word to fig section");
      //   return Center(
      //   child: Container(
      //       height: MediaQuery.of(context).size.height * 0.4,
      //       width: MediaQuery.of(context).size.width,
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           if (dtcontainer.getImageUrlList().length <= 4)
      //             ...List.generate(
      //               dtcontainer.getImageUrlList().length ~/ 2 +
      //                   dtcontainer.getImageUrlList().length %
      //                       2, // Calculate rows needed
      //               (rowIndex) {
      //                 return Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                   children: [
      //                     // Create 2 items per row (if available)
      //                     ...List.generate(
      //                       2,
      //                       (colIndex) {
      //                         final index = rowIndex * 2 + colIndex;
      //                         if (index <
      //                             dtcontainer.getImageUrlList().length) {
      //                           return Expanded(
      //                             child: Padding(
      //                               padding: EdgeInsets.all(5.h),
      //                               child: OptionWidget(
      //                                 triggerAnimation: (value) {
      //                                   _triggerAnimation(value);
      //                                 },
      //                                 child: ImageWidget(
      //                                   imagePath: dtcontainer
      //                                       .getImageUrlList()[index],
      //                                 ),
      //                                 isCorrect: () {
      //                                   bool isCorrect =
      //                                       dtcontainer.getCorrectOutput() ==
      //                                           dtcontainer
      //                                               .getImageUrlList()[index];

      //                                   var data_pro =
      //                                       Provider.of<ExerciseProvider>(
      //                                           context,
      //                                           listen: false);
      //                                   if (isCorrect && !parent_mode) {
      //                                     data_pro.incrementLevel(
      //                                         currentExerciseIndex);

      //                                       UserData(
      //                                               uid: FirebaseAuth.instance
      //                                                   .currentUser!.uid)
      //                                           .updateExerciseData(
      //                                               euid: data["uid"],
      //                                               date: data["date"],
      //                                               performance: {
      //                                             "correct_attempt":
      //                                                 isCorrect,
      //                                             "time": DateTime.now()
      //                                                 .toString(),
      //                                           }).then((value) => print(
      //                                               "Exercise data updated"));
      //                                     }

      //                                   return isCorrect;
      //                                 },
      //                               ),
      //                             ),
      //                           );
      //                         } else {
      //                           return Expanded(child: SizedBox());
      //                         }
      //                       },
      //                     ),
      //                   ],
      //                 );
      //               },
      //             ),
      //         ],
      //       )),
      // );

      default:
        return Container();
    }
  }
}
