import 'package:flutter/cupertino.dart';
import 'package:svar_new/database/authentication.dart';
import 'package:svar_new/presentation/login/login_provider.dart';
import '../../core/app_export.dart';

class LoginFormMethods {
  final BuildContext context;
  late AuthConroller ctrler;

  LoginFormMethods({required this.context}) {
    ctrler = AuthConroller(context: this.context);
  }

  Future<void> login() async {
    if (!context.mounted) return;
    
    final provider = Provider.of<LoginProvider>(context, listen: false);
    try {
      provider.changeState();  // Start loading

      final bool success = await ctrler.login(
        provider.emailController.text.trim(),
        provider.passController.text.trim(),
      );

      if (!context.mounted) return;

      provider.changeState();  // Stop loading
    
      if (success) {
        await Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.loadingScreen,
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        provider.changeState();  // Ensure loading is stopped on error
        // You might want to show an error message here
      }
    }
  }

  Future<void> sendOtp() async {
    if (!context.mounted) return;

    final provider = Provider.of<LoginProvider>(context, listen: false);
    try {
      provider.changeOtpSending(true);

      await ctrler.phoneVerification("+44 7444 555666", true);

      if (context.mounted) {
        provider.changeOtpSending(false);
      }
    } catch (e) {
      if (context.mounted) {
        provider.changeOtpSending(false);
        // You might want to show an error message here
      }
    }
  }
}