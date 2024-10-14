import 'package:flutter/material.dart';
import 'transition.dart';
import 'dart:async';

class NavigatorService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

static Future<dynamic> pushNamed(String routeName, {dynamic arguments, String? riveFileName}) async {
    return navigatorKey.currentState?.push(
      RivePageRoute(
        routeName: routeName,
        arguments: arguments,
        riveFileName: riveFileName ?? 'assets/rive/transition.riv',
      ),
    );
  }

  static Future<void> goBack() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return navigatorKey.currentState?.pop();
  }

  static Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {bool routePredicate = false, dynamic arguments}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => routePredicate,
        arguments: arguments);
  }

  static Future<dynamic> popAndPushNamed(String routeName,
      {dynamic arguments}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return navigatorKey.currentState
        ?.popAndPushNamed(routeName, arguments: arguments);
  }
}
