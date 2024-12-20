import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveProvider  extends ChangeNotifier{

    SMINumber? currentLevelInput;

  void initiliaseSMINumber(SMINumber smiNumber) {
    currentLevelInput = smiNumber;
    notifyListeners();
  }
  void changeCurrentLevel(double levelcount) {
    currentLevelInput!.change(levelcount);
    notifyListeners();
  }
}