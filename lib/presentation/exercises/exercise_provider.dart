import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExerciseProvider extends ChangeNotifier {
  // FIXES APPLIED:
  // 1. Date range consistency: Updated _isDateInRange to match 14-day range from getFortnightExercises
  // 2. Improved exercise completion tracking: Better handling of currentExerciseIndex calculation
  // 3. Simplified incrementLevel method: More robust progression logic
  // 4. Enhanced completion status preservation: Ensures completedAt data is properly maintained

  int currentExerciseIndex = 0;
  SMINumber? currentLevelInput;
  List<Map<String, dynamic>> todaysExercises = [];
  StateMachineController? controller;
  Artboard? artboard;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> setTodaysExercises(List<dynamic> data) async {
    try {
      String? uid = _auth.currentUser?.uid;
      if (uid == null) {
        print("❌ No user logged in");
        return;
      }
      _processExercises(data);
      notifyListeners();
    } catch (e) {
      print("❌ Error setting exercises: $e");
      debugPrint(e.toString());
    }
  }

  void _processExercises(List<dynamic> data) {
    print("\n=== Processing Exercises ===");

    // Filter exercises by date range - Updated to match the 14-day range from getFortnightExercises
    todaysExercises = data
        .where((exercise) {
          final date = exercise['date']?.toString();
          final isInRange = date != null && _isDateInRange(date);
          if (isInRange)
            print(
                "Including exercise: ${exercise['uid'] ?? exercise['eid']} | Date: $date");
          return isInRange;
        })
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    // Sort exercises chronologically
    todaysExercises.sort((a, b) =>
        DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));

    print("Total exercises in range: ${todaysExercises.length}");

    // Find the first incomplete exercise
    int foundIncompleteIndex = todaysExercises
        .indexWhere((exercise) => exercise['completedAt'] == null);

    if (foundIncompleteIndex == -1) {
      // No incomplete exercise found - all exercises are completed
      if (todaysExercises.isNotEmpty) {
        // Set to the last exercise if all are completed
        currentExerciseIndex = todaysExercises.length - 1;
        print(
            "All exercises completed. Set to last exercise index: $currentExerciseIndex");
      } else {
        // No exercises at all
        currentExerciseIndex = 0;
        print("No exercises found. Set index to 0");
      }
    } else {
      currentExerciseIndex = foundIncompleteIndex;
      print("Found first incomplete exercise at index: $currentExerciseIndex");
    }

    print("Current exercise index: $currentExerciseIndex");
    print("============================\n");
  }

  bool _isDateInRange(String dateStr) {
    try {
      final today = DateTime.now();
      final date = DateTime.parse(dateStr);
      final difference = today.difference(date).inDays;
      // Updated to match the 14-day range (7 days back, 7 days forward) from getFortnightExercises
      final isInRange = difference >= -7 && difference <= 7;
      print(
          "Date check: $dateStr, difference: $difference days, in range: $isInRange");
      return isInRange;
    } catch (e) {
      print("❌ Error parsing date '$dateStr': $e");
      return false;
    }
  }

  void incrementLevel(int currentLevel) {
    print("\n=== Increment Level Attempt ===");
    print("Attempting to increment level for exercise at index: $currentLevel");

    // Validate the provided index
    if (currentLevel < 0 || currentLevel >= todaysExercises.length) {
      print(
          "❌ Provided index $currentLevel is out of bounds (total: ${todaysExercises.length})");
      return;
    }

    // Mark the exercise as completed
    todaysExercises[currentLevel]['completedAt'] =
        DateTime.now().toIso8601String();
    print("✅ Marked exercise at index $currentLevel as completed");

    // If this is not the current exercise, just update and return
    if (currentExerciseIndex != currentLevel) {
      print(
          "ℹ️ Completed exercise at index $currentLevel is not the current exercise (current: $currentExerciseIndex)");
      notifyListeners();
      return;
    }

    // Find the next incomplete exercise
    int nextIncompleteIndex = todaysExercises
        .indexWhere((exercise) => exercise['completedAt'] == null);

    if (nextIncompleteIndex == -1) {
      // All exercises are completed
      print("🎉 All exercises completed!");
      currentExerciseIndex = todaysExercises.length - 1; // Set to last exercise
    } else {
      currentExerciseIndex = nextIncompleteIndex;
      print(
          "➡️ Moving to next incomplete exercise at index: $currentExerciseIndex");
    }

    notifyListeners();
    print("============================\n");
  }

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
}

String formatDate(String date) {
  try {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    List<String> parts = date.split('-');
    if (parts.length >= 3) {
      // parts[0] is year, parts[1] is month, parts[2] is day
      int day = int.parse(parts[2]);
      int month = int.parse(parts[1]);
      return '$day ${months[month - 1]}';
    }
    return 'Invalid Date';
  } catch (e) {
    return 'Invalid Date';
  }
}
