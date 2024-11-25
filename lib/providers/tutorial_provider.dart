import 'package:flutter/material.dart';

class TapHandlerProvider extends ChangeNotifier {
  int nextIndex = 0;
  late AnimationController _controllerPulse;
  bool initReverse = false;
  /// Increment nextIndex and handle tap logic
  Future<void> tapHandler({
    required BuildContext context,
 
    Future<void> Function()? revertAnimation,
  }) async {
    print("tapped");
    nextIndex++;

   
    if (revertAnimation != null) {
      await revertAnimation();
    }

    notifyListeners(); 
  }

  Future<void> revertAnimation() async {
    initReverse = true;
    notifyListeners(); // Notify UI of changes
    await _controllerPulse.reverse(from: _controllerPulse.value);
  }

  /// Initialize the AnimationController (must be called from the widget)
  void initializeController(AnimationController controller) {
    _controllerPulse = controller;
  }
}
