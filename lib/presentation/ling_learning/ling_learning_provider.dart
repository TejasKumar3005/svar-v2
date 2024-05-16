import 'package:flutter/material.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_model.dart';
import '../../../core/app_export.dart';


class LingLearningProvider extends ChangeNotifier {
  String _selectedCharacter = '';

  String get selectedCharacter => _selectedCharacter;

  void setSelectedCharacter(String character) {
    _selectedCharacter = character;
    notifyListeners(); // Notify listeners to update the UI.
  }

  @override
  void dispose() {
    super.dispose();
  }
}
