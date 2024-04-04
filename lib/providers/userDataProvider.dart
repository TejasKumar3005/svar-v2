import 'package:flutter/foundation.dart';
import 'package:svar_new/data/models/game_statsModel.dart';
import 'package:svar_new/data/models/userModel.dart';

class UserDataProvider extends ChangeNotifier {
 UserModel userModel = UserModel(
        p_name: "",
        name: "",
        password: "",
        email: "",
        uid: "",
        imageUrl: "",
        age: "",
        timeStamp: "",
        access_token: "",
        gift_purchase_history: [],
        gameStats: GameStatsModel(
            gifts: [],
            progressScore: 0.0,
            badges_earned: [],
            levels_on: [],
            exercises: [],
            current_level: 0));
  
  void setUser(UserModel user) {
    userModel = user;
    notifyListeners();
  }
}
