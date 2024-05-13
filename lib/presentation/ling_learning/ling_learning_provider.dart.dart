import 'package:flutter/material.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_model.dart.dart';
import '../../../core/app_export.dart';


/// A provider class for the LingLearningScreen.
///
/// This provider manages the state of the LingLearningScreen, including the
/// current lingLearningModelObj

// ignore_for_file: must_be_immutable
class LingLearningProvider extends ChangeNotifier {
LingLearningModel lingLearningModelObj = LingLearningModel();

@override
void dispose() {
super.dispose();
}
}

