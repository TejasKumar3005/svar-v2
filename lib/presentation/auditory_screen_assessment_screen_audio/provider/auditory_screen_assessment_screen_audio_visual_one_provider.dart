import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/auditory_screen_assessment_screen_audio_visual_one_model.dart';

/// A provider class for the AuditoryScreenAssessmentScreenAudioVisualOneScreen.
///
/// This provider manages the state of the AuditoryScreenAssessmentScreenAudioVisualOneScreen, including the
/// current auditoryScreenAssessmentScreenAudioVisualOneModelObj
class AuditoryScreenAssessmentScreenAudioVisualOneProvider
extends ChangeNotifier {
AuditoryScreenAssessmentScreenAudioVisualOneModel
auditoryScreenAssessmentScreenAudioVisualOneModelObj =
AuditoryScreenAssessmentScreenAudioVisualOneModel();

@override
void dispose() {
super.dispose();
}
}

