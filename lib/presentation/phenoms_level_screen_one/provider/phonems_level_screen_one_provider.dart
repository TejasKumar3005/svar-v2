import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int? level;

  bool _loading = false;
  ImageToAudio? get imgtoaudio => instance_of_image_to_audio;
  AudioToImage? get audiotoimage => instance_of_audio_to_image;
  FigToWord? get figtoword => instance_of_fig_to_word;
  WordToFiG? get wordtofig => instance_of_word_to_fig;

  bool get loading => _loading;
  String? get ty => type;

  Future<Map<String, dynamic>?> fetchData(int val, int level) async {
    String dbname = val == 1 ? "levels" : "Auditory";
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot doc =
        await firestore.collection(dbname).doc("Level").get();
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

  Future<double?> fetchCurrenLevelOfUser(String userId, String origin) async {
    try {
      String dbVariableName = origin == "Quizes"
          ? "phoneme_current_level"
          : "auditory_current_level";
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey(dbVariableName)) {
          int phonemeCurrentLevel = data[dbVariableName];
          level = phonemeCurrentLevel;
          return Future.value(phonemeCurrentLevel.toDouble());
        } else {
          print(
              'Field "phoneme_current_level" does not exist in the document.');
        }
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
    return null;
  }

  Future<void> incrementLevelCount(String origin) async {
    try {
      String dbname = origin == "Quizes"
          ? "phoneme_current_level"
          : "auditory_current_level";
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);
        if (snapshot.exists) {
          int currentLevelCount =
              (snapshot.data() as Map<String, dynamic>?)?[dbname];
          int newLevelCount = currentLevelCount + 1;
          transaction.update(userRef, {dbname: newLevelCount});
        } else {
          throw Exception('User not found!');
        }
      });

      print('levelCount incremented successfully!');
    } catch (e) {
      print('Error incrementing levelCount: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
