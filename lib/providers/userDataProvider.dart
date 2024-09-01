import 'package:flutter/foundation.dart';
import 'package:svar_new/data/models/userModel.dart';

class UserDataProvider extends ChangeNotifier {

List<dynamic> therapyCenters = [];
 UserModel userModel = UserModel(
        parentNames: [],
        name: "",
        password: "",
        email: "",
        uid: "",
        profile: "",
        dob: "",
        doj: "",
        access_token: "",
        levelMap: LevelMap(detection: 0,discrimination: 0,identification: 0,level: 0),
      );

  Map<String, dynamic> parentaltips = {};    
  List<dynamic> getTherapyCenters() {
    return therapyCenters;
  }
  void setUser(UserModel user) {
    userModel = user;
    notifyListeners();
  }

  void setParentalTips(Map<String, dynamic> tips) {
    parentaltips = tips;
    notifyListeners();
  }
  void setTherapyCenters(List<dynamic> centers) {
    therapyCenters = centers;
    notifyListeners();
  }


}
