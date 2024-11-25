import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/widgets/Options.dart';
import 'dart:async';
import 'package:svar_new/widgets/tutorial_coach_mark/lib/tutorial_coach_mark.dart';
import 'package:rive/rive.dart' as rive;

// Global variables to manage tutorial state across instances
AudioPlayer globalAudioPlayer = AudioPlayer();
bool isTutorialInProgress = false;

class AudioWidget extends StatefulWidget {
  final List<String> audioLinks;
  final Map<String, GlobalKey> imagePlayButtonKeys;
  final int tutorialIndex;
  final bool showTutorial;
  final VoidCallback? onTutorialComplete;

  const AudioWidget({
    Key? key,
    required this.audioLinks,
    required this.imagePlayButtonKeys,
    required this.tutorialIndex,
    this.showTutorial = false,
    this.onTutorialComplete,
  }) : super(key: key);

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  StreamSubscription<Duration>? _positionSubscription;
  late AudioPlayer _audioPlayer;
  late double progress;
  bool hasShownTutorial = false;

  late int currentIndex;
  late double completed;
  late List<double> lengths;
  late double totalLength;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _audioPlayer = AudioPlayer();
    progress = 0.0;
    completed = 0.0;
    totalLength = 0.0;
    lengths = [];

    loadAudioLengths();
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (_audioPlayer.duration != null &&
          _audioPlayer.duration!.inSeconds > 0) {
        setState(() {
          progress = (completed + position.inSeconds.toDouble()) / totalLength;
        });
      }
    });

    showTutorial();
  }

  Future<void> loadAudioLengths() async {
    for (int i = 0; i < widget.audioLinks.length; i++) {
      double length = await getAudioLength(widget.audioLinks[i]);
      lengths.add(length);
      totalLength += length;
    }
  }

  Future<double> getAudioLength(String link) async {
    var duration = await _audioPlayer.setUrl(link);
    if (duration != null) {
      await _audioPlayer.load();
      return duration.inSeconds.toDouble();
    }
    return 5.0;
  }

  Future<void> playNext() async {
    if (globalAudioPlayer.playing) {
      await globalAudioPlayer.stop();
    }

    globalAudioPlayer = _audioPlayer;

    if (currentIndex < widget.audioLinks.length) {
      await _audioPlayer.setUrl(widget.audioLinks[currentIndex]);
      await _audioPlayer.play();
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (currentIndex < widget.audioLinks.length - 1) {
            setState(() {
              completed += lengths[currentIndex];
              currentIndex++;
            });
            playNext();
          } else {
            setState(() {
              currentIndex = 0;
              progress = 0.0;
              _audioPlayer.stop();
            });
          }
        }
      });
    }
  }

  void showTutorial() {
    if (hasShownTutorial || isTutorialInProgress) return;

    isTutorialInProgress = true;
    List<TargetFocus> targets = [];

    for (int i = 0; i < widget.audioLinks.length; i++) {
      String keyIndex = "option_$i";
      targets.add(TargetFocus(
        identify: "image_play_button_$i",
        keyTarget: widget.imagePlayButtonKeys[keyIndex],
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.ontop,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: rive.RiveAnimation.asset(
                      'assets/rive/hand_click.riv',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
    }

    TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      alignSkip: Alignment.bottomRight,
      paddingFocus: 10,
      opacityShadow: 0,
      onFinish: () {
        setState(() {
          hasShownTutorial = true;
          isTutorialInProgress = false;
        });
        widget.onTutorialComplete?.call(); // Trigger the callback here
      },
      onSkip: () {
        setState(() {
          hasShownTutorial = true;
          isTutorialInProgress = false;
        });
        widget.onTutorialComplete?.call();
        return true;
      },
    ).show(context: context);
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;
    final screenWidth = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFF47C37),
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomButton(
            key: widget.imagePlayButtonKeys["option_${widget.tutorialIndex - 1}"],
            type: ButtonType.ImagePlay,
            onPressed: () {
              if (_audioPlayer.playing) {
                _audioPlayer.pause();
              } else {
                playNext();
              }
            },
          ),
          const SizedBox(width: 5.0),
          Container(
            height: 50,
            width: 5,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (click != null) {
                  click();
                }
              },
              child: CustomButton(
                type: ButtonType.Spectrum,
                onPressed: () {
                  if (click != null) {
                    click();
                  }
                },
                progress: progress,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
