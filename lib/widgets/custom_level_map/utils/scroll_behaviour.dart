// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';

class MyBehavior extends ScrollBehavior {
  const MyBehavior();
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
