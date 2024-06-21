import 'package:flutter/material.dart';
import '../models/auditory_screen_assessment_screen_audio_visual_model.dart';

/// A provider class for the AuditoryScreenAssessmentScreenAudioVisualScreen.
///
/// This provider manages the state of the AuditoryScreenAssessmentScreenAudioVisualScreen, including the
/// current auditoryScreenAssessmentScreenAudioVisualModelObj
class AuditoryScreenAssessmentScreenAudioVisualProvider extends ChangeNotifier {
AuditoryScreenAssessmentScreenAudioVisualModel
auditoryScreenAssessmentScreenAudioVisualModelObj =
AuditoryScreenAssessmentScreenAudioVisualModel();

@override
void dispose() {
super.dispose();
}
}

