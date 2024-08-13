import 'package:svar_new/data/models/gift.dart';

class UserModel {
  List<String>? parentNames;
  String name;
  String? password;
  String? email;
  String? uid;
  String? profile;
  String? dob;
  String? doj;
  String? address;
  int? gender;
  List? location;
  String? access_token;
  String? subscription_status;
  String? mobile;
  int? phoneme_current_level;
  int? auditory_current_level;
  // List<Gift> gift_purchase_history = [];
  // Gift? currently_scheduled_gift;
  int? score;
  int? coins;
  String? therapist;
  String? batch;
  // GameStatsModel gameStats = GameStatsModel(
  //     gifts: [],
  //     progressScore: 0.0,
  //     badges_earned: [],
  //     levels_on: [],
  //     exercises: [],
  //     current_level: 0);

  UserModel(
      {this.parentNames,
      required this.name,
      this.password,
      required this.email,
      this.uid,
      this.profile,
      this.dob,
      this.doj,
      this.gender,
      this.location,
      this.access_token,
      this.subscription_status,
      this.mobile,
      this.phoneme_current_level,
      this.auditory_current_level,
      this.score,
      this.coins,
      this.address,
      this.therapist ,  this.batch
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        parentNames: json["parentNames"] ?? [],
        name: json['name'] ?? "",
        password: json['password'] ?? "",
        email: json['email'] ?? "",
        uid: json['uid'] ?? "",
        profile: json['profile'] ?? "",
        dob: json['dob'] ?? "",
      
        gender: json['gender'] ?? 0,
        location: json['location'] ?? [0, 0],
        access_token: json['access_token'] ?? "",
        subscription_status: json['subscription_status'] ?? "NO",
        mobile: json['mobile'] ?? "",
        phoneme_current_level: json['phoneme_current_level'] ?? 0,
        auditory_current_level: json['auditory_current_level'] ?? 0,
        score: json['score'] ?? 0,
        coins: json['coins'] ?? 0,
        address: json['address'] ?? "",  therapist: json['therapist'] ?? "",
      batch: json['batch'] ?? ""
    );
  }

  List<Gift> getgifts(Map<String, dynamic> json) {
    var giftsjson = json as List;
    List<Gift> gifts = giftsjson == []
        ? []
        : giftsjson.map<Gift>((e) => Gift.fromJson(e)).toList();
    return gifts;
  }

  Map<String, dynamic> toJson() {
    return {
      "parentNames": this.parentNames,
      "name": this.name,
      "email": this.email,
      "password": this.password,
      "mobile": this.mobile,
      "uid": this.uid,
      "profile": this.profile,
      "dob": this.dob,
      "doj": this.doj,
      "gender": this.gender,
      "location": this.location,
      "access_token": this.access_token,
      "subscription_status": this.subscription_status,
      "phoneme_current_level": this.phoneme_current_level,
      "auditory_current_level": this.auditory_current_level,
      "score": this.score,
      "coins": this.coins,
      "address": this.address,
      "therapist": this.therapist,
      "batch": this.batch
      // "gift_purchase_history": list_gifts,
      // "currently_scheduled_gift": this.currently_scheduled_gift == null
      //     ? null
      //     : this.currently_scheduled_gift!.toJson(),
      // "gameStats": this.gameStats!.toJson()
    };
  }
}
