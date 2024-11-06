import 'package:flutter/material.dart';
import 'package:svar_new/presentation/Identification_screen/celebration_overlay.dart';
import 'package:svar_new/widgets/text_option.dart';
import 'package:svar_new/widgets/image_option.dart';
import 'package:svar_new/widgets/audio_widget.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/widgets/tutorial_coach_mark/lib/tutorial_coach_mark.dart';
import 'dart:core';

class OptionWidget extends StatefulWidget {
  static List<GlobalKey> optionKeys = [];
  final Widget child;
  final bool Function() isCorrect;
  final GlobalKey optionKey;
  final int tutorialOrder;
  final ContentAlign align; // New parameter for alignment

  OptionWidget({
    required this.child,
    required this.isCorrect,
    required this.optionKey,
    required this.tutorialOrder,
    required this.align, // Pass alignment when creating the widget
  }) : super(key: optionKey) {
    optionKeys.add(optionKey);
  }

  @override
  _OptionWidgetState createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  bool _isGlowing = false;
  OverlayEntry? _overlayEntry;
  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    super.initState();

    if (widget.tutorialOrder == 1) {
      Future.delayed(Duration.zero, showTutorial);
      _initTutorial();
    }
  }

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

    for (int i = 0; i < OptionWidget.optionKeys.length; i++) {
      // Use the passed align value from the widget instance
      final align = widget.align;
      print("Align for widget $i: $align");

      targets.add(
        TargetFocus(
          identify: "tutorial_step_${i + 1}",
          keyTarget: OptionWidget.optionKeys[i],
          contents: [
            TargetContent(
              align: align,
              builder: (context, controller) {
                return _buildTutorialContent("",
                    isCorrect: false, child: widget.child);
              },
            ),
          ],
        ),
      );
    }

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
                  child: widget.child,
                );
              },
            ),
          ],
        ),
      );
    }
    return targets;
  }

  Widget _buildTutorialContent(String text,
      {required bool isCorrect, required Widget child}) {
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
          if (isCorrect) // Display text only if it's the correct answer
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

  void showTutorial() {
    tutorialCoachMark.show(context: context);
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
      key: widget.optionKey,
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
    OptionWidget.optionKeys.remove(widget.optionKey);
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
