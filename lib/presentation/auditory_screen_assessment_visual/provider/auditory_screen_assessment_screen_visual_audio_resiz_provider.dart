import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../data/models/levelManagementModel/visual.dart';
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
  List<String> optStrings1 = ["Hello", "Rahul"];
  List<String> optStrings2 = ["Hello", "Anurag"];
  List<String> optionFigures = ["", ""];


  int sel = 0;
  void setSelected(int s) {
    sel = s;
    notifyListeners();
  }
  String quizType = "WORD_TO_FIG";
  void setQuizType(String q) {
    quizType = q;
    notifyListeners();
  }
  // there will be three conditions - VOICE , FIG_TO_WORD , WORD_TO_FIG
  dynamic getScreeValue(String type){
    if(type == "VOICE"){
      // getting data from database 
      // for now it is custom
      Map<String, dynamic> json = {
        "image_url": "https://example.com/image.png",
        "audio_url_list": [
          "https://example.com/audio1.mp3",
          "https://example.com/audio2.mp3",
          "https://example.com/audio3.mp3"
        ],
        "correct_audio_url": "https://example.com/audio1.mp3"
      };
      ImageToAudio image_to_audio = ImageToAudio.fromJson(json);
      notifyListeners();
      return image_to_audio;
    }
    else if(type == "WORD_TO_FIG"){
      Map<String, dynamic> json = {
        "image_url": "https://example.com/image.png",
        "audio_url_list": [
          "https://example.com/audio1.mp3",
          "https://example.com/audio2.mp3",
          "https://example.com/audio3.mp3"
        ],
        "correct_audio_url": "https://example.com/audio1.mp3"
      };
      WordToFiG word_to_fig = WordToFiG.fromJson(json);
      notifyListeners();
      return word_to_fig;
    }
    else if(type == "FIG_TO_WORD"){
        Map<String, dynamic> json = {
        "image_url": "https://example.com/image.png",
        "audio_url_list": [
          "https://example.com/audio1.mp3",
          "https://example.com/audio2.mp3",
          "https://example.com/audio3.mp3"
        ],
        "correct_audio_url": "https://example.com/audio1.mp3"
      };
      FigToWord fig_to_word = FigToWord.fromJson(json);
      notifyListeners();
      return fig_to_word;
    }else{
      return null;
    }
  }
  @override
  void dispose() {
    super.dispose();
  }


}
