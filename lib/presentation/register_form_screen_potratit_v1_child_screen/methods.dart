

import 'package:flutter/cupertino.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/game_statsModel.dart';
import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/database/authentication.dart';
import 'package:svar_new/presentation/register_form_screen_potratit_v1_child_screen/models/register_form_screen_potratit_v1_child_model.dart';
import 'package:svar_new/presentation/register_form_screen_potratit_v1_child_screen/provider/register_form_screen_potratit_v1_child_provider.dart';

class RegisterFormMethods {
 final BuildContext context;
  late  AuthConroller ctrler;

  RegisterFormMethods({required this.context}) {
    ctrler = AuthConroller(context: this.context);
  }
  void RegisterUser() {
  
    var provider = Provider.of<RegisterFormScreenPotratitV1ChildProvider>(
        context,
        listen: false);
    provider.changeState();
    ctrler
        .registerWithPhone("123456",UserModel(
                          name: provider.namePlaceholderController.text,
                          email: provider.emailController.text,
                          password: provider.passwordController.text,
                          mobile: provider.phoneNumberController.text,
                          gameStats: GameStatsModel(
                              gifts: [],
                              progressScore: 0.0,
                              badges_earned: [],
                              levels_on: [],
                              exercises: [],
                              current_level: 0)))
        .then((value) => {
              if (value)
                {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    AppRoutes.loadingScreen,
                                    (route) => false)
                }
              else
                {provider.changeState()}
            });
  }

  void sendOtp() {

    var provider = Provider.of<RegisterFormScreenPotratitV1ChildProvider>(
        context,
        listen: false);
    provider.changeOtpSending();
  
    ctrler
        .phoneVerification("+44 7444 555666")
        .then((value) => {
           provider.changeOtpSending(),
          
          
           });
  }
}
