import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';

/// A provider class for the PhonemsLevelScreenOneScreen.
///
/// This provider manages the state of the PhonemsLevelScreenOneScreen, including the
/// current phonemsLevelScreenOneModelObj
class PhonemsLevelOneProvider extends ChangeNotifier {
  String? type;
  FigToWord? instance_of_fig_to_word;
  WordToFiG? instance_of_word_to_fig;
  ImageToAudio? instance_of_image_to_audio;
  AudioToImage? instance_of_audio_to_image;
  HalfMuted? instance_of_half_muted;
  DiffHalf? instance_of_diff_half;
  MutedUnmuted? instance_of_muted_unmuted;
  DiffSounds? instance_of_diff_sounds;
  OddOne? instance_of_odd_one;
  int? level;

  bool _loading = false;
  HalfMuted? get halfmuted => instance_of_half_muted;
  DiffHalf? get diffhalf => instance_of_diff_half;
  MutedUnmuted? get mutedunmuted => instance_of_muted_unmuted;
  DiffSounds? get diffsounds => instance_of_diff_sounds;
  OddOne? get oddone => instance_of_odd_one;
  ImageToAudio? get imgtoaudio => instance_of_image_to_audio;
  AudioToImage? get audiotoimage => instance_of_audio_to_image;
  FigToWord? get figtoword => instance_of_fig_to_word;
  WordToFiG? get wordtofig => instance_of_word_to_fig;

  bool get loading => _loading;
  String? get ty => type;

  Future<Map<String, dynamic>?> fetchData(String docName, int level) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference the document inside the 'Auditory' collection
    DocumentSnapshot doc =
        await firestore.collection("Auditory").doc(docName).get();

    // Check if the document exists
    if (!doc.exists) {
      debugPrint(
          "Document $docName does not exist in the Auditory collection.");
      return null;
    }

    try {
      // Proceed only if the document exists
      Map<String, dynamic> data = doc.get("data") as Map<String, dynamic>;
      String finder = "Level$level";

      List<dynamic> receivedData = data[finder];
      // Taking a random index data which will be shown on the screen
      Map<String, dynamic> levelInfo = receivedData[0] as Map<String, dynamic>;
      return levelInfo;
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return null;
    }
  }

  Future<int?> fetchNumberOfLevels(String docName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference the document inside the 'Auditory' collection
    DocumentSnapshot doc =
        await firestore.collection("Auditory").doc(docName).get();

    // Check if the document exists
    if (!doc.exists) {
      debugPrint(
          "Document $docName does not exist in the Auditory collection.");
      return null;
    }

    try {
      // Fetch the 'data' field as a Map
      Map<String, dynamic> data = doc.get("data") as Map<String, dynamic>;

      // Count the number of levels by checking the keys in the 'data' map
      int numberOfLevels =
          data.keys.where((key) => key.startsWith('Level')).length;

      debugPrint("Number of levels in $docName: $numberOfLevels");
      return numberOfLevels;
    } catch (e) {
      debugPrint("Error fetching the number of levels: $e");
      return null;
    }
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
