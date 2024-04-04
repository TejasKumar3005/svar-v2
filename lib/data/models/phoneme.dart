

class Tip{
  String heading;
  String tip;
  String image;
  Tip(this.tip,this.image,this.heading);
  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(json["tip"], json["image"],json["heading"]);
  }
  Map<String, dynamic> toJson() {
    return {"tip": this.tip, "image": this.image,"heading":this.heading};
  }
}

class Tips {
  String problem;
  List<Tip> tips;
  Tips(this.problem, this.tips);
  factory Tips.fromJson(Map<String, dynamic> json) {
    return Tips(json["problem"], 
    json["tips"].map<Tip>((e) => Tip.fromJson(e)).toList()
    );
  }
  Map<String, dynamic> toJson() {
    return {
    "problem": this.problem,
    "tips": this.tips.map((e) => e.toJson()).toList()
    };
  }
}
class Phoneme {
  String word;
  String word_hi;
  String? audio;
  String? image;
  List<double> model_output;
  double std;
  List<String> problem_list;
  Map<String,Tips> problems;



  Phoneme(this.word, this.word_hi ,this.audio , this.image ,this.model_output, this.std, this.problem_list, this.problems);
  factory Phoneme.fromJson(Map<String, dynamic> json) {
    return Phoneme(json["word"], 
    json["word_hi"]?? "",
    json["audio"],
    json["image"] ,
    json["model_output"].map<double>((e) => e as double).toList(),
    json["std"] as double,
    json["problems"].keys.toList(),
    json["problems"].map<String, Tips>((key, value) => MapEntry<String, Tips>(key as String, Tips.fromJson(value)))
    );
  }
  Map<String, dynamic> toJson() {
    return {
    "word": this.word,
    "word_hi": this.word_hi,
    "audio": this.audio ?? "",
    "image": this.image?? "",
    "model_output": this.model_output,
    "std": this.std,
    "problems": this.problems.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}
