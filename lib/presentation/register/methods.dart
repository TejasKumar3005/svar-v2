

import 'package:flutter/cupertino.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/database/authentication.dart';
import 'package:svar_new/presentation/register/provider/register_provider.dart';

class RegisterFormMethods {
 final BuildContext context;
  late  AuthConroller ctrler;

  RegisterFormMethods({required this.context}) {
    ctrler = AuthConroller(context: this.context);
  }
  void RegisterUser(String therapyCenterId) {
  
    var provider = Provider.of<RegisterProvider>(
        context,
        listen: false);
    provider.changeState();
    ctrler
        .registeruserWithEmail(UserModel(
                          name: provider.namePlaceholderController.text,
                          email: provider.emailController.text,
                          password: provider.passwordController.text,
                          mobile: provider.phoneNumberController.text,
                          address: provider.addressGrpController.text,           
                          phoneme_current_level: 0,
                          auditory_current_level: 0,
                          score: 0,
                          therapist: null,
                          batch:null,
                          levelMap: LevelMap(detection: 0,discrimination: 0,identification: 0,level: 0),
                        ),therapyCenterId)
        .then((value) => {
              if (value)
                { 
                  AnalyticsService().logSignUp(provider.emailController.text),
                provider.changeState(),
                Navigator.of(context).pushNamedAndRemoveUntil(
                                    AppRoutes.loadingScreen,
                                    (route) => false)
                
                }
              else
                {provider.changeState()}
            });
  }

  void sendOtp() {

    var provider = Provider.of<RegisterProvider>(
        context,
        listen: false);
    provider.changeOtpSending();
  
    ctrler
        .phoneVerification("+44 7444 555666",false)
        .then((value) => {
           provider.changeOtpSending(),
          
          
           });
  }
}
