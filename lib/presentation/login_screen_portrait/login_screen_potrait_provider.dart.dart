import 'package:flutter/material.dart';
import 'package:svar_new/presentation/login_screen_portrait/login_screen_potrait_model.dart.dart';
import '../../../core/app_export.dart';

/// A provider class for the LoginScreenPotraitScreen.
///
/// This provider manages the state of the LoginScreenPotraitScreen, including the
/// current loginScreenPotraitModelObj

// ignore_for_file: must_be_immutable
class LoginScreenPotraitProvider extends ChangeNotifier {
TextEditingController emailController = TextEditingController();

TextEditingController editTextController = TextEditingController();

LoginScreenPotraitModel loginScreenPotraitModelObj =
LoginScreenPotraitModel();

@override
void dispose() {
super.dispose();
emailController.dispose();
editTextController.dispose();
}
}

