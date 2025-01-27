import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  
  bool loading = false;
  bool otpsent = false;
  bool sending = false;
  String otpId = "";
  bool dialog = false;
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void changeOtpSending(bool value) {
    if (!_disposed) {
      sending = value;
      notifyListeners();
    }
  }

  void changeDialogState(bool d) {
    if (!_disposed) {
      dialog = d;
      notifyListeners();
    }
  }

  void setOtpId(String vid) {
    if (!_disposed) {
      otpId = vid;
      notifyListeners();
    }
  }

  void changeOtpSent(bool value) {
    if (!_disposed) {
      otpsent = value;
      notifyListeners();
    }
  }

  void changeState() {
    if (!_disposed) {
      loading = !loading;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}