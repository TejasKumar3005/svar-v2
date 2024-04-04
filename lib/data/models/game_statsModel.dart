

import 'package:svar_new/data/models/badge.dart';
import 'package:svar_new/data/models/gift.dart';
import 'package:svar_new/data/models/level.dart';

import 'excercise.dart';

class GameStatsModel {
  int current_level;
  double progressScore;
  List<Exercise> exercises;
  List<Level> levels_on;
  List<Badge> badges_earned;
  List<Gift> gifts;

  GameStatsModel(
      {this.gifts = const [],
      required this.progressScore,
      required this.exercises,
      required this.levels_on,
      this.badges_earned = const [],
      required this.current_level});

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> exc_list =
        this.exercises.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> lev_list =
        this.levels_on.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> bad_list =
        this.badges_earned.map((e) => e.toJson()).toList();
    return {
      'current_level': this.current_level,
      "progressScore": this.progressScore,
      "exercises": exc_list,
      "levels_on": lev_list,
      "badges_earned": bad_list,
      "gifts": this.gifts.map((e) => e.toJson()).toList()
    };
  }

  factory GameStatsModel.fromJson(Map<String, dynamic> json) {
    var excjson = json["exercises"] as List;
    var leveljson = json["levels_on"] as List;
    var badgejson =
        json["badges_earned"] == null ? json["badges_earned"] as List : [];
    var giftjson = json["gifts"] == null ? json["gifts"] as List : [];
    List<Exercise> exercises =
        excjson.map<Exercise>((e) => Exercise.fromJson(e)).toList();
    List<Level> levels = leveljson.map((e) => Level.fromJson(e)).toList();
    List<Badge> badges_earned =
        badgejson.map<Badge>((e) => Badge.fromJson(e)).toList();

    List<Gift> gifts = giftjson == []
        ? []
        : giftjson.map<Gift>((e) => Gift.fromJson(e)).toList();

    GameStatsModel gameStatsModel = GameStatsModel(
        gifts: gifts,
        progressScore: json["progressScore"],
        exercises: exercises,
        levels_on: levels,
        badges_earned: badges_earned,
        current_level: json["current_level"]);

    return gameStatsModel;
  }
}
