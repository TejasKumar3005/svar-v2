import 'package:flutter/material.dart';
import 'package:svar_new/theme/theme_helper1.dart';

Widget CustomTextField({required TextEditingController controller, String? hintText, Color? fillColor, Color? focusedBorderColor, Color? enabledBorderColor, String? initialValue}) {
  return TextFormField(
    cursorColor: appTheme.orangeA200,
    initialValue: initialValue,
    controller: controller,
    decoration: InputDecoration(
      fillColor: const Color.fromARGB(255, 241, 240, 240),
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: const Color.fromARGB(255, 135, 135, 135), width: 2),
      ),
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: const Color.fromARGB(255, 135, 135, 135), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: const Color.fromARGB(255, 187, 186, 186), width: 2),
      ),
      hintStyle: TextStyle(color: Colors.grey),
    ),
  );
}
