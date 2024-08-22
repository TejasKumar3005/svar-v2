import 'package:flutter/material.dart';
import 'package:svar_new/presentation/auditory_screen/auditory.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_screen.dart';
import 'package:svar_new/presentation/login/login.dart';
import 'package:svar_new/presentation/login_signup/login_signup.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_screen.dart';
import 'package:svar_new/presentation/phoneme_level_one/level_one.dart';
import 'package:svar_new/presentation/phoneme_level_two/level_two.dart';
import 'package:svar_new/presentation/register/register.dart';
import 'package:svar_new/presentation/tip_box_video/tip_box_video_screen.dart';
import 'package:svar_new/presentation/user_profile_screen/user_profile_screen.dart';
import 'package:svar_new/presentation/welcome/welcome_screen_potrait_screen.dart';
import 'package:svar_new/presentation/welcome_screen/welcome_screen.dart.dart';
import '../presentation/home/home.dart';
import '../presentation/exit_screen/exit_screen.dart';
import '../presentation/loading_screen/loading_screen.dart';
import  '../presentation/speaking_phoneme/speaking_phoneme.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String welcomeScreenPotraitScreen =
      '/welcome_screen_potrait_screen';

  static const String loginSignup =
      '/login_signup';

  static const String login = '/login';

  static const String register = '/register';

  static const String home = '/home';

  static const String exitScreen = '/exit_screen';

  static const String loadingScreen = '/loading_screen';

  static const String welcomeScreen = '/welcome_screen';
  static const String auditoryScreenAssessmentScreenAudioVisualResizScreen =
      "/auditory_screen_assessment_audio_visual_resiz_screen";
  static const String phonemsLevelScreenTwoScreen =
      '/phonems_level_screen_two_screen';

  static const String phonemsLevelScreenOneScreen =
      '/phonems_level_screen_one_screen';

  

  static const String auditory =
      '/auditory_screen';










  static const String phonmesListScreen = '/phonmes_list_screen';

  static const String lingLearningScreen = '/ling_learning_screen';




  
  static const String speakingphonemeScreen = '/speaking_phoneme_screen';

  static const String tipBoxVideoScreen = '/tip_box_video_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';
  static const String userProfileScreen = '/user_profile';

  static Map<String, WidgetBuilder> get routes => {
        // auditoryScreenAssessmentScreenAudioVisualResizScreen:AuditoryScreenAssessmentScreenAudioVisualResizScreen.builder,
        welcomeScreenPotraitScreen: WelcomeScreenPotraitScreen.builder,
        loginSignup: LoginSignUpScreen.builder,
        login: LoginScreen.builder,
register:RegisterScreen.builder,
        home: HomeScreen.builder,
        exitScreen: ExitScreen.builder,
        loadingScreen: LoadingScreen.builder,
        welcomeScreen: WelcomeScreen.builder,
        phonemsLevelScreenTwoScreen: PhonemsLevelScreenTwoScreen.builder,
        phonemsLevelScreenOneScreen: PhonemeLevelOneScreen.builder,
      
        auditory:
            AuditoryScreen
                .builder, // will have to change the route to learning pathway
      
        
        phonmesListScreen: PhonmesListScreen.builder,
        lingLearningScreen: LingLearningScreen.builder,
        speakingphonemeScreen: SpeakingPhonemeScreen.builder,
      
        tipBoxVideoScreen: TipBoxVideoScreen.builder,
        appNavigationScreen: AppNavigationScreen.builder,
        initialRoute: LoadingScreen.builder,
        userProfileScreen: UserProfileScreen.builder
      };
}
