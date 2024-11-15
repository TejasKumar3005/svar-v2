// option_widget.dart

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
  final ContentAlign align; // Add the 'align' parameter

  OptionWidget({
    required this.child,
    required this.isCorrect,
    required this.optionKey,
    required this.tutorialOrder,
    required this.align, 
  }) : super(key: optionKey);

  @override
  OptionWidgetState createState() => OptionWidgetState();
}

class OptionWidgetState extends State<OptionWidget> {
  bool _isGlowing = false;
  OverlayEntry? _overlayEntry;

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
      child: GestureDetector(
        onTap: click,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
