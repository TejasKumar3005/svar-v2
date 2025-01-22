import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/login/login_provider.dart';

import 'package:svar_new/presentation/register/provider/register_provider.dart';

import '../core/app_export.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AuthConroller {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  BuildContext? context;
  String? optId;
  int? rtoken;
  AuthConroller({this.context});
  // void setCurrPos(Position pos) {
  //   currentPostion = pos;
  //   notifyListeners();
  // }

  Future<bool> phoneVerification(String phone, bool login) async {
    try {
      var provider;
      if (login) {
        provider = Provider.of<LoginProvider>(context!, listen: false);
      } else {
        provider = Provider.of<LoginProvider>(context!, listen: false);
      }

      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 120),
          verificationCompleted: (AuthCredential authCredential) async {},
          verificationFailed: (FirebaseAuthException authexception) {
            provider.changeOtpSent(false);
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Oh Snap!',
                message: authexception.message.toString(),
                contentType: ContentType.failure,
              ),
            );
            ScaffoldMessenger.of(context!)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          },
          codeSent: (String verificationId, int? resendingtoken) {
            print(verificationId + "-------vid");
            provider.setOtpId(verificationId);
            rtoken = resendingtoken;
            provider.changeOtpSent(true);
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Success!',
                message: "Code sent to $phone",
                contentType: ContentType.success,
              ),
            );
            ScaffoldMessenger.of(context!)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});

      return true;
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: e.toString(),
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context!)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return false;
    }
  }

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Oh Snap!',
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context!)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void showSuccessSnackBar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: message,
        contentType: ContentType.success,
      ),
    );
    ScaffoldMessenger.of(context!)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<bool> registerWithPhone(String sms, UserModel model) async {
    try {
      var provider = Provider.of<RegisterProvider>(context!, listen: false);
      var otpId = provider.otpId;
      if (otpId == "") {
        print("optId is null");
        return false;
      }
      UserCredential userCredential = await firebaseAuth.signInWithCredential(
          PhoneAuthProvider.credential(verificationId: otpId, smsCode: sms));
      if (userCredential.user != null) {
        print(
            "User signed in successfully with UID: ${userCredential.user!.uid}");

        // Save user data
        await UserData(uid: userCredential.user!.uid, buildContext: context!)
            .saveUserData(model);
        print("User data saved successfully");

        return true;
      } else {
        print("User credential is null");
        return false;
      }
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar("An error occurred: ${e.toString()}");

      return false;
    } catch (e) {
      // Handle any other exceptions
      print("Exception: $e");
      showErrorSnackBar("An error occurred: $e");
      return false;
    }
  }

  Future<bool> loginWithPhone(String sms, UserModel model) async {
    try {
      var provider = Provider.of<LoginProvider>(context!, listen: false);
      var otpId = provider.otpId;
      if (otpId == "") {
        print("optId is null");
        return false;
      }
      UserCredential userCredential = await firebaseAuth.signInWithCredential(
          PhoneAuthProvider.credential(verificationId: otpId, smsCode: sms));

      if (userCredential.user != null) {
        print(
            "User signed in successfully with UID: ${userCredential.user!.uid}");

        // Save user data
        await UserData(uid: userCredential.user!.uid, buildContext: context!)
            .getUserData();
        print("User data saved successfully");

        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar("An error occurred: $e");

      return false;
    } catch (e) {
      // Handle any other exceptions
      print("Exception: $e");
       showErrorSnackBar("An error occurred: $e");
      return false;
    }
  }

  Future<bool> registeruserWithEmail(
      UserModel model, String therapyCenterId) async {
    try {
      UserCredential userCredential =
          (await firebaseAuth.createUserWithEmailAndPassword(
              email: model.email!, password: model.password!));

      if (userCredential.user != null) {
        await UserData(uid: userCredential.user!.uid, buildContext: context!)
            .saveUserData(model);
        await UserData(buildContext: context).addPatientToTherapyCenter(
            therapyCenterId, userCredential.user!.uid);

        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              "This email address is already in use by another account.";
          break;
        case 'invalid-email':
          errorMessage = "This email address is not valid.";
          break;
        case 'operation-not-allowed':
          errorMessage = "Email/password accounts are not enabled.";
          break;
        case 'weak-password':
          errorMessage = "Password is too weak.";
          break;
        default:
          errorMessage = "Something went wrong.";
      }
      showErrorSnackBar(errorMessage);
      return false;
    } catch (e) {
      showErrorSnackBar(e.toString());
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = "Please enter valid credentials";
          break;
        case 'user-disabled':
          errorMessage = " User account has been disabled.";
          break;
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMessage = "Please enter valid credentials";
          break;
        default:
          errorMessage = "Something went wrong!";
      }

      showErrorSnackBar(errorMessage);
      return false;
    } catch (e) {
      // Handle any other exceptions
      print("Exception: $e");
      showErrorSnackBar("An error occurred: $e");
      return false;
    }
  }

  final _scopes = ['https://www.googleapis.com/auth/firebase'];

  Future<bool> addTester(String email) async {
    // Load the service account key file
    final serviceAccountKey =
        await rootBundle.loadString("assets/service-account.json");
    final accountCredentials =
        ServiceAccountCredentials.fromJson(serviceAccountKey);

    // Obtain an authenticated HTTP client
    final client = await clientViaServiceAccount(accountCredentials, _scopes);

    // Replace with your project ID and app ID
    final projectId = 'svar-v2-4f0f4';
    final appId = '1:628827446185:web:951f546cf62d94092742b8';

    // Make the API request to add a tester
    final response = await http.post(
      Uri.parse(
          'https://firebaseappdistribution.googleapis.com/v1/projects/$projectId/apps/$appId/testers:batchAdd'),
      headers: {
        'Authorization': 'Bearer ${client.credentials.accessToken.data}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'emails': [email],
      }),
    );

    client.close();
    if (response.statusCode == 200) {
      print('Tester added successfully');
      return true;
    } else {
      showErrorSnackBar("Something went wrong");
      print('Failed to add tester: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  Future<bool> resendOtp(String phone) async {
    try {
      if (rtoken != null) {
        var provider = Provider.of<RegisterProvider>(context!, listen: false);
        await firebaseAuth.verifyPhoneNumber(
            phoneNumber: phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: (AuthCredential authCredential) async {},
            verificationFailed: (FirebaseAuthException authexception) {
              provider.changeOtpSent(false);
              showErrorSnackBar(authexception.message.toString());
            },
            forceResendingToken: rtoken,
            codeSent: (String verificationId, int? resendingtoken) {
              optId = verificationId;
              rtoken = resendingtoken;
              provider.changeOtpSent(true);
              showSuccessSnackBar("Code sent to $phone");
            },
            codeAutoRetrievalTimeout: (String verificationId) {});

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(e.toString());
      return false;
    }
  }
}
