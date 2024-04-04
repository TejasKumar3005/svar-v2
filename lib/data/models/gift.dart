import 'package:svar_new/data/models/Product.dart';

class Gift {
  String id;
  Product product;
  Milestone milestone;
  int timeStamp;
  bool isDelivered;
  bool isachieved;

  Gift(this.id, this.product, this.milestone, this.timeStamp, this.isDelivered,
      this.isachieved);

  bool canDeliver() {
    return milestone.isAchieved();
  }

  void deliverGift() {}

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
        json["id"],
        Product.fromJson(json["product"]),
        Milestone.fromJson(json["milestone"]),
        json["timeStamp"],
        json["isDelivered"],
        json["isachieved"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "product": this.product.toJson(),
      "milestone": this.milestone.toJson(),
      "timeStamp": this.timeStamp,
      "isDelivered": this.isDelivered.toString(),
      "isachieved": this.isachieved.toString(),
    };
  }
}

// Abstract Milestone class to ensure flexibility
abstract class Milestone {
  bool isAchieved();

  String getDescription();

  // Methods to be implemented by subclasses
  Map<String, dynamic> toJson();

  factory Milestone.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'ScoreMilestone':
        return ScoreMilestone.scoreMilestoneFromJson(json);
      // Add more cases as you add more Milestone types
      default:
        throw Exception('Unknown Milestone type: ${json['type']}');
    }
  }
}

// Implementation of ScoreMilestone
class ScoreMilestone implements Milestone {
  final int targetScore;
  ScoreMilestone(this.targetScore);

  @override
  bool isAchieved() {
    // UserDataController userDataController = Get.find();
    // // Assuming userDataController is globally accessible.
    // // If not, you'll need to pass it to this class.
    // return userDataController.user_data.value.gameStats.progressScore >= this.targetScore;
    return false;
  }

  @override
  String getDescription() {
    return 'Achieve a score of ${this.targetScore}';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'ScoreMilestone',
      'targetScore': this.targetScore,
    };
  }

  static ScoreMilestone scoreMilestoneFromJson(Map<String, dynamic> json) {
    return ScoreMilestone(json['targetScore']);
  }
}
