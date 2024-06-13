import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';
import 'package:svar_new/data/models/game_statsModel.dart';
import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/database/userController.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:svar_new/presentation/login_screen_portrait/login_screen_potrait_provider.dart';

import '../core/app_export.dart';
import '../presentation/register_form_screen_potratit_v1_child_screen/provider/register_form_screen_potratit_v1_child_provider.dart';

class AuthConroller {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Position? currentPostion;
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
      if(login){
        provider= Provider.of<LoginScreenPotraitProvider>(context!, listen: false);
      }else{
        provider= Provider.of<RegisterFormScreenPotratitV1ChildProvider>(context!, listen: false);
      }
      
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 120),
          verificationCompleted: (AuthCredential authCredential) async {},
          verificationFailed: (FirebaseAuthException authexception) {
            provider.changeOtpSent(false);
            ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
              content: Text(authexception.message.toString()),
              backgroundColor: Colors.red,
            ));
          },
          codeSent: (String verificationId, int? resendingtoken) {
            print(verificationId + "-------vid");
            provider.setOtpId(verificationId);
            rtoken = resendingtoken;
            provider.changeOtpSent(true);
            ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
              content: Text("code sent to " + phone),
              backgroundColor: Colors.green,
            ));
          },
          codeAutoRetrievalTimeout: (String verificationId) {});

      return true;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  Future<bool> registerWithPhone(String sms, UserModel model) async {
    try {
      var provider = Provider.of<RegisterFormScreenPotratitV1ChildProvider>(
          context!,
          listen: false);
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
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));

      return false;
    } catch (e) {
      // Handle any other exceptions
      print("Exception: $e");
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text("An error occurred: $e"),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  Future<bool> loginWithPhone(String sms, UserModel model) async {
    try {
      var provider = Provider.of<RegisterFormScreenPotratitV1ChildProvider>(
          context!,
          listen: false);
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
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));

      return false;
    } catch (e) {
      // Handle any other exceptions
      print("Exception: $e");
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text("An error occurred: $e"),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  Future<bool> registeruserWithEmail(UserModel model) async {
    try {
      UserCredential userCredential =
          (await firebaseAuth.createUserWithEmailAndPassword(
              email: model.email!, password: model.password!));

      if (userCredential.user != null) {
        await UserData(uid: userCredential.user!.uid, buildContext: context!)
            .saveUserData(model);

        return true;
      }

      return false;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  Future UpdategoogleSignUp(UserModel model, String uid) async {
    try {
      if (currentPostion != null) {
        await UserData(uid: uid, buildContext: context!).saveUserData(model);

        return true;
      } else {
        getCurrentPosition(context!).then((value) async {
          if (value) {
            await UserData(uid: uid, buildContext: context!)
                .saveUserData(model);

            return true;
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future updateUserData(
      String uid, String name, String mobile, String gender) async {
    await UserData(uid: uid, buildContext: context!).updateUserInfo({
      "name": name,
      "mobile": mobile,
      "gender": gender,
      "location": [currentPostion!.latitude, currentPostion!.longitude],
    });
  }

  Future<bool> login(String email,String password) async {
    try {
      
      
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email,password: password);
    
      if (userCredential.user != null) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));

      return false;
    } catch (e) {
      // Handle any other exceptions
      print("Exception: $e");
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text("An error occurred: $e"),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  Future googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return false;
      }
      final GoogleSignInAuthentication? authentication =
          await googleUser.authentication;

      if (authentication == null) {
        return false;
      }

      final credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);

      if (credential == null) {
        return false;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection("users");

      // check if user already exists in database
      try {
        DocumentSnapshot documentSnapshot =
            await userCollection.doc(userCredential.user!.uid).get();
        if (documentSnapshot.exists) {
          // user already exists
          await UserData(uid: userCredential.user!.uid, buildContext: context!)
              .getUserData();
          return true;
        }

        UserModel userModel = UserModel(
            p_name: userCredential.user!.displayName!,
            name: "",
            email: userCredential.user!.email!,
            password: "",
            uid: userCredential.user!.uid!,
            imageUrl: userCredential.user!.photoURL == null
                ? ""
                : userCredential.user!.photoURL!,
            age: "",
            timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
            gender: 0,
            location: [],
            access_token: credential.accessToken.toString(),
            subscription_status: "NO",
            mobile: "",
            gift_purchase_history: [],
            gameStats: GameStatsModel(
                gifts: [],
                progressScore: 0.0,
                badges_earned: [],
                levels_on: [],
                exercises: [],
                current_level: 0));
        // UserDatabase(uid: userCredential.user!.uid!).saveUserData(userModel);
        // UserDatabase(uid: userCredential.user!.uid!).getUserData();
        return userModel;
      } on FirebaseException catch (e) {
        // retry login
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Exception in logging in");
      print(e.message);
      return false;
    } catch (e) {
      print("error in logging in other than firebase error");
      print(e.toString());
      return false;
    }
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
            'Location services are disabled. Please enable the services'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {
            AppSettings.openAppSettings(type: AppSettingsType.location);
          },
          textColor: Colors.white,
        ),
      ));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<bool> getCurrentPosition(BuildContext context) async {
    final hasPermission = await handleLocationPermission(context);

    if (!hasPermission) return false;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      // setCurrPos(position);
      return true;
    }).catchError((e) {
      return false;
    });
    return false;
  }

  Future<bool> resendOtp(String phone) async {
    try {
      if (rtoken != null) {
        var provider = Provider.of<RegisterFormScreenPotratitV1ChildProvider>(
            context!,
            listen: false);
        await firebaseAuth.verifyPhoneNumber(
            phoneNumber: phone,
            timeout: Duration(seconds: 120),
            verificationCompleted: (AuthCredential authCredential) async {},
            verificationFailed: (FirebaseAuthException authexception) {
              provider.changeOtpSent(false);
              ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
                content: Text(authexception.message.toString()),
                backgroundColor: Colors.red,
              ));
            },
            forceResendingToken: rtoken,
            codeSent: (String verificationId, int? resendingtoken) {
              optId = verificationId;
              rtoken = resendingtoken;
              provider.changeOtpSent(true);
              ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
                content: Text("code sent to " + phone),
                backgroundColor: Colors.green,
              ));
            },
            codeAutoRetrievalTimeout: (String verificationId) {});

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }
}
