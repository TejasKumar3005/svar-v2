import 'package:flutter/foundation.dart';
import 'package:svar_new/data/models/userModel.dart';

class UserDataProvider extends ChangeNotifier {

List<dynamic> therapyCenters = [];
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
