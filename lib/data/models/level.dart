

import 'package:svar_new/data/models/excercise.dart';

class Level {
  int level_no;
  List<Exercise> exercises;
  bool isCurrent;
  bool isCleared;

  Level(
    this.level_no,
    this.exercises,
    this.isCurrent,
    this.isCleared
  );
  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(json["level_no"], 
    json["exercises"].map<Exercise>((e) => Exercise.fromJson(e)).toList(),
    bool.fromEnvironment(json["isCurrent"]),
    bool.fromEnvironment(json["isCleared"]),
    );
    
  }

  Map<String, dynamic> toJson() {
    
    return { 
      "level_no":this.level_no,
      "exercises":this.exercises.map((e) => e.toJson()).toList(),
      "isCurrent":this.isCurrent.toString(),
      "isCleared":this.isCleared.toString(),
    };
  }


}
