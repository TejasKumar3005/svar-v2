import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart'; // Make sure this import is correct
import 'package:svar_new/widgets/custom_button.dart'; // And this one too
import 'package:svar_new/presentation/settings_screen/setting.dart'; // Import SettingsScreen

Widget DisciAppBar(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5.v),
          child: CustomButton(
            type: ButtonType.Back,
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        Spacer(),
        SizedBox(
          width: 10.h,
        ),
        CustomButton(
  type: ButtonType.Menu,
  onPressed: () {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: SettingsScreen(),
          insetPadding: EdgeInsets.symmetric(horizontal: 1),
          elevation: 0,
          backgroundColor: Colors.transparent,
        );
      });
  },
),

      ],
    ),
  );
}
