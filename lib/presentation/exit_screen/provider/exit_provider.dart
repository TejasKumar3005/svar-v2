import 'package:flutter/material.dart';
import 'package:svar_new/presentation/exit_screen/models/exit_model.dart.dart';

/// A provider class for the ExitScreen.
///
/// This provider manages the state of the ExitScreen, including the
/// current exitModelObj

// ignore_for_file: must_be_immutable
class ExitProvider extends ChangeNotifier {
ExitModel exitModelObj = ExitModel();

@override
void dispose() {
super.dispose();
}
}

