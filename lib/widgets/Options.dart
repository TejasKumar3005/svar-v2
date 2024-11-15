import 'package:flutter/material.dart';
import 'package:svar_new/presentation/identification_screen/celebration_overlay.dart';
import 'package:svar_new/widgets/text_option.dart';
import 'package:svar_new/widgets/image_option.dart';
import 'package:svar_new/widgets/audio_widget.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/widgets/tutorial_coach_mark/lib/tutorial_coach_mark.dart';

class OptionWidget extends StatefulWidget {
  final Widget child;
  final bool Function() isCorrect;
  final GlobalKey<OptionWidgetState> optionKey;
  final int tutorialOrder;
  final bool areAudioTutorialsComplete;

  OptionWidget({
    required this.child,
    required this.isCorrect,
    required this.optionKey,
    required this.tutorialOrder,
    this.areAudioTutorialsComplete = true,
  }) : super(key: optionKey);

  @override
  OptionWidgetState createState() => OptionWidgetState();
}

class OptionWidgetState extends State<OptionWidget> {
  bool _isGlowing = false;
  bool hasShownTutorial = false;
  OverlayEntry? _overlayEntry;
  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    // Initialize tutorial only if this is the first widget in the sequence
    if (widget.tutorialOrder == 1) {
      Future.delayed(Duration.zero);
      _initTutorial();
    }
  }

  void didUpdateWidget(covariant OptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.areAudioTutorialsComplete &&
        !oldWidget.areAudioTutorialsComplete) {
      startTutorialIfAllowed();
    }
  }

  // Setup the tutorial sequence based on the tutorial order of each widget
  void _initTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: const Color.fromARGB(255, 255, 255, 255),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0,
      onFinish: () {
        print("Tutorial finished");
      },
      onSkip: () {
        print("Tutorial skipped");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    // Target for the current option
    targets.add(
      TargetFocus(
        identify: "tutorial_step_${widget.tutorialOrder}",
        keyTarget: widget.optionKey,
        contents: [
          TargetContent(
            align: ContentAlign.ontop,
            builder: (context, controller) {
              return _buildTutorialContent(
                _getTutorialMessage(widget.tutorialOrder),
                isCorrect: false,
              );
            },
          ),
        ],
      ),
    );

    // If this is the correct option, add the correct answer message
    if (widget.isCorrect.call()) {
      targets.add(
        TargetFocus(
          identify: "correct_option",
          keyTarget: widget.optionKey,
          contents: [
            TargetContent(
              align: ContentAlign.ontop,
              builder: (context, controller) {
                return _buildTutorialContent(
                  _getCorrectAnswerMessage(1),
                  isCorrect: true,
                );
              },
            ),
          ],
        ),
      );
    }

    return targets;
  }

  String _getTutorialMessage(int step) {
    switch (step) {
      case 1:
        return "Here are your answer options!";
      case 2:
        return "Click on the option you think is correct";
      case 3:
        return "If wrong, the option will glow red";
      case 4:
        return "If correct, you'll see a celebration!";
      default:
        return "Try to answer the question";
    }
  }

  Widget _buildTutorialContent(String text, {required bool isCorrect}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: RiveAnimation.asset(
              'assets/rive/hand_click.riv',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _getCorrectAnswerMessage(int step) {
    switch (step) {
      case 1:
        return "This is the correct answer!";
      case 2:
        return "Well done!";
      default:
        return "Great job!";
    }
  }

  void startTutorialIfAllowed() {
    if (widget.areAudioTutorialsComplete && !hasShownTutorial) {
      hasShownTutorial = true;
      tutorialCoachMark.show(context: context);
    }
  }

  void click() {
    print("click is called ");
    if (widget.isCorrect.call()) {
      _overlayEntry = celebrationOverlay(context, () {
        _overlayEntry?.remove();
      });
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      setState(() {
        _isGlowing = !_isGlowing;
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isGlowing = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: widget.optionKey, // Assign the unique key here
      duration: Duration(seconds: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isGlowing
            ? [
                BoxShadow(
                  color: Color.fromARGB(255, 255, 0, 0).withOpacity(0.6),
                  spreadRadius: 8,
                  blurRadius: 5,
                ),
              ]
            : [],
      ),
      child: ClickProvider(child: widget.child, click: click),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
    return true; // or false depending on your needs
  }
}
