import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseProvider extends ChangeNotifier {
  // Properties
  int currentExerciseIndex = 0;
  SMINumber? currentLevelInput;
  List<Map<String, dynamic>> todaysExercises = [];
  String completedTillExercise = '';

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Exercise Management Functions
  Future<void> setTodaysExercises(List<dynamic> data) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        print("❌ No user logged in");
        return;
      }

      // Fetch user's completed exercise status
      await _fetchCompletedExercise(uid);

      // Process and filter exercises
      _processExercises(data);

      notifyListeners();
    } catch (e) {
      print("❌ Error setting exercises: $e");
      debugPrint(e.toString());
    }
  }

  Future<void> _fetchCompletedExercise(String uid) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('patients').doc(uid).get();

    completedTillExercise =
        (userDoc.data() as Map<String, dynamic>)['completedTillExercise'] ?? '';
    print("📍 Last completed exercise: $completedTillExercise");
  }

  void _processExercises(List<dynamic> data) {
    print("\n=== Processing Exercises ===");

    // Filter exercises by date range
    todaysExercises = data
        .where((exercise) {
          final date = exercise['date']?.toString();
          final isInRange = date != null && _isDateInRange(date);
          if (isInRange)
            print("Including exercise: ${exercise['eid']} | Date: $date");
          return isInRange;
        })
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    // Sort exercises by date
    todaysExercises.sort((a, b) => a['date'].compareTo(b['date']));

    _updateCurrentExerciseIndex();

    print("Total exercises in range: ${todaysExercises.length}");
    print("Current index: $currentExerciseIndex");
  }

  void _updateCurrentExerciseIndex() {
    if (completedTillExercise.isEmpty) return;

    for (int i = 0; i < todaysExercises.length; i++) {
      if (todaysExercises[i]['eid'] == completedTillExercise) {
        currentExerciseIndex = i;
        print("✅ Current exercise index: $i");
        break;
      }
    }
  }

  // Level Management Functions
  void incrementLevel() {
    print("\n=== Increment Level Attempt ===");
    if (!_validateExerciseIndex()) return;

    String currentExerciseId = todaysExercises[currentExerciseIndex]['eid'];
    if (currentExerciseId != completedTillExercise) {
      print("❌ Exercise mismatch - cannot progress");
      return;
    }

    _handleExerciseProgression();
    print("============================\n");
  }

  bool _validateExerciseIndex() {
    if (currentExerciseIndex >= todaysExercises.length) {
      print("❌ Current index out of bounds");
      return false;
    }
    return true;
  }

  void _handleExerciseProgression() {
    int startExerciseIndex = (currentExerciseIndex ~/ 5) * 5;
    int endExerciseIndex = startExerciseIndex + 4;

    // Update completed exercise
    if (currentExerciseIndex + 1 < todaysExercises.length) {
      String nextExerciseId = todaysExercises[currentExerciseIndex + 1]['eid'];
      completedTillExercise = nextExerciseId;
      updateCompletedExercise(completedTillExercise);
    }

    // Handle set completion
    if (currentExerciseIndex == endExerciseIndex) {
      _completeExerciseSet();
      return;
    }

    // Normal progression
    _progressToNextExercise();
  }

  void _completeExerciseSet() {
    print("this is the end of the set");
    currentExerciseIndex++;
    print("currentExerciseIndex: $currentExerciseIndex");
    if (currentLevelInput != null) {
      currentLevelInput!.change(6);
      Future.delayed(const Duration(seconds: 4), () {
        currentLevelInput!.change(1);
      });
    }
    notifyListeners();
  }

  void _progressToNextExercise() {
    currentExerciseIndex++;
    if (currentLevelInput != null) {
      currentLevelInput!.change(currentExerciseIndex.toDouble() + 1);
    }
    notifyListeners();
  }

  // Firebase Operations
  Future<void> updateCompletedExercise(String newCompletedId) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) return;

      await _firestore
          .collection('patients')
          .doc(uid)
          .update({'completedTillExercise': newCompletedId});

      print("✅ Updated completedTillExercise: $newCompletedId");
    } catch (e) {
      print("❌ Error updating completedTillExercise: $e");
    }
  }

  // Utility Functions
  bool _isDateInRange(String dateStr) {
    try {
      final today = DateTime.now();
      final date = DateTime.parse(dateStr);
      final difference = today.difference(date).inDays;
      return difference >= -3 && difference <= 3;
    } catch (e) {
      print("❌ Error parsing date '$dateStr': $e");
      return false;
    }
  }

  // Animation Control Functions
  void initializeSMINumber(SMINumber smi) {
    currentLevelInput = smi;
    notifyListeners();
  }

  void changeCurrentLevel(double level) {
    if (currentLevelInput != null) {
      currentLevelInput!.change(level);
    }
    notifyListeners();
  }

  // Index Management Functions
  void setCurrentExerciseIndex(int idx) {
    int maxIndex = getCurrentMaxIndex();
    if (idx <= maxIndex && idx >= 0) {
      currentExerciseIndex = idx;
      notifyListeners();
    }
  }

  int getCurrentMaxIndex() {
    if (completedTillExercise.isEmpty) return 0;

    for (int i = 0; i < todaysExercises.length; i++) {
      if (todaysExercises[i]['eid'] == completedTillExercise) {
        return i;
      }
    }
    return 0;
  }
}
