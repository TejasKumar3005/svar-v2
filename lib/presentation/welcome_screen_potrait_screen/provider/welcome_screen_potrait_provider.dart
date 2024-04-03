import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/welcome_screen_potrait_model.dart';

/// A provider class for the WelcomeScreenPotraitScreen.
///
/// This provider manages the state of the WelcomeScreenPotraitScreen, including the
/// current welcomeScreenPotraitModelObj

// ignore_for_file: must_be_immutable
class WelcomeScreenPotraitProvider extends ChangeNotifier {
  WelcomeScreenPotraitModel welcomeScreenPotraitModelObj =
      WelcomeScreenPotraitModel();

  @override
  void dispose() {
    super.dispose();
  }
}
