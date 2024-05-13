import 'package:flutter/material.dart';
import 'package:svar_new/presentation/ling_learning_detailed/ling_learning_detailed_tip_box_model.dart.dart';
import '../../../core/app_export.dart';


/// A provider class for the LingLearningDetailedTipBoxScreen.
///
/// This provider manages the state of the LingLearningDetailedTipBoxScreen, including the
/// current lingLearningDetailedTipBoxModelObj

// ignore_for_file: must_be_immutable
class LingLearningDetailedTipBoxProvider extends ChangeNotifier {
LingLearningDetailedTipBoxModel lingLearningDetailedTipBoxModelObj =
LingLearningDetailedTipBoxModel();

@override
void dispose() {
super.dispose();
}
}

