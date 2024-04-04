


import 'package:svar_new/data/models/phoneme.dart';

class Exercise {
  Phoneme phoneme;
  Map<int, int> progress_timeline;
  Exercise(this.phoneme, this.progress_timeline);
  
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
    Phoneme.fromJson(json["phoneme"]),
    (json["progress_timeline"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(int.parse(key), value as int))
);

  }

  Map<String, dynamic> toJson() {
    return {
      "phoneme":this.phoneme.toJson(),
      "progress_timeline": this.progress_timeline.map((key, value) => MapEntry(key.toString(), value)),
    };
  }
}
