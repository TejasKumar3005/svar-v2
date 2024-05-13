import 'package:flutter/material.dart';
import 'package:svar_new/presentation/ling_learning_quick_tip/ling_learning_quick_tip_model.dart.dart';
import '../../../core/app_export.dart';


/// A provider class for the LingLearningQuickTipScreen.
///
/// This provider manages the state of the LingLearningQuickTipScreen, including the
/// current lingLearningQuickTipModelObj
class LingLearningQuickTipProvider extends ChangeNotifier {
LingLearningQuickTipModel lingLearningQuickTipModelObj =
LingLearningQuickTipModel();

@override
void dispose() {
super.dispose();
}
}

