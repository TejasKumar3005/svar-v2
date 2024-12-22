import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ExerciseProvider extends ChangeNotifier {
  int currentExerciseIndex = 0;
  SMINumber? currentLevelInput;
  List<dynamic> todaysExercises = [];
  void setTodaysExercises(List<dynamic> data) {
    todaysExercises = data;
    notifyListeners();
  }

  void initiliaseSMINumber(SMINumber smi) {
    currentLevelInput = smi;
    notifyListeners();
  }

  void changeCurrentLevel(double level) {
    if (currentLevelInput != null) {
      currentLevelInput!.change(level);
    }
    notifyListeners();
  }

  void setCurrentExerciseIndex(int idx) {
    currentExerciseIndex = idx;
    notifyListeners();
  }

  void incrementLevel() {
    if (currentExerciseIndex == todaysExercises.length - 1) {
      return;
    }
    currentExerciseIndex++;
    currentLevelInput!.change(currentExerciseIndex.toDouble() + 1);

    notifyListeners();
  }
}
