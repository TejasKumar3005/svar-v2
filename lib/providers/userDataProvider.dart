import 'package:flutter/foundation.dart';
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
        
      );

  Map<String, dynamic> parentaltips = {};    
  
  void setUser(UserModel user) {
    userModel = user;
    notifyListeners();
  }

  void setParentalTips(Map<String, dynamic> tips) {
    parentaltips = tips;
    notifyListeners();
  }


}
