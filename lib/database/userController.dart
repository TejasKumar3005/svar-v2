

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/providers/userDataProvider.dart';

class UserData {
  final String? uid;
  BuildContext? buildContext;
  UserData({this.uid, this.buildContext});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("patients");
final CollectionReference tipsCollection =
      FirebaseFirestore.instance.collection("Parental Tips");
final CollectionReference therapyCenterCollection =
      FirebaseFirestore.instance.collection("therapy_centers");
  Future saveUserData(UserModel userModel) async {
    UserModel user=userModel;
    user.uid = uid;
    Provider.of<UserDataProvider>(buildContext!, listen: false)
        .setUser(userModel);
    try {
      await userCollection
          .doc(uid)
          .set(user.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future getParentalTip()async {
    try {
    QuerySnapshot querySnapshot = await tipsCollection.get();

      // Create a map of document IDs and their corresponding data
      Map<String, dynamic> tempKeys = {};
      querySnapshot.docs.forEach((doc) {
        tempKeys[doc.id] = doc.data();
      });
      Provider.of<UserDataProvider>(buildContext!, listen: false)
          .setParentalTips(tempKeys);
    }  on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future updateUserInfo(Map<String, dynamic> map) async {
    await userCollection.doc(uid).set(map);
  }

  Future getTherapyCenters()async {
    try {
    QuerySnapshot querySnapshot = await therapyCenterCollection.get();

      // Create a map of document IDs and their corresponding data
      List<dynamic> tempKeys = [];
      querySnapshot.docs.forEach((doc) {
        tempKeys.add(doc.data());
      });
      Provider.of<UserDataProvider>(buildContext!, listen: false)
          .setTherapyCenters(tempKeys);
    }  on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  } 

  Future<bool> addPatientToTherapyCenter(String therapyCenterId, String patientId) async {
    try {
      await therapyCenterCollection.doc(therapyCenterId).update({
        "patients": FieldValue.arrayUnion([patientId])
      });
      return true;
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  
  Future<bool> updateScore(int score) async {
    try {
      await userCollection.doc(uid).update({
        "score": score
      });
      return true;
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  Future<bool> getUserData() async {
    try {
      UserModel userModel;
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      if (documentSnapshot.data() != null) {
        Map<String, dynamic> map =
            documentSnapshot.data()! as Map<String, dynamic>;
            print(map);
        userModel = UserModel.fromJson(map);
        // userModel.gameStats.levels_on = await loadJsonFromAsset().then((value) => value.map((e) => Level.fromJson(e)).toList());
        Provider.of<UserDataProvider>(buildContext!, listen: false)
            .setUser(userModel);
        return true;
      }
      return true;
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }
}
