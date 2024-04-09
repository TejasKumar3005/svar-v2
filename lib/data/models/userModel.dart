import 'package:svar_new/data/models/game_statsModel.dart';
import 'package:svar_new/data/models/gift.dart';

class UserModel {
  String? p_name;
  String name;
  String? password;
  String? email;
  String? uid;
  String? imageUrl;
  String? age;
  String? timeStamp;
  int? gender;
  List? location;
  String? access_token;
  String? subscription_status;
  String? mobile;
   List<Gift> gift_purchase_history = [];
  Gift? currently_scheduled_gift ;
  GameStatsModel gameStats = GameStatsModel(
                  gifts: [],  
                  progressScore: 0.0, 
                  badges_earned: [], 
                  levels_on : [], 
                  exercises: [], 
                  current_level: 0);

  UserModel({
   this.p_name,
    required this.name,
    this.password,
    required this.email,
    this.uid,
    this.imageUrl,
    this.age,
    this.timeStamp,
    this.gender,
    this.location,
    this.access_token,
    this.subscription_status,
    this.mobile,
     this.gift_purchase_history = const [],
      this.currently_scheduled_gift,
      required this.gameStats,
  });

 UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
        p_name: json["p_name"] ?? "",
        name: json['name'] ?? "",
        password: json['password'] ?? "",
        email: json['email'] ?? "",
        uid: json['uid'] ?? "",
        imageUrl: json['imageUrl']  ?? "",
        age: json['age'] ?? "",
        timeStamp: json['timeStamp'] ?? "",
        gender: json['gender'] ?? 0,
        location: json['location'] ?? [0,0],
        access_token: json['access_token'] ?? "",
        subscription_status: json['subscription_status']?? "NO",
        mobile: json['mobile'] ?? "",
        gift_purchase_history: (json['gift_purchase_history'] ?? []).map<Gift>((e) => Gift.fromJson(e)).toList(),
        currently_scheduled_gift: json['currently_scheduled_gift'] == null ? null : Gift.fromJson(json['currently_scheduled_gift']),
        gameStats: json['gameStats'] == null ? GameStatsModel(
                  gifts: [],  
                  progressScore: 0.0, 
                  badges_earned: [], 
                  levels_on : [], 
                  exercises: [], 
                  current_level: 0) : GameStatsModel.fromJson(json["gameStats"]));
  }

  List<Gift> getgifts(Map<String, dynamic> json) {
    var giftsjson = json as List;
    List<Gift> gifts = giftsjson == [] ? [] : giftsjson.map<Gift>((e) => Gift.fromJson(e)).toList();
    return gifts;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> list_gifts =
        gift_purchase_history!.map((e) => e.toJson()).toList();
    return {
      "p_name": this.p_name,
      "name": this.name,
      "email": this.email,
      "password": this.password,
      "mobile": this.mobile,
      "uid": this.uid,
      "imageUrl": this.imageUrl,
      "age": this.age,
      "timeStamp": this.timeStamp,
      "gender": this.gender,
      "location": this.location,
      "access_token": this.access_token,
      "subscription_status": this.subscription_status,
      "gift_purchase_history": list_gifts,
      "currently_scheduled_gift": this.currently_scheduled_gift== null ? null : this.currently_scheduled_gift!.toJson(),
      "gameStats":this.gameStats!.toJson()
    };
  }
}
