import 'package:flutter/material.dart';


/// A provider class for the MainInteractionScreen.
///
/// This provider manages the state of the MainInteractionScreen, including the
/// current mainInteractionModelObj

// ignore_for_file: must_be_immutable
class MainInteractionProvider extends ChangeNotifier {
  String? exerciseType;
  int? numberOfLevels;

  void setScreenInfo(String type) {
    exerciseType = type;
    notifyListeners();
  }

  void setNumberOfLevels(int levels) {
    numberOfLevels = levels;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}