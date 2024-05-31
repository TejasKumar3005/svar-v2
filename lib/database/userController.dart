import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/game_statsModel.dart';
import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/providers/userDataProvider.dart';

class UserData {
  final String? uid;
  BuildContext buildContext;
  UserData({this.uid, required this.buildContext});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future saveUserData(UserModel userModel) async {
    Provider.of<UserDataProvider>(buildContext, listen: false)
        .setUser(userModel);
    try {
      await userCollection
          .doc(uid)
          .set(userModel.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future updateUserInfo(Map<String, dynamic> map) async {
    await userCollection.doc(uid).set(map);
  }

  Future<bool> getUserData() async {
    try {
      UserModel userModel = UserModel(
          p_name: "",
          name: "",
          password: "",
          email: "",
          uid: "",
          imageUrl: "",
          age: "",
          timeStamp: "",
          access_token: "",
          gift_purchase_history: [],
          gameStats: GameStatsModel(
              gifts: [],
              progressScore: 0.0,
              badges_earned: [],
              levels_on: [],
              exercises: [],
              current_level: 0));
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      Map<String, dynamic> map = {};
      if (documentSnapshot.data() != null) {
        Map<String, dynamic> map =
            documentSnapshot.data()! as Map<String, dynamic>;
        userModel = userModel.fromJson(map);
        // userModel.gameStats.levels_on = await loadJsonFromAsset().then((value) => value.map((e) => Level.fromJson(e)).toList());
        Provider.of<UserDataProvider>(buildContext, listen: false)
            .setUser(userModel);
        return true;
      }
      return true;
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }
}
