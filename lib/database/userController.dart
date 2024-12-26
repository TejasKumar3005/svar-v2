import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'package:svar_new/presentation/phoneme_level_one/provider/rive_provider.dart';

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

  final CollectionReference exercisesCollection =
      FirebaseFirestore.instance.collection("Auditory");

  Future<Map<String, dynamic>> AssignedExercises(
      Map<String, dynamic> exercises) async {
    try {
      var finaldata = exercises;
      for (var key in exercises.keys) {
        List<Map<String, dynamic>> data = exercises[key];

        for (var i = 0; i < data.length; i++) {
          var exercise = data[i];
          DocumentSnapshot docSnapshot = await exercisesCollection
              .doc(exercise["type"])
              .collection(exercise["Phoneme"])
              .doc(exercise['eid'])
              .get();

          if (docSnapshot.exists) {
            Map<String, dynamic> exerciseData =
                docSnapshot.data() as Map<String, dynamic>;
            exercise = {...exercise, ...exerciseData};
            data[i] = exercise;
            finaldata[key] = data;
            // Do something with exerciseData
          } else {
            debugPrint("Document with id ${exercise['eid']} does not exist.");
            data.removeAt(i);
            finaldata[key] = data;
          }
        }
      }
      return finaldata;
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<void> updateExerciseData({
    required String date,
    required String eid,
    bool isCompleted = true,
    Map<String, dynamic>? performance,
  }) async {
    try {
      final userDoc = userCollection.doc(uid);

      // Get the current user document data
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data() as Map<String, dynamic>;
        final exercises = userData['exercises'] as Map<String, dynamic>? ?? {};

        // Check if the date exists
        if (exercises.containsKey(date)) {
          final exercisesForDate = exercises[date] as List<dynamic>;

          // Find the exercise with the matching eid
          final exerciseIndex = exercisesForDate.indexWhere(
              (exercise) => exercise is Map && exercise['eid'] == eid);

          if (exerciseIndex != -1) {
            int views = 0;
            Map<String, dynamic> exerciseData = exercisesForDate[exerciseIndex];
            if (exercisesForDate[exerciseIndex]['views'] != null) {
              views = exercisesForDate[exerciseIndex]['views'];
            }
            if (exercisesForDate[exerciseIndex]['subtype'] == "video") {
              exerciseData['views'] = views + 1;
            }
            if (performance != null) {
              if (exerciseData['performance'] != null) {
                exerciseData['performance'].add(performance);
              } else {
                exerciseData['performance'] = [performance];
              }
            }

            // Update the exercise data

            // Update the Firestore document

            if (exerciseData["completedAt"] == null && isCompleted) {
              exerciseData["completedAt"] = DateTime.now().toString();
              exercisesForDate[exerciseIndex] = exerciseData;
              await userDoc.update({
                'exercises.$date': exercisesForDate,
                'completedTillExercise': eid,
                'completedTillDate': date
              });
            } else {
              if (isCompleted) {
                exerciseData["completedAt"] = DateTime.now().toString();
                exercisesForDate[exerciseIndex] = exerciseData;
              }

              await userDoc.update({
                'exercises.$date': exercisesForDate,
              });
            }

            print('Exercise data updated successfully!');
          } else {
            print('Exercise with eid $eid not found for date $date.');
          }
        } else {
          print('No exercises found for date $date.');
        }
      } else {
        print('User document with ID $uid not found.');
      }
    } catch (e) {
      print('Error updating exercise data: $e');
    }
  }

  Future<List<dynamic>> getfortnightExercises(
      Map<String, dynamic> exercises) async {
    try {
      // Calculate dates
      DateTime today = DateTime.now();
      DateTime startDate = today.subtract(Duration(days: 7));
      DateTime endDate = today.add(Duration(days: 7));

      var finaldata = [];

      // Loop through dates (14 days)
      for (var day = startDate;
          day.isBefore(endDate.add(Duration(days: 1)));
          day = day.add(Duration(days: 1))) {
        print("fetching data for date: $day");
        String formattedDate = DateFormat('yyyy-MM-dd').format(day);

        if (exercises[formattedDate] != null) {
          List<dynamic> data = exercises[formattedDate];
          List<Map<String, dynamic>> updatedData = [];

          await Future.wait(data.map((exercise) async {
            if (!exercise["eid"].toString().startsWith("Word")) {
              DocumentSnapshot docSnapshot = await exercisesCollection
                  .doc(exercise["type"])
                  .collection(exercise["phoneme"])
                  .doc(exercise['eid'])
                  .get();

              if (docSnapshot.exists) {
                Map<String, dynamic> exerciseData =
                    docSnapshot.data() as Map<String, dynamic>;

                updatedData.add({
                  ...exercise,
                  ...exerciseData,
                  "exerciseType": exercise["type"],
                  "date": formattedDate
                });
              } else {
                debugPrint(
                    "Document with id ${exercise['eid']} does not exist.");
              }
            }else{
              updatedData.add({
                  ...exercise,
                  "date": formattedDate,
                  "exerciseType": "Pronunciation",
                });
            }
          }).toList());

          finaldata.addAll(updatedData);
        }
      }

      var data_pro =
          Provider.of<ExerciseProvider>(buildContext!, listen: false);
      var user_pro =
          Provider.of<UserDataProvider>(buildContext!, listen: false);

      data_pro.setTodaysExercises(finaldata);
      for (int i = 0; i < finaldata.length; i++) {
        if (finaldata[i]["eid"] ==
            user_pro.userModel.exercises["completedTillExercise"]) {
          data_pro.setCurrentExerciseIndex(i);
        }
      }
      return finaldata;
    } catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return [];
    }
  }

  Future<Map<String, dynamic>> getExerciseById(
      Map<String, dynamic> exercise) async {
    try {
      DocumentSnapshot docSnapshot = await exercisesCollection
          .doc(exercise["type"])
          .collection(exercise["Phoneme"])
          .doc(exercise['eid'])
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> exerciseData =
            docSnapshot.data() as Map<String, dynamic>;
        return {...exercise, ...exerciseData};
      } else {
        debugPrint("Document with id ${exercise['eid']} does not exist.");

        return {};
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return {};
    } catch (e) {
      return {};
    }
  }

  Future saveUserData(UserModel userModel) async {
    UserModel user = userModel;

    user.uid = uid;
    Provider.of<UserDataProvider>(buildContext!, listen: false)
        .setUser(userModel);
    try {
      await userCollection.doc(uid).set(user.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future getParentalTip() async {
    try {
      QuerySnapshot querySnapshot = await tipsCollection.get();

      // Create a map of document IDs and their corresponding data
      Map<String, dynamic> tempKeys = {};
      querySnapshot.docs.forEach((doc) {
        tempKeys[doc.id] = doc.data();
      });
      Provider.of<UserDataProvider>(buildContext!, listen: false)
          .setParentalTips(tempKeys);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future updateUserInfo(Map<String, dynamic> map) async {
    await userCollection.doc(uid).set(map);
  }

  Future getTherapyCenters() async {
    Future getTherapyCenters() async {
      try {
        QuerySnapshot querySnapshot = await therapyCenterCollection.get();

        // Create a map of document IDs and their corresponding data
        List<dynamic> tempKeys = [];
        querySnapshot.docs.forEach((doc) {
          tempKeys.add(doc.data());
        });
        Provider.of<UserDataProvider>(buildContext!, listen: false)
            .setTherapyCenters(tempKeys);
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<bool> addPatientToTherapyCenter(
      String therapyCenterId, String patientId) async {
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
      await userCollection.doc(uid).update({"score": score});
      await userCollection.doc(uid).update({"score": score});
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
      if (data == null) {
        debugPrint("The 'data' field is null or not in the correct format.");
        return null;
      }

      String finder = "Level$level";

      // Check if the key exists and is a list
      if (data.containsKey(finder) && data[finder] is List) {
        List<dynamic> receivedData = data[finder] as List<dynamic>;

        // Ensure the list is not empty and contains a map
        if (receivedData.isNotEmpty &&
            receivedData[0] is Map<String, dynamic>) {
          Map<String, dynamic> levelInfo =
              receivedData[0] as Map<String, dynamic>;
          return levelInfo;
        } else {
          debugPrint(
              "No data found for the level or data is not in the correct format.");
          return null;
        }
      }
      // Check if the key exists and is a list
    } catch (e) {
      debugPrint("Error fetching data: $e");
      return null;
    }
  }

  Future<void> incrementLevelCount(String auditoryType, int level) async {
    try {
      var provider2 = Provider.of<RiveProvider>(buildContext!, listen: false);
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('patients').doc(uid);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userRef);
        var provider =
            Provider.of<UserDataProvider>(buildContext!, listen: false);

        if (snapshot.exists) {
          Map<String, dynamic> levels =
              (snapshot.data() as Map<String, dynamic>?)?['levelMap'];
          int currentLevelCount = levels[auditoryType];
          print("1");
          if (currentLevelCount <= level) {
            // Add the condition to only increment if currentLevelCount <= level
            int newLevelCount = currentLevelCount + 1;
            levels[auditoryType] = newLevelCount;
            print("2");
            transaction.update(userRef, {'levelMap': levels});
            await addActivity(
              "Level  $newLevelCount completed",
              DateTime.now().toString().substring(0, 10),
              DateTime.now().toString().substring(11, 16),
              uid!,
            );
            print("3");
            var data = provider.userModel;
            print("4");
            data.levelMap = LevelMap.fromJson(levels);
            print("5");
            provider.setUser(data);
            print("6");
            print("newLevelCount: $newLevelCount");
            provider2.changeCurrentLevel(newLevelCount.toDouble());
          } else {
            print(
                'Current level is already higher than or equal to the provided level.');
          }
        } else {
          throw Exception('User not found!');
        }
      });

      print('levelCount incremented successfully!');
    } catch (e) {
      print('Error incrementing levelCount: $e');
    }
  }

  Future<void> addActivity(
      String activity, String date, String time, String uid) async {
    try {
      // Get the document snapshot
      DocumentSnapshot docSnapshot = await userCollection.doc(uid).get();

      Future<void> addActivity(
          String activity, String date, String time, String uid) async {
        try {
          // Get the document snapshot
          DocumentSnapshot docSnapshot = await userCollection.doc(uid).get();

          // Check if the 'activities' field exists
          if (docSnapshot.exists &&
              docSnapshot.data() != null &&
              (docSnapshot.data() as Map<String, dynamic>)
                  .containsKey('activities')) {
            // If activities field exists, add the new activity to the array
            await userCollection.doc(uid).update({
              "activities": FieldValue.arrayUnion([
                {"activity": activity, "date": date, "time": time}
              ])
            });
          } else {
            // If activities field doesn't exist, create the field and add the activity
            await userCollection.doc(uid).set(
                {
                  "activities": [
                    {"activity": activity, "date": date, "time": time}
                  ]
                },
                SetOptions(
                    merge:
                        true)); // Use merge to ensure only the activities field is added
          }
        } on FirebaseException catch (e) {
          ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ));
        }
      }

      // Check if the 'activities' field exists
      if (docSnapshot.exists &&
          docSnapshot.data() != null &&
          (docSnapshot.data() as Map<String, dynamic>)
              .containsKey('activities')) {
        // If activities field exists, add the new activity to the array
        await userCollection.doc(uid).update({
          "activities": FieldValue.arrayUnion([
            {"activity": activity, "date": date, "time": time}
          ])
        });
      } else {
        // If activities field doesn't exist, create the field and add the activity
        await userCollection.doc(uid).set(
            {
              "activities": [
                {"activity": activity, "date": date, "time": time}
              ]
            },
            SetOptions(
                merge:
                    true)); // Use merge to ensure only the activities field is added
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(buildContext!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }
}
