import 'package:flutter/cupertino.dart';
import 'package:svar_new/database/authentication.dart';
import 'package:svar_new/presentation/login_screen_portrait/login_screen_potrait_provider.dart';

import '../../core/app_export.dart';

class LoginFormMethods {
  BuildContext context;
  LoginFormMethods({required this.context});

  void login() {
    AuthConroller ctrler = AuthConroller(context: context);
    var provider =
        Provider.of<LoginScreenPotraitProvider>(context, listen: false);
    provider.changeState();
    ctrler
        .login(provider.emailController.text.toString(),
            provider.passController.text.toString())
        .then((value) => {
              if (value)
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.mainInteractionScreen, (route) => false)
                }else{
                  provider.changeState()
                }
            });
  }
}
