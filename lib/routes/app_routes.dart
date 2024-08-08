import 'package:flutter/material.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_screen_audio/auditory_screen_assessment_screen_audio_visual_one_screen.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_screen_audio/auditory_screen_assessment_screen_audio_visual_screen.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_visual/auditory_screen_assessment_screen_visual_audio_resiz_screen.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_visual/auditory_screen_assessment_screen_visual_audio_screen.dart';
import 'package:svar_new/presentation/auditory_screen_visual_learning_screen/auditory_screen_visual_learning_screen_resized_screen.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_screen.dart';
import 'package:svar_new/presentation/ling_learning_detailed/ling_learning_detailed_tip_box_screen.dart';
import 'package:svar_new/presentation/ling_learning_quick_tip/ling_learning_quick_tip_screen.dart.dart';
import 'package:svar_new/presentation/ling_sound_assessment/ling_sound_assessment_screen.dart.dart';
import 'package:svar_new/presentation/ling_sound_assessment_screen_correct/ling_sound_assessment_screen_correct_response_screen.dart.dart';
import 'package:svar_new/presentation/login_screen_portrait/login_screen_potrait_screen.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_screen.dart';
import 'package:svar_new/presentation/phenoms_level_screen_one/phonems_level_screen_one_screen.dart';
import 'package:svar_new/presentation/phonems_level_screen_two/phonems_level_screen_two_screen.dart';
import 'package:svar_new/presentation/tip_box_video/tip_box_video_screen.dart';
import 'package:svar_new/presentation/user_profile_screen/user_profile_screen.dart';
import 'package:svar_new/presentation/welcome_screen/welcome_screen.dart.dart';
import '../presentation/welcome_screen_potrait_screen/welcome_screen_potrait_screen.dart';
import '../presentation/log_in_sign_up_screen_potrait_screen/log_in_sign_up_screen_potrait_screen.dart';
import '../presentation/register_form_screen_potratit_v1_child_screen/register_form_screen_potratit_v1_child_screen.dart';
import '../presentation/main_interaction_screen/main_interaction_screen.dart';
import '../presentation/exit_screen/exit_screen.dart';
import '../presentation/loading_screen/loading_screen.dart';
import  '../presentation/speaking_phoneme/speaking_phoneme.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String welcomeScreenPotraitScreen =
      '/welcome_screen_potrait_screen';

  static const String logInSignUpScreenPotraitScreen =
      '/log_in_sign_up_screen_potrait_screen';

  static const String loginScreenPotraitScreen = '/login_screen_potrait_screen';

  static const String registerFormScreenPotratitV1ChildScreen =
      '/register_form_screen_potratit_v1_child_screen';

  static const String mainInteractionScreen = '/main_interaction_screen';

  static const String exitScreen = '/exit_screen';

  static const String loadingScreen = '/loading_screen';

  static const String welcomeScreen = '/welcome_screen';
  static const String auditoryScreenAssessmentScreenAudioVisualResizScreen =
      "/auditory_screen_assessment_audio_visual_resiz_screen";
  static const String phonemsLevelScreenTwoScreen =
      '/phonems_level_screen_two_screen';

  static const String phonemsLevelScreenOneScreen =
      '/phonems_level_screen_one_screen';

  static const String auditoryScreenAssessmentScreenAudioVisualResizedScreen =
      '/auditory_screen_assessment_screen_audio_visual_resized_screen';

  static const String auditoryScreenAssessmentScreenVisualAudioResizScreen =
      '/auditory_screen_assessment_screen_visual_audio_resiz_screen';

  static const String auditoryScreenVisualLearningScreenResizedScreen =
      '/auditory_screen_visual_learning_screen_resized_screen';

  static const String lingSoundAssessmentScreen =
      '/ling_sound_assessment_screen';

  static const String lingSoundAssessmentScreenCorrectResponseScreen =
      '/ling_sound_assessment_screen_correct_response_screen';

  static const String auditoryScreenAssessmentScreenAudioVisualScreen =
      '/auditory_screen_assessment_screen_audio_visual_screen';

  static const String auditoryScreenAssessmentScreenAudioVisualOneScreen =
      '/auditory_screen_assessment_screen_audio_visual_one_screen';

  static const String auditoryScreenAssessmentScreenVisualAudioScreen =
      '/auditory_screen_assessment_screen_visual_audio_screen';

  static const String phonmesListScreen = '/phonmes_list_screen';

  static const String lingLearningScreen = '/ling_learning_screen';

  static const String lingLearningQuickTipScreen =
      '/ling_learning_quick_tip_screen';

  static const String lingLearningDetailedTipBoxScreen =
      '/ling_learning_detailed_tip_box_screen';
  
  static const String speakingphonemeScreen = '/speaking_phoneme_screen';

  static const String tipBoxVideoScreen = '/tip_box_video_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';
  static const String userProfileScreen = '/user_profile';

  static Map<String, WidgetBuilder> get routes => {
        // auditoryScreenAssessmentScreenAudioVisualResizScreen:AuditoryScreenAssessmentScreenAudioVisualResizScreen.builder,
        welcomeScreenPotraitScreen: WelcomeScreenPotraitScreen.builder,
        logInSignUpScreenPotraitScreen: LogInSignUpScreenPotraitScreen.builder,
        loginScreenPotraitScreen: LoginScreenPotraitScreen.builder,
        registerFormScreenPotratitV1ChildScreen:
            RegisterFormScreenPotratitV1ChildScreen.builder,
        mainInteractionScreen: MainInteractionScreen.builder,
        exitScreen: ExitScreen.builder,
        loadingScreen: LoadingScreen.builder,
        welcomeScreen: WelcomeScreen.builder,
        phonemsLevelScreenTwoScreen: PhonemsLevelScreenTwoScreen.builder,
        phonemsLevelScreenOneScreen: PhonemsLevelScreenOneScreen.builder,
        auditoryScreenAssessmentScreenAudioVisualResizedScreen:
            AuditoryScreenAssessmentScreenAudioVisualOneScreen.builder,
        auditoryScreenAssessmentScreenVisualAudioResizScreen:
            AuditoryScreenAssessmentScreenVisualAudioResizScreen
                .builder, // will have to change the route to learning pathway
        auditoryScreenVisualLearningScreenResizedScreen:
            AuditoryScreenVisualLearningScreenResizedScreen.builder,
        lingSoundAssessmentScreen: LingSoundAssessmentScreen.builder,
        lingSoundAssessmentScreenCorrectResponseScreen:
            LingSoundAssessmentScreenCorrectResponseScreen.builder,
        auditoryScreenAssessmentScreenAudioVisualScreen:
            AuditoryScreenAssessmentScreenAudioVisualScreen.builder,
        auditoryScreenAssessmentScreenAudioVisualOneScreen:
            AuditoryScreenAssessmentScreenAudioVisualOneScreen.builder,
        auditoryScreenAssessmentScreenVisualAudioScreen:
            AuditoryScreenAssessmentScreenVisualAudioScreen.builder,
        phonmesListScreen: PhonmesListScreen.builder,
        lingLearningScreen: LingLearningScreen.builder,
        speakingphonemeScreen: SpeakingPhonemeScreen.builder,
        lingLearningQuickTipScreen: LingLearningQuickTipScreen.builder,
        lingLearningDetailedTipBoxScreen:
            LingLearningDetailedTipBoxScreen.builder,
        tipBoxVideoScreen: TipBoxVideoScreen.builder,
        appNavigationScreen: AppNavigationScreen.builder,
        initialRoute: LoadingScreen.builder,
        userProfileScreen: UserProfileScreen.builder
      };
}
