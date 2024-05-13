import 'package:flutter/material.dart';
import 'package:svar_new/presentation/ling_sound_assessment_screen_correct/ling_sound_assessment_screen_correct_response_model.dart.dart';
import '../../../core/app_export.dart';

/// A provider class for the LingSoundAssessmentScreenCorrectResponseScreen.
///
/// This provider manages the state of the LingSoundAssessmentScreenCorrectResponseScreen, including the
/// current lingSoundAssessmentScreenCorrectResponseModelObj
class LingSoundAssessmentScreenCorrectResponseProvider extends ChangeNotifier {
LingSoundAssessmentScreenCorrectResponseModel
lingSoundAssessmentScreenCorrectResponseModelObj =
LingSoundAssessmentScreenCorrectResponseModel();

@override
void dispose() {
super.dispose();
}
}

