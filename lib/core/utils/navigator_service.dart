import 'package:flutter/material.dart';
import 'transition.dart';
class NavigatorService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> pushNamed(String routeName, {dynamic arguments, String? riveFileName}) async {
    return navigatorKey.currentState?.push(
      RivePageRoute(
        routeName: routeName,
        arguments: arguments,
        riveFileName: riveFileName ?? 'rive/transition.riv',
      ),
    );
  }
  static void goBack() {
    return navigatorKey.currentState?.pop();
  }

  static Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {bool routePredicate = false, dynamic arguments}) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => routePredicate,
        arguments: arguments);
  }

  static Future<dynamic> popAndPushNamed(String routeName,
      {dynamic arguments}) async {
    return navigatorKey.currentState
        ?.popAndPushNamed(routeName, arguments: arguments);
  }
}
