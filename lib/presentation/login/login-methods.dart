import 'package:flutter/cupertino.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/database/authentication.dart';
import 'package:svar_new/presentation/login/login_provider.dart';


import '../../core/app_export.dart';

class LoginFormMethods {
  BuildContext context;
    late  AuthConroller ctrler;
  LoginFormMethods({required this.context}){
      ctrler = AuthConroller(context: this.context);
  }

  void login() {

    var provider =
        Provider.of<LoginProvider>(context, listen: false);
    provider.changeState();
    ctrler
        .login(provider.emailController.text.toString(),provider.passController.text.toString())
        .then((value) => {
              if (value)
                {
                  AnalyticsService().logSignIn(provider.emailController.text),
                  provider.changeState(),
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.loadingScreen, (route) => false)
                }else{
                  provider.changeState()
                }
            });
  }

    void sendOtp() {

    var provider = Provider.of<LoginProvider>(
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
