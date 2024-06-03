import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

void ShowLoadingDialog(BuildContext context) {

  showDialog(
    context: context,
    builder: (
      BuildContext context,
    ) {
      return Dialog(
        child: Center(
          child: LinearProgressIndicator(
            color: appTheme.deepOrange200,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      );
    },
    barrierDismissible: false,
  );

  

}
