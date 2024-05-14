import 'package:flutter/material.dart';
import 'package:svar_new/presentation/quit_screen/quit_game_screen_model.dart.dart';
import '../../../core/app_export.dart';

/// A provider class for the QuitGameScreenDialog.
///
/// This provider manages the state of the QuitGameScreenDialog, including the
/// current quitGameScreenModelObj

// ignore_for_file: must_be_immutable
class QuitGameScreenProvider extends ChangeNotifier {
QuitGameScreenModel quitGameScreenModelObj = QuitGameScreenModel();

@override
void dispose() {
super.dispose();
}
}

