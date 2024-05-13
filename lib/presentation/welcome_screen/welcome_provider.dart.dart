import 'package:flutter/material.dart';
import 'package:svar_new/presentation/welcome_screen/welcome_model.dart.dart';
import '../../../core/app_export.dart';

/// A provider class for the WelcomeScreen.
///
/// This provider manages the state of the WelcomeScreen, including the
/// current welcomeModelObj
class WelcomeProvider extends ChangeNotifier {
WelcomeModel welcomeModelObj = WelcomeModel();

@override
void dispose() {
super.dispose();
}
}

