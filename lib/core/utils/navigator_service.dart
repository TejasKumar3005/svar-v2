import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'transition.dart';
import 'dart:async';

class NavigatorService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

static Future<dynamic> pushNamed(String routeName, {dynamic arguments, String? riveFileName}) async {
    debugPrint('Pushing route: $routeName');
    return navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static Future<void> goBack() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return navigatorKey.currentState?.pop();
  }

  static Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {bool routePredicate = false, dynamic arguments}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => routePredicate,
        arguments: arguments);
  }

  static Future<dynamic> popAndPushNamed(String routeName,
      {dynamic arguments}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return navigatorKey.currentState
        ?.popAndPushNamed(routeName, arguments: arguments);
  }
}


  void navigateToExerciseType(String exerciseType, int exerciseIndex,BuildContext context) {
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    Map<String, dynamic> data = data_pro.todaysExercises[exerciseIndex];

    switch (exerciseType) {
      case "Detection":
        _handleDetection(exerciseIndex, data);
        break;
      case "Discrimination":
        _handleDiscrimination(exerciseIndex, data);
        break;
      case "Identification":
        _handleIdentificationNext(exerciseIndex, data);
        break;
      case "Level":
        _handleLevel(exerciseIndex, data);
        break;
      case 'Pronunciation':
        _handlePronunciation(exerciseIndex, data);
        break;
      case "Vocabulary":
        _handleVocabulary(exerciseIndex, data);
        break;
      default:
        print("Unknown exercise type: $exerciseType");
    }
  }

  // Helper methods for navigation
  void _handleDetection(int exerciseIndex, Map<String, dynamic> data) {
    String? type = data["type"];
    List<dynamic> argumentsList = [
      type,
      retrieveObject(type!, data),
      "notcompleted",
      exerciseIndex,
      data["uid"],
      data["date"]
    ];
    NavigatorService.pushNamed(AppRoutes.exerciseDetection,
        arguments: argumentsList);
  }

  void _handleDiscrimination(int exerciseIndex, Map<String, dynamic> data) {
    String? type = data["type"];
    List<dynamic> argumentsList = [
      type,
        retrieveObject(type!, data),
      "notcompleted",
      exerciseIndex,
      data["uid"],
      data["date"]
    ];
    NavigatorService.pushNamed(AppRoutes.exerciseDiscrimination,
        arguments: argumentsList);
  }

  void _handleIdentificationNext(int exerciseIndex, Map<String, dynamic> data) {
    String? type = data["type"];
    List<dynamic> argumentsList = [
      type,
        retrieveObject(type!, data),
      "notcompleted",
      exerciseIndex,
      data["uid"],
      data["date"],
      data
    ];
    NavigatorService.pushNamed(AppRoutes.exerciseIdentification,
        arguments: argumentsList);
  }

  void _handleLevel(int exerciseIndex, Map<String, dynamic> data) {
    String? type = data["type"];
    List<dynamic> argumentsList = [
      type,
        retrieveObject(type!, data),
      "notcompleted",
      exerciseIndex,
      data["uid"],
      data["date"]
    ];
    NavigatorService.pushNamed(AppRoutes.exerciseIdentification,
        arguments: argumentsList);
  }

  void _handlePronunciation(int exerciseIndex, Map<String, dynamic> data) {
    List<dynamic> argumentsList = [
      data["type"],
      "NULL",
      "notcompleted",
      exerciseIndex,
      data["uid"],
      data["date"],
      data,
    ];
    NavigatorService.pushNamed(AppRoutes.exercisePronunciation,
        arguments: argumentsList);
  }

  void _handleVocabulary(int exerciseIndex, Map<String, dynamic> data) {
    List<dynamic> argumentsList = [
      data["type"],
      "NULL",
      "notcompleted",
      exerciseIndex,
      data["uid"],
      data["date"],
      data,
    ];
    NavigatorService.pushNamed(AppRoutes.exerciseVocabulary,
        arguments: argumentsList);
  }
