import 'package:flutter/material.dart';
import '../presentation/welcome_screen_potrait_screen/welcome_screen_potrait_screen.dart';
import '../presentation/log_in_sign_up_screen_potrait_screen/log_in_sign_up_screen_potrait_screen.dart';
import '../presentation/register_form_screen_potratit_v1_child_screen/register_form_screen_potratit_v1_child_screen.dart';
import '../presentation/main_interaction_screen/main_interaction_screen.dart';
import '../presentation/loading_screen/loading_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String welcomeScreenPotraitScreen =
      '/welcome_screen_potrait_screen';

  static const String logInSignUpScreenPotraitScreen =
      '/log_in_sign_up_screen_potrait_screen';

  static const String registerFormScreenPotratitV1ChildScreen =
      '/register_form_screen_potratit_v1_child_screen';

  static const String mainInteractionScreen = '/main_interaction_screen';

  static const String loadingScreen = '/loading_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        welcomeScreenPotraitScreen: WelcomeScreenPotraitScreen.builder,
        logInSignUpScreenPotraitScreen: LogInSignUpScreenPotraitScreen.builder,
        registerFormScreenPotratitV1ChildScreen:
            RegisterFormScreenPotratitV1ChildScreen.builder,
        mainInteractionScreen: MainInteractionScreen.builder,
        loadingScreen: LoadingScreen.builder,
        appNavigationScreen: AppNavigationScreen.builder,
        initialRoute: LoadingScreen.builder
      };
}
