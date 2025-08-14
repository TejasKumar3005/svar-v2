import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Oh Snap!',
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(buildContext!)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

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
      showErrorSnackBar(e.toString());
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<void> updateExerciseData({
    required String date,
    required String euid,
    bool isCompleted = true,
    dynamic performance,
  }) async {
    try {
      final userDoc = userCollection.doc(uid);

      // Get the current user document data
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        print('User document with ID $uid not found.');
        return;
      }

      var userData = docSnapshot.data() as Map<String, dynamic>;
      var exercises = userData['exercises'] as Map<String, dynamic>? ?? {};

      if (!exercises.containsKey(date)) {
        print('No exercises found for date $date.');
        return;
      }

      var exercisesForDate = exercises[date] as List<dynamic>;
      var exerciseIndex = exercisesForDate
          .indexWhere((exercise) => exercise is Map && exercise['uid'] == euid);

      if (exerciseIndex == -1) {
        print('Exercise with eid $euid not found for date $date.');
        return;
      }

      Map<String, dynamic> exerciseData =
          Map<String, dynamic>.from(exercisesForDate[exerciseIndex]);
      int views = exerciseData['views'] ?? 0;

      if (exerciseData['subtype'] == "video") {
        exerciseData['views'] = views + 1;
      }

      if (performance != null) {
        if (exerciseData['performance'] != null) {
          exerciseData['performance'].add(performance);
        } else {
          exerciseData['performance'] = [performance];
        }
      }

      if (exerciseData["completedAt"] == null) {
        exerciseData["completedAt"] = DateTime.now().toIso8601String();
        exercisesForDate[exerciseIndex] = exerciseData;
        await userDoc.update({
          'exercises.$date': exercisesForDate,
          'completedTillDate': date,
        });
      } else {
        exerciseData["completedAt"] = DateTime.now().toIso8601String();
        exercisesForDate[exerciseIndex] = exerciseData;
        await userDoc.update({
          'exercises.$date': exercisesForDate,
        });
      }

      print('Exercise data updated successfully!');
    } catch (e) {
      print('Error updating exercise data: $e');
      rethrow; // Rethrow the error to handle it in the calling code
    }
  }

  Future<void> updateStoryComprehensionAttempt({
    required String date,
    required String euid,
    required int questionIndex,
    required int totalQuestions,
    required bool isCorrect,
    String? sessionId,
  }) async {
    try {
      final userDoc = userCollection.doc(uid);

      // Get the current user document data
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        print('User document with ID $uid not found.');
        return;
      }

      var userData = docSnapshot.data() as Map<String, dynamic>;
      var exercises = userData['exercises'] as Map<String, dynamic>? ?? {};

      if (!exercises.containsKey(date)) {
        print('No exercises found for date $date.');
        return;
      }

      var exercisesForDate = exercises[date] as List<dynamic>;
      var exerciseIndex = exercisesForDate
          .indexWhere((exercise) => exercise is Map && exercise['uid'] == euid);

      if (exerciseIndex == -1) {
        print('Exercise with eid $euid not found for date $date.');
        return;
      }

      Map<String, dynamic> exerciseData =
          Map<String, dynamic>.from(exercisesForDate[exerciseIndex]);

      // Initialize performance array if it doesn't exist
      if (exerciseData['performance'] == null) {
        exerciseData['performance'] = [];
      }

      // Create the question attempt data
      Map<String, dynamic> questionAttempt = {
        "question_index": questionIndex,
        "total_questions": totalQuestions,
        "correct_attempt": isCorrect,
        "time": DateTime.now().toString(),
        "session_id":
            sessionId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      };

      // Check if there's an existing session attempt
      List<dynamic> performance =
          List<dynamic>.from(exerciseData['performance']);
      Map<String, dynamic>? existingSessionAttempt;
      int sessionIndex = -1;

      // Find existing session attempt if sessionId is provided
      if (sessionId != null) {
        for (int i = 0; i < performance.length; i++) {
          var attempt = performance[i];
          if (attempt is Map &&
              attempt['session_id'] == sessionId &&
              attempt['type'] == 'story_comprehension_session') {
            existingSessionAttempt = Map<String, dynamic>.from(attempt);
            sessionIndex = i;
            break;
          }
        }
      }

      if (existingSessionAttempt != null) {
        // Add to existing session attempt
        if (existingSessionAttempt['question_attempts'] == null) {
          existingSessionAttempt['question_attempts'] = [];
        }
        existingSessionAttempt['question_attempts'].add(questionAttempt);
        existingSessionAttempt['last_updated'] = DateTime.now().toString();

        // Update the session attempt in performance array
        performance[sessionIndex] = existingSessionAttempt;
      } else {
        // Create new session attempt
        Map<String, dynamic> newSessionAttempt = {
          "type": "story_comprehension_session",
          "session_id":
              sessionId ?? DateTime.now().millisecondsSinceEpoch.toString(),
          "started_at": DateTime.now().toString(),
          "last_updated": DateTime.now().toString(),
          "question_attempts": [questionAttempt],
        };
        performance.add(newSessionAttempt);
      }

      // Update the exercise data
      exerciseData['performance'] = performance;
      exercisesForDate[exerciseIndex] = exerciseData;

      // Update Firestore
      await userDoc.update({
        'exercises.$date': exercisesForDate,
      });

      print('Story comprehension attempt updated successfully!');
      print(
          'Session ID: ${sessionId ?? DateTime.now().millisecondsSinceEpoch.toString()}');
      print('Question Index: $questionIndex, Correct: $isCorrect');
    } catch (e) {
      print('Error updating story comprehension attempt: $e');
      rethrow; // Rethrow the error to handle it in the calling code
    }
  }

  Future<List<dynamic>> getfortnightExercises(
      Map<String, dynamic> exercises) async {
    // FIX: Now preserves all original exercise data including completedAt, views, performance
    // to maintain exercise completion status and user progress tracking
    var finaldata = [];
    try {
      // Calculate dates
      DateTime today = DateTime.now();
      DateTime startDate = today.subtract(Duration(days: 7));
      DateTime endDate = today.add(Duration(days: 7));

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
            // Preserve all original exercise data including completedAt, views, performance, etc.
            Map<String, dynamic> baseExercise =
                Map<String, dynamic>.from(exercise);

            if (exercise["subtype"].toString() == "custom") {
              updatedData.add({
                ...baseExercise, // Preserve original data
                "subtype": "video",
                "description": exercise["description"],
                "type": "video",
                "video": exercise["content_url"],
                "exerciseType": "Level",
                "date": formattedDate
              });
            } else if (exercise["subtype"].toString() != "Pronunciation") {
              updatedData.add({
                ...baseExercise, // Preserve original data
                "exerciseType": exercise["subtype"],
                "date": formattedDate
              });
            } else if (exercise["type"].toString() == "HalfMuted") {
              // do nothing..remove this exercise from the list
            } else if (exercise["type"].toString() == "DiffHalf") {
              updatedData.add({
                ...baseExercise, // Preserve original data
                "date": formattedDate,
                "exerciseType": "DiffHalf",
              });
            } else {
              updatedData.add({
                ...baseExercise, // Preserve original data
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

      data_pro.setTodaysExercises(finaldata);

      return finaldata;
    } catch (e) {
      showErrorSnackBar(e.toString());
      var data_pro =
          Provider.of<ExerciseProvider>(buildContext!, listen: false);

      data_pro.setTodaysExercises(finaldata);
      return finaldata;
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
      showErrorSnackBar(e.toString());
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
      showErrorSnackBar(e.toString());
    }
  }

  Future<void> updateUserFields(
      Map<String, dynamic> fieldsToUpdate, Map<String, dynamic> oldData) async {
    try {
      // Only update the specified fields in Firestore
      await userCollection.doc(uid).update(fieldsToUpdate);

      Map<String, dynamic> updatedData = {...oldData};
      fieldsToUpdate.forEach((key, value) {
        updatedData[key] = value;
      });
      UserModel updatedUser = UserModel.fromJson(updatedData);
      Provider.of<UserDataProvider>(buildContext!, listen: false)
          .setUser(updatedUser);
    } on FirebaseException catch (e) {
      showErrorSnackBar(e.toString());
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
      showErrorSnackBar(e.toString());
    }
  }

  Future updateUserInfo(Map<String, dynamic> map) async {
    await userCollection.doc(uid).set(map);
  }

  Future getTherapyCenters() async {}

  Future<bool> addPatientToTherapyCenter(
      String therapyCenterId, String patientId) async {
    try {
      await therapyCenterCollection.doc(therapyCenterId).update({
        "patients": FieldValue.arrayUnion([patientId])
      });
      return true;
    } on FirebaseException catch (e) {
      showErrorSnackBar(e.toString());
      return false;
    }
  }

  Future<bool> updateScore(int score) async {
    try {
      await userCollection.doc(uid).update({"score": score});
      await userCollection.doc(uid).update({"score": score});
      return true;
    } on FirebaseException catch (e) {
      showErrorSnackBar(e.toString());
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
      showErrorSnackBar(e.toString());
      return false;
    }
  }

  Future<int> getCurrentLevel(String auditoryType) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;

      // Get reference to exercises collection
      CollectionReference exercisesRef = FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .collection('exercises');

      // Get the completedTillExercise
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .get();

      String completedTillExercise =
          (userDoc.data() as Map<String, dynamic>)['completedTillExercise'] ??
              '';

      // Calculate date range (7 days before and after)
      DateTime today = DateTime.now();
      DateTime startDate = today.subtract(Duration(days: 7));
      DateTime endDate = today.add(Duration(days: 7));

      // Get all exercises within date range
      QuerySnapshot exerciseDocs = await exercisesRef
          .where(FieldPath.documentId,
              isGreaterThanOrEqualTo: startDate.toString().substring(0, 10))
          .where(FieldPath.documentId,
              isLessThanOrEqualTo: endDate.toString().substring(0, 10))
          .get();

      // Collect all exercise IDs in order
      List<String> allExerciseIds = [];

      for (var doc in exerciseDocs.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Iterate through all numbered fields (levels)
        for (var field in data.keys) {
          if (field.toString().contains(RegExp(r'^[0-9]+$'))) {
            List<dynamic> exercises = data[field] as List<dynamic>;

            for (var exercise in exercises) {
              if (exercise['assignedBy'] != null &&
                  exercise['assignedBy']['type'] == 'Level' &&
                  exercise['assignedBy']['subtype'] == auditoryType) {
                String eid = exercise['assignedBy']['eid'];
                allExerciseIds.add(eid);
              }
            }
          }
        }
      }

      // Sort exercise IDs
      allExerciseIds.sort();

      // Find position of completedTillExercise
      int currentLevel = allExerciseIds.indexOf(completedTillExercise) + 1;

      // If not found, return 0 or handle appropriately
      if (currentLevel <= 0) {
        return 0;
      }

      return currentLevel;
    } catch (e) {
      print('Error getting current level: $e');
      return 0;
    }
  }
}
