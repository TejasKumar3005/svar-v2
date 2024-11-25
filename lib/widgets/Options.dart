import 'package:flutter/material.dart';
import 'package:svar_new/presentation/Identification_screen/celebration_overlay.dart';

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
    required this.align, 
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
