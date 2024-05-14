import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ParentalControlIntegration {
  static const MethodChannel _channel = MethodChannel('parental_control_channel');

  static Future<bool> checkParentalControlPIN(String enteredPin) async {
    try {
      final bool result = await _channel.invokeMethod('checkParentalControlPIN', {'pin': enteredPin});
      return result;
    } on PlatformException catch (e) {
      print("Failed to check parental control PIN: '${e.message}'.");
      return false;
    }
  }
}