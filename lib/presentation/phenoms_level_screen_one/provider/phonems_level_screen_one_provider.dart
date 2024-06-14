import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';

import '../models/phonems_level_screen_one_model.dart';

/// A provider class for the PhonemsLevelScreenOneScreen.
///
/// This provider manages the state of the PhonemsLevelScreenOneScreen, including the
/// current phonemsLevelScreenOneModelObj
class PhonemsLevelScreenOneProvider extends ChangeNotifier {
  PhonemsLevelScreenOneModel phonemsLevelScreenOneModelObj =
      PhonemsLevelScreenOneModel();

  String? type;
  FigToWord? instance_of_fig_to_word;
  WordToFiG? instance_of_word_to_fig;
  ImageToAudio? instance_of_image_to_audio;
  AudioToImage? instance_of_audio_to_image;

  bool _loading = false;
  ImageToAudio? get imgtoaudio => instance_of_image_to_audio;
  AudioToImage? get audiotoimage => instance_of_audio_to_image;
  FigToWord? get figtoword => instance_of_fig_to_word;
  WordToFiG? get wordtofig => instance_of_word_to_fig;

  bool get loading => _loading;
  String? get ty => type;

  Future<Map<String, dynamic>?> fetchData(int level) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot doc =
        await firestore.collection("levels").doc("Level").get();
    try {
      if (doc.exists) {
        Map<String, dynamic> data = doc.get("data") as Map<String, dynamic>;
        String finder = "Level$level";

        List<dynamic> received_data = data[finder];
        // debugPrint(received_data.toString());
        // taking a random index data which will be showed on the screen
        Map<String, dynamic> levelinfo =
            received_data[0] as Map<String, dynamic>;
        return levelinfo;
      }
    } catch (e) {
      debugPrint("in catach section");
      return null;
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
