import 'package:flutter/material.dart';
import '../models/auditory_screen_assessment_screen_visual_audio_model.dart';

/// A provider class for the AuditoryScreenAssessmentScreenVisualAudioScreen.
///
/// This provider manages the state of the AuditoryScreenAssessmentScreenVisualAudioScreen, including the
/// current auditoryScreenAssessmentScreenVisualAudioModelObj
class AuditoryScreenAssessmentScreenVisualAudioProvider extends ChangeNotifier {
AuditoryScreenAssessmentScreenVisualAudioModel
auditoryScreenAssessmentScreenVisualAudioModelObj =
AuditoryScreenAssessmentScreenVisualAudioModel();

@override
void dispose() {
super.dispose();
}
}

