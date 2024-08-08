import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A provider class for the AuditoryScreenAssessmentScreenAudioVisualResizedScreen.
///
/// This provider manages the state of the AuditoryScreenAssessmentScreenAudioVisualResizedScreen, including the
/// current auditoryScreenAssessmentScreenAudioVisualResizedModelObj

// ignore_for_file: must_be_immutable
class AuditoryScreenAssessmentScreenAudioVisualResizedProvider
    extends ChangeNotifier {


  Future<void> incrementLevelCount(String params) async {
    if (params != "completed") {
      try {
        String? uid = FirebaseAuth.instance.currentUser?.uid;
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(uid);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userRef);
          if (snapshot.exists) {
            int currentLevelCount = (snapshot.data()
                as Map<String, dynamic>?)?['phoneme_current_level'];
            int newLevelCount = currentLevelCount + 1;
            transaction
                .update(userRef, {'phoneme_current_level': newLevelCount});
          } else {
            throw Exception('User not found!');
          }
        });

        print('levelCount incremented successfully!');
      } catch (e) {
        print('Error incrementing levelCount: $e');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
