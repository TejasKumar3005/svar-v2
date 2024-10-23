import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:svar_new/core/analytics/analytics.dart';

import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/login/login_provider.dart';

import 'package:svar_new/presentation/register/provider/register_provider.dart';

import '../core/app_export.dart';

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
        AnalyticsService().logEvent("signup_failure", {
        "email": model.email,
        "reason": "UserId was null"
      });

      return false;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
        AnalyticsService().logEvent("login_failure", {
        "email": model.email,
        "reason": e.code.toString()
      });
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
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
      return false;
    } catch (e) {
        AnalyticsService().logEvent("login_failure", {
        "email": model.email,
        "reason": e.toString()
      });
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  // Future UpdategoogleSignUp(UserModel model, String uid) async {
  //   try {
  //     if (currentPostion != null) {
  //       await UserData(uid: uid, buildContext: context!).saveUserData(model);

  //       return true;
  //     } else {
  //       getCurrentPosition(context!).then((value) async {
  //         if (value) {
  //           await UserData(uid: uid, buildContext: context!)
  //               .saveUserData(model);

  //           return true;
  //         }
  //       });
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

  // Future updateUserData(
  //     String uid, String name, String mobile, String gender) async {
  //   await UserData(uid: uid, buildContext: context!).updateUserInfo(
  //     "name": name,
  //     "mobile": mobile,
  //     "gender": gender,
  //     "location": [currentPostion!.latitude, currentPostion!.longitude],
  //   });
  // }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        return true;
      }
      AnalyticsService().logEvent("login_failure", {
        "email": email,
      "reason": "UserId was null"
      });
      return false;
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      AnalyticsService().logEvent("login_failure", {
        "email": email,
        "reason": e.code.toString()
      });
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

      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ));
      return false;
    } catch (e) {
      // Handle any other exceptions
        AnalyticsService().logEvent("login_failure", {
        "email": email,
        "reason": e.toString()
      });
      print("Exception: $e");
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text("An error occurred: $e"),
        backgroundColor: Colors.red,
      ));
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
      ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
        backgroundColor: Colors.red,
      ));
      print('Failed to add tester: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  // Future googleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       return false;
  //     }
  //     final GoogleSignInAuthentication? authentication =
  //         await googleUser.authentication;

  //     if (authentication == null) {
  //       return false;
  //     }

  //     final credential = GoogleAuthProvider.credential(
  //         accessToken: authentication.accessToken,
  //         idToken: authentication.idToken);

  //     if (credential == null) {
  //       return false;
  //     }

  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     final CollectionReference userCollection =
  //         FirebaseFirestore.instance.collection("users");

  //     // check if user already exists in database
  //     try {
  //       DocumentSnapshot documentSnapshot =
  //           await userCollection.doc(userCredential.user!.uid).get();
  //       if (documentSnapshot.exists) {
  //         // user already exists
  //         await UserData(uid: userCredential.user!.uid, buildContext: context!)
  //             .getUserData();
  //         return true;
  //       }

  //       UserModel userModel = UserModel(
  //           p_name: userCredential.user!.displayName!,
  //           name: "",
  //           email: userCredential.user!.email!,
  //           password: "",
  //           uid: userCredential.user!.uid!,
  //           imageUrl: userCredential.user!.photoURL == null
  //               ? ""
  //               : userCredential.user!.photoURL!,
  //           age: "",
  //           timeStamp: DateTime.now().microsecondsSinceEpoch.toString(),
  //           gender: 0,
  //           location: [],
  //           access_token: credential.accessToken.toString(),
  //           subscription_status: "NO",
  //           mobile: "",
  //           // gift_purchase_history: [],
  //           // gameStats: GameStatsModel(
  //           //     gifts: [],
  //           //     progressScore: 0.0,
  //           //     badges_earned: [],
  //           //     levels_on: [],
  //           //     exercises: [],
  //           //     current_level: 0)
  //               );
  //       // UserDatabase(uid: userCredential.user!.uid!).saveUserData(userModel);
  //       // UserDatabase(uid: userCredential.user!.uid!).getUserData();
  //       return userModel;
  //     } on FirebaseException catch (e) {
  //       // retry login
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     print("Firebase Exception in logging in");
  //     print(e.message);
  //     return false;
  //   } catch (e) {
  //     print("error in logging in other than firebase error");
  //     print(e.toString());
  //     return false;
  //   }
  // }

  // Future<bool> handleLocationPermission(BuildContext context) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: const Text(
  //           'Location services are disabled. Please enable the services'),
  //       duration: const Duration(seconds: 2),
  //       action: SnackBarAction(
  //         label: "OK",
  //         onPressed: () {
  //           AppSettings.openAppSettings(type: AppSettingsType.location);
  //         },
  //         textColor: Colors.white,
  //       ),
  //     ));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied')));
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.')));
  //     return false;
  //   }
  //   return true;
  // }

  // Future<bool> getCurrentPosition(BuildContext context) async {
  //   final hasPermission = await handleLocationPermission(context);

  //   if (!hasPermission) return false;
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) {
  //     // setCurrPos(position);
  //     return true;
  //   }).catchError((e) {
  //     return false;
  //   });
  //   return false;
  // }

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
