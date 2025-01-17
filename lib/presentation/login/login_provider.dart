import 'package:flutter/material.dart';


class LoginProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();
  bool loading = false;
  bool otpsent = false;
  bool sending = false;
  String otpId = "";
  bool dialog = false;
  void changeOtpSending(bool value) {
    sending = value;
    notifyListeners();
  }

  void changeDialogState(bool d) {
    dialog = d;
    notifyListeners();
  }

  void setOtpId(String vid) {
    otpId = vid;
    notifyListeners();
  }

  void changeOtpSent(bool value) {
    otpsent = value;
    notifyListeners();
  }

  void changeState() {
    loading = !loading;
    notifyListeners();
  }



  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }
}
