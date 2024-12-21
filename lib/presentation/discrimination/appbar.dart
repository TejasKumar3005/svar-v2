import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/custom_button.dart';

Widget DisciAppBar(BuildContext context) {
  return Row(
    children: [
      Padding(
        padding: EdgeInsets.only(top: 5.v),
        child: CustomButton(
            type: ButtonType.Back,
            onPressed: () {
              Navigator.pop(context, true);
            }),
      ),
      Spacer(),

      SizedBox(
        width: 10.h,
      ),
      CustomButton(type: ButtonType.Menu, onPressed: () {
        Navigator.pushNamed(context, AppRoutes.setting); 
      }),
      
    ],
  );
}
