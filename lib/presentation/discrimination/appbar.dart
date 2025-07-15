import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svar_new/core/app_export.dart'; // Make sure this import is correct
import 'package:svar_new/presentation/patient_report/app_theme.dart';
import 'package:svar_new/widgets/custom_button.dart'; // And this one too
import 'package:svar_new/presentation/settings_screen/setting.dart'; // Import SettingsScreen

Widget DisciAppBar(
  BuildContext context, {
  required bool parent_mode,
  bool show_switch = true,
  required ValueChanged<bool> onParentModeChanged,
}) {
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Parent Mode",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: parent_mode ? Colors.blue[600] : Colors.grey[600],
                ),
              ),
              SizedBox(width: 8),
              if (show_switch)
                Switch(
                  value: !parent_mode,
                  onChanged: (value) {
                  onParentModeChanged(!value);
                },
                activeColor: Colors.green[600],
                activeTrackColor: Colors.green[200],
                inactiveThumbColor: Colors.blue[300],
                inactiveTrackColor: Colors.blue[100],
              ),
              SizedBox(width: 8),
              Text(
                "Exercise",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: !parent_mode ? Colors.green[600] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Spacer(),
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
