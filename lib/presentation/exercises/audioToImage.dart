import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/widgets/Options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/settings_screen/setting.dart';

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

  StateMachineController? riveController;
  SMITrigger? _correctTrigger;
  SMITrigger? _incorrectTrigger;
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
      if (_correctTrigger != null) {
        print("Firing correct trigger");
        _correctTrigger!.fire();
        print("Correct trigger fired");

        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pop(context);
        });
      }
    } else {
      if (_incorrectTrigger != null) {
        _incorrectTrigger!.fire();
        print("Incorrect trigger fired");
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int currentExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[currentExerciseIndex];
    ;
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
              Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
                    child:DisciAppBar(context), // No need for any callbacks now,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 80.v,
                            child: Center(
                              child: GestureDetector(
                                child: OptionWidget(
                                  triggerAnimation: (value) {
                                    _triggerAnimation(value);
                                  },
                                  child: AudioWidget(
                                    audioLinks:
                                        widget.dtcontainer.getAudioUrl(),
                                  ),
                                  isCorrect: () {
                                    return widget.dtcontainer
                                            .getCorrectOutput() ==
                                        widget.dtcontainer.getAudioUrl();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (widget.dtcontainer
                                          .getImageUrlList()
                                          .length <=
                                      4)
                                    ...List.generate(
                                      widget.dtcontainer
                                          .getImageUrlList()
                                          .length,
                                      (index) {
                                        return Row(
                                          children: [
                                            OptionWidget(
                                              triggerAnimation: (value) {
                                                _triggerAnimation(value);
                                              },
                                              child: ImageWidget(
                                                imagePath: widget.dtcontainer
                                                    .getImageUrlList()[index],
                                              ),
                                              isCorrect: () {
                                                if (widget.dtcontainer
                                                        .getCorrectOutput() ==
                                                    widget.dtcontainer
                                                            .getImageUrlList()[
                                                        index]) {
                                                  data_pro.incrementLevel(
                                                      currentExerciseIndex);

                                                  if (data["completedAt"] ==
                                                      null) {
                                                    UserData(
                                                            uid: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                        .updateExerciseData(
                                                          euid: data["uid"],
                                                          date: data["date"],
                                                        )
                                                        .then((value) => print(
                                                            "Exercise data updated"));
                                                  }
                                                }
                                                return widget.dtcontainer
                                                        .getCorrectOutput() ==
                                                    widget.dtcontainer
                                                            .getImageUrlList()[
                                                        index];
                                              },
                                            ),
                                            if (index <
                                                widget.dtcontainer
                                                        .getImageUrlList()
                                                        .length -
                                                    1)
                                              SizedBox(width: 20),
                                          ],
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Positioned(
                    bottom: 0.h,
                    left: 0.h,
                    child: IgnorePointer(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: RiveAnimation.asset(
                          'assets/rive/Celebration_animation.riv',
                          onInit: _onRiveInit,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
