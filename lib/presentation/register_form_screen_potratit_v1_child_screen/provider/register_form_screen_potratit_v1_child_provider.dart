// import 'dart:js_util';

import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/register_form_screen_potratit_v1_child_model.dart';

/// A provider class for the RegisterFormScreenPotratitV1ChildScreen.
///
/// This provider manages the state of the RegisterFormScreenPotratitV1ChildScreen, including the
/// current registerFormScreenPotratitV1ChildModelObj

// ignore_for_file: must_be_immutable
class RegisterFormScreenPotratitV1ChildProvider extends ChangeNotifier {
  TextEditingController namePlaceholderController = TextEditingController();

  TextEditingController addressGrpController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController guardianController = TextEditingController();
  bool loading = false;
  bool otpSent = false;
  bool otpsending = false;
  String otpId = '';
  void changeState() {
    loading = !loading;
    notifyListeners();
  }

  void changeOtpSending() {
    otpsending = !otpsending;
    notifyListeners();
  }

  void changeOtpSent(bool sent) {
    otpSent = sent;
    notifyListeners();
  }

  void setOtpId(String vid) {
    otpId = vid;
    notifyListeners();
  }

  RegisterFormScreenPotratitV1ChildModel
      registerFormScreenPotratitV1ChildModelObj =
      RegisterFormScreenPotratitV1ChildModel();

  @override
  void dispose() {
    super.dispose();
    namePlaceholderController.dispose();
    addressGrpController.dispose();
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    phoneNumberController.dispose();
  }
}
