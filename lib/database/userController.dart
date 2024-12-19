

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    Map<String, dynamic>? data = doc.get("data") as Map<String, dynamic>?;

    if (data == null) {
      debugPrint("The 'data' field is null or not in the correct format.");
      return null;
    }

    String finder = "Level$level";

    // Check if the key exists and is a list
    if (data.containsKey(finder) && data[finder] is List) {
      List<dynamic> receivedData = data[finder] as List<dynamic>;
  
      // Ensure the list is not empty and contains a map
      if (receivedData.isNotEmpty && receivedData[0] is Map<String, dynamic>) {
        Map<String, dynamic> levelInfo = receivedData[0] as Map<String, dynamic>;
        return levelInfo;
      } else {
        debugPrint("No data found for the level or data is not in the correct format.");
        return null;
      }
    } else {
      debugPrint("The level $finder does not exist or is not in the correct format.");
      return null;
    }
  } catch (e) {
    debugPrint("Error fetching data: $e");
    return null;
  }
}
  Future<void> incrementLevelCount(String auditoryType) async {
  
      try {
        String? uid = FirebaseAuth.instance.currentUser?.uid;
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('patients').doc(uid);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(userRef);
          var provider = Provider.of<UserDataProvider>(buildContext!, listen: false);

          if (snapshot.exists) {
            Map<String,dynamic> levels = (snapshot.data()
                as Map<String, dynamic>?)?['LevelMap'];
                int currentLevelCount = levels[auditoryType];
                
            int newLevelCount = currentLevelCount + 1;
            levels[auditoryType] = newLevelCount;

            transaction
                .update(userRef, {'LevelMap': levels});
                await addActivity("Level $newLevelCount completed",DateTime.now().toString().substring(0,10),DateTime.now().toString().substring(11,16),uid);
                var data = provider.userModel;
                data.levelMap=LevelMap.fromJson(levels);
                provider.setUser(data);
          } else {
            throw Exception('User not found!');
          }
        });

        print('levelCount incremented successfully!');
      } catch (e) {
        print('Error incrementing levelCount: $e');
      }
    
  }
Future<void> addActivity(String activity, String date, String time,String uid) async {
  try {
    // Get the document snapshot
    DocumentSnapshot docSnapshot = await userCollection.doc(uid).get();

    // Check if the 'activities' field exists
    if (docSnapshot.exists && docSnapshot.data() != null && (docSnapshot.data() as Map<String, dynamic>).containsKey('activities')) {
      // If activities field exists, add the new activity to the array
      await userCollection.doc(uid).update({
        "activities": FieldValue.arrayUnion([{
          "activity": activity,
          "date": date,
          "time": time
        }])
      });
    } else {
      // If activities field doesn't exist, create the field and add the activity
      await userCollection.doc(uid).set({
        "activities": [{
          "activity": activity,
          "date": date,
          "time": time
        }]
      }, SetOptions(merge: true)); // Use merge to ensure only the activities field is added
    }
  } on FirebaseException catch (e) {
    ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ));
  }
}


}
