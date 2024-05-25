import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/auditory_screen_assessment_screen_visual_audio_resiz_model.dart';

/// A provider class for the AuditoryScreenAssessmentScreenVisualAudioResizScreen.
///
/// This provider manages the state of the AuditoryScreenAssessmentScreenVisualAudioResizScreen, including the
/// current auditoryScreenAssessmentScreenVisualAudioResizModelObj

// ignore_for_file: must_be_immutable
class AuditoryScreenAssessmentScreenVisualAudioResizProvider
    extends ChangeNotifier {
  AuditoryScreenAssessmentScreenVisualAudioResizModel
      auditoryScreenAssessmentScreenVisualAudioResizModelObj =
      AuditoryScreenAssessmentScreenVisualAudioResizModel();
  List<String> optionFigures = ["", ""];

  void setOptionFigures(List<String> fig) {
    optionFigures = fig;
    notifyListeners();
  }

  List optStrings1 = ["", ""];
  List optStrings2 = ["", ""];

  int sel = 0;
  void setSelected(int s) {
    sel = s;
    notifyListeners();
  }

  String quizType = "VOICE";

  void setQuizType(String q) {
    quizType = q;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
