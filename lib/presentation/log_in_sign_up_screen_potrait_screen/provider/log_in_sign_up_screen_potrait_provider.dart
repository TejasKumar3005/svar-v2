import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/log_in_sign_up_screen_potrait_model.dart';

/// A provider class for the LogInSignUpScreenPotraitScreen.
///
/// This provider manages the state of the LogInSignUpScreenPotraitScreen, including the
/// current logInSignUpScreenPotraitModelObj

// ignore_for_file: must_be_immutable
class LogInSignUpScreenPotraitProvider extends ChangeNotifier {
  LogInSignUpScreenPotraitModel logInSignUpScreenPotraitModelObj =
      LogInSignUpScreenPotraitModel();

 @override
  void dispose() {
    super.dispose();
  } 
}
