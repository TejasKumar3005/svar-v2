import 'package:flutter/material.dart';
import 'package:svar_new/presentation/ling_sound_assessment/ling_sound_assessment_model.dart.dart';
import '../../../core/app_export.dart';


/// A provider class for the LingSoundAssessmentScreen.
///
/// This provider manages the state of the LingSoundAssessmentScreen, including the
/// current lingSoundAssessmentModelObj
class LingSoundAssessmentProvider extends ChangeNotifier {
LingSoundAssessmentModel lingSoundAssessmentModelObj =
LingSoundAssessmentModel();

@override
void dispose() {
super.dispose();
}
}

