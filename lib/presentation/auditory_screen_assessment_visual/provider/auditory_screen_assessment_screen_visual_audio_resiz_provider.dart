import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../data/models/levelManagementModel/visual.dart';
import '../models/auditory_screen_assessment_screen_visual_audio_resiz_model.dart';

class AuditoryScreenAssessmentScreenVisualAudioResizProvider
    extends ChangeNotifier {
  AuditoryScreenAssessmentScreenVisualAudioResizModel
      auditoryScreenAssessmentScreenVisualAudioResizModelObj =
      AuditoryScreenAssessmentScreenVisualAudioResizModel();



  Future<Map<String, dynamic>?> fetchDocument(String docname) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String document = docname;
  
    try {
      DocumentSnapshot doc = await firestore
          .collection('Level Management')
          .doc(document)
          .get();

      if (doc.exists) {
        List<Map<String, dynamic>> data = doc.get('data');
        Map<String, dynamic> da = data[0];
        debugPrint('data fetched is  $da ');
        return data[0];
      } else {
        return null;
      }
    } catch (e) {
     return null;
    }
  } 

  int sel = 0;

  void setSelected(int s) {
    sel = s;
    notifyListeners();
  }

  String quizType = "FIG_TO_WORD";

  void setQuizType(String q) {
    quizType = q;
    notifyListeners();
  }

  // there will be three conditions - VOICE , FIG_TO_WORD , WORD_TO_FIG
  dynamic getScreeValue(String type) async{
    if(type == "VOICE"){
      // getting data from database 
      // for now it is custom
      Map<String, dynamic>? json;
      await fetchDocument("ImageToAudio").then((value) =>
      { json = value
      });
      debugPrint('response is $json.toString() 70');
      ImageToAudio image_to_audio = ImageToAudio.fromJson(json!);
      return image_to_audio;
    }
    else if(type == "WORD_TO_FIG"){
     Map<String, dynamic>? json;
     await fetchDocument("WordToFig").then((value) =>
      { json = value
      });
      debugPrint('response is $json.toString() 79');
      WordToFiG word_to_fig = WordToFiG.fromJson(json!);
      return word_to_fig;
    }
    else if(type == "FIG_TO_WORD"){
      Map<String, dynamic>? json;
      await fetchDocument("FigToWord").then((value) =>
      { json = value
      });
      debugPrint('response is $json.toString() 91');
      FigToWord fig_to_word = FigToWord.fromJson(json!);  
      return fig_to_word;
    }
    return null;
  }

  
  @override
  void dispose() {
    super.dispose();
  }


}
