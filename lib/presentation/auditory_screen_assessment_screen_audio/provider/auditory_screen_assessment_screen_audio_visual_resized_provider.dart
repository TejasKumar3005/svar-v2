import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/auditory_screen_assessment_screen_audio_visual_resized_model.dart';

/// A provider class for the AuditoryScreenAssessmentScreenAudioVisualResizedScreen.
///
/// This provider manages the state of the AuditoryScreenAssessmentScreenAudioVisualResizedScreen, including the
/// current auditoryScreenAssessmentScreenAudioVisualResizedModelObj

// ignore_for_file: must_be_immutable
class AuditoryScreenAssessmentScreenAudioVisualResizedProvider
extends ChangeNotifier {
AuditoryScreenAssessmentScreenAudioVisualResizedModel
auditoryScreenAssessmentScreenAudioVisualResizedModelObj =
AuditoryScreenAssessmentScreenAudioVisualResizedModel();

@override
void dispose() {
super.dispose();
}
}

