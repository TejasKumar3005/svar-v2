import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rive/rive.dart';

extension _TextExtension on Artboard {
  TextValueRun? textRun(String name) => component<TextValueRun>(name);
}

class ExerciseProvider extends ChangeNotifier {
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

    // Sort exercises chronologically
    todaysExercises.sort((a, b) =>
        DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));


    print("Total exercises in range: ${todaysExercises}");
    print("currentExerciseIndex: $currentExerciseIndex");
    currentExerciseIndex = todaysExercises
        .indexWhere((exercise) => exercise['completedAt'] == null);

    if (currentExerciseIndex == -1) {
      // No incomplete exercise found
      if (todaysExercises.isNotEmpty) {
        currentExerciseIndex =
            todaysExercises.length - 1; // Set to the index of the last exercise
      } else {
        currentExerciseIndex =
            -1; // Or handle the case when there are no exercises at all, if needed
        // For example, you might set it to null or 0 depending on your use case
      }
    }
    print("Found first incomplete exercise at index: $currentExerciseIndex");

    print("Total exercises in range: ${todaysExercises.length}");
    print("Current index: $currentExerciseIndex");
  }

  bool _isDateInRange(String dateStr) {
    try {
      final today = DateTime.now();
      final date = DateTime.parse(dateStr);
      final difference = today.difference(date).inDays;
      final isInRange = difference >= -6 && difference <= 6;
      print(
          "Date check: $dateStr, difference: $difference days, in range: $isInRange");
      return isInRange;
    } catch (e) {
      print("❌ Error parsing date '$dateStr': $e");
      return false;
    }
  }

  bool _validateExerciseIndex() {
    if (currentExerciseIndex >= todaysExercises.length) {

      print("❌ Current index out of bounds");
      
      return false;
    }
    return true;
  }

  void incrementLevel(int currentLevel) {
    print("\n=== Increment Level Attempt ===");
    if (!_validateExerciseIndex()) return;

    // Check if current exercise is already completed
    if (currentExerciseIndex > currentLevel) {
      print("❌ Exercise already completed");
      return;
    }

    if (currentExerciseIndex + 1 >= todaysExercises.length) {
      print("❌ No more exercises available");
      return;
    }
    _handleExerciseProgression();
    print("============================\n");
  }

  void _handleExerciseProgression() {
    int startExerciseIndex = (currentExerciseIndex ~/ 5) * 5;
    int endExerciseIndex = startExerciseIndex + 4;
    endExerciseIndex = endExerciseIndex >= todaysExercises.length
        ? todaysExercises.length - 1
        : endExerciseIndex;

    if (currentExerciseIndex == endExerciseIndex) {
      _completeExerciseSet();
      return;
    }

    _progressToNextExercise();
  }

  void _completeExerciseSet() {
    print("this is the end of the set");
    currentExerciseIndex++;
    print("hello2");
    currentLevelInput!.change(6);

    int exerciseCount = todaysExercises.length;
    print("Total exercises to do : ${todaysExercises.length}");
    int startExerciseIndex =
        (currentExerciseIndex ~/ 5) * 5; // Calculate starting index
    int endExerciseIndex = startExerciseIndex + 4;
    print("startExerciseIndex: $startExerciseIndex");
    print("endExerciseIndex: $endExerciseIndex");
    if (endExerciseIndex > exerciseCount) {
      endExerciseIndex = exerciseCount - 1;
    }
    controller =
        StateMachineController.fromArtboard(artboard!, 'State Machine 1');

    if (controller != null) {
      artboard!.addController(controller!);
      artboard!.forEachComponent((component) {
        if (component is TextValueRun) {
          print(
              "Component: ${component.runtimeType} - Name: ${component.name}");
        }
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (int i = 0; i < 5; i++) {
          int actualIndex = startExerciseIndex + i;
          print("actualIndex: $actualIndex");
          // Stop if we've processed all available exercises
          if (actualIndex >= exerciseCount) {
            break;
          }
          String subtypeKey = "level${i + 1}";
          TextValueRun? textRun_subtype = artboard!.textRun(subtypeKey);
          if (textRun_subtype != null) {
            print(
                "type ${actualIndex}: ${todaysExercises[actualIndex]['type']}");
            textRun_subtype.text = todaysExercises[actualIndex]['type'];
          } else {
            debugPrint("Error: '$subtypeKey' text run not found!");
          }

          String descKey = "desc${i + 1}";
          TextValueRun? textRun_desc = artboard!.textRun(descKey);
          if (textRun_desc != null) {
            textRun_desc.text =
                todaysExercises[actualIndex]['description'] == null
                    ? 'No Description'
                    : todaysExercises[actualIndex]['description'];
          } else {
            debugPrint("Error: '$descKey' text run not found!");
          }

          String typeKey = "type${i + 1}";
          TextValueRun? textRun_type = artboard!.textRun(typeKey);
          if (textRun_type != null) {
            String dateStr = todaysExercises[actualIndex]['date'] ?? 'No Date';
            if (dateStr != 'No Date') {
              dateStr = formatDate(dateStr);
            }
            textRun_type.text = dateStr;
          } else {
            debugPrint("Error: '$typeKey' text run not found!");
          }
        }
      });
      print("hello1");
      if (currentLevelInput != null) {
        print("hello3");
        Future.delayed(const Duration(seconds: 8), () {
          print("hello4");
          currentLevelInput!.change(1);
        });
      }
      notifyListeners();
    }
  }

  void _progressToNextExercise() {
    currentExerciseIndex++;
    if (currentLevelInput != null) {
      currentLevelInput!.change((currentExerciseIndex % 5) + 1);
    }
    notifyListeners();
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
