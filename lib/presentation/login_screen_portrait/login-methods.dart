import 'package:flutter/cupertino.dart';
import 'package:svar_new/database/authentication.dart';
import 'package:svar_new/presentation/login_screen_portrait/login_screen_potrait_provider.dart';
import 'package:svar_new/presentation/register_form_screen_potratit_v1_child_screen/provider/register_form_screen_potratit_v1_child_provider.dart';

import '../../core/app_export.dart';

class LoginFormMethods {
  BuildContext context;
    late  AuthConroller ctrler;
  LoginFormMethods({required this.context}){
      ctrler = AuthConroller(context: this.context);
  }

  void login() {

    var provider =
        Provider.of<LoginScreenPotraitProvider>(context, listen: false);
    provider.changeState();
    ctrler
        .login( "123456")
        .then((value) => {
              if (value)
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.loadingScreen, (route) => false)
                }else{
                  provider.changeState()
                }
            });
  }

    void sendOtp() {

    var provider = Provider.of<LoginScreenPotraitProvider>(
        context,
        listen: false);
    provider.changeOtpSending(true);
  
    ctrler
        .phoneVerification("+44 7444 555666",true)
        .then((value) => {
          
           provider.changeOtpSending(false),
          
          
           });
  }
}