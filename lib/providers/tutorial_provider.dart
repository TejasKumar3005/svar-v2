import 'package:flutter/material.dart';

class TapHandlerProvider extends ChangeNotifier {
  int nextIndex = 0;
  AnimationController? _controllerPulse = AnimationController(
      vsync: this,
      duration: widget.pulseAnimationDuration ?? defaultPulseAnimationDuration,
    );;
  bool initReverse = false;
  
   int increase_index() {
    nextIndex++;
    notifyListeners();
    return nextIndex; 
  }

  Future _revertAnimation() async {
    initReverse = true;
    print( 'controller pulse value ${_controllerPulse}');
    await _controllerPulse!.reverse(from: _controllerPulse!.value);
     notifyListeners();
  }

 Future tapHandler({
    bool targetTap = false,
  }) async {
    print("tapped");
    nextIndex++; 
    print("index value $nextIndex");  
    notifyListeners();
    return _revertAnimation();
  }

}