import 'package:flutter/material.dart';
import 'package:svar_new/presentation/identification_screen/celebration_overlay.dart';
import 'package:svar_new/widgets/text_option.dart';
import 'package:svar_new/widgets/image_option.dart';
import 'package:svar_new/widgets/audio_widget.dart';
import 'package:svar_new/widgets/custom_button.dart';

class OptionWidget extends StatefulWidget {
  final Widget child;
  final bool Function() isCorrect;
  final Function(bool) triggerAnimation;

  const OptionWidget({
    required this.child,
    required this.isCorrect,
    required this.triggerAnimation,
    Key? key,
  }) : super(key: key);

  @override
  _OptionWidgetState createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  bool _isGlowing = false;
  OverlayEntry? _overlayEntry;

  void click() {
    bool isCorrectResult = widget.isCorrect();
    widget.triggerAnimation(isCorrectResult); // Trigger animation

    if (isCorrectResult) {
      // _overlayEntry = celebrationOverlay(context, () {
      //   _overlayEntry?.remove();
      // });
      // Overlay.of(context).insert(_overlayEntry!);
    } else {
      setState(() {
        _isGlowing = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isGlowing = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isGlowing
            ? [
                BoxShadow(
                  color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.6),
                  spreadRadius: 8,
                  blurRadius: 5,
                ),
              ]
            : [],
      ),
      child: ClickProvider(child: widget.child, click: click),
    );
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
    return false;
  }
}
