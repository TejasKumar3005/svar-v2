import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart'; // Import Rive package

import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/network/cacheManager.dart';

import 'package:svar_new/database/userController.dart';
import 'package:flutter/material.dart';

import 'package:svar_new/providers/userDataProvider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LoadingScreenState createState() => LoadingScreenState();

  static Widget builder(BuildContext context) {
    return LoadingScreen();
  }
}

class LoadingScreenState extends State<LoadingScreen>
   {


StateMachineController? riveController;
  @override
  void initState() {
    super.initState();
  
    
    // Call getUserData after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserData(context);
    });
  }

  @override
  void dispose() {
    riveController = null;
    super.dispose();
  }

  void getUserData(BuildContext context) async {
    try {
      UserData userData = UserData(
        uid: FirebaseAuth.instance.currentUser!.uid,
        buildContext: context,
      );

      // Run both futures concurrently and wait for both to complete
      await Future.wait([
        userData.getUserData(),
        userData.getParentalTip(),
      ]);
      var data_pro = Provider.of<UserDataProvider>(context, listen: false);
      var exx =
          await userData.getfortnightExercises(data_pro.userModel.exercises);
      print(exx);

      CachingManager.cacheFilesInIsolate(exx);

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.home,
        (route) => false,
      );
    } catch (error) {
      // Handle any exceptions that occur during the process
      print('Error occurred: $error');
    }
  }
    void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
      riveController = controller;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00FFFF), // Keep the original background color
      body: Stack(
        children: [
          // Rive animation covering the full screen
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height*0.6,
              child: RiveAnimation.asset(
                'assets/rive/loading.riv', // Replace with your Rive file path
            
                fit: BoxFit.cover,
                onInit: _onRiveInit,
              ),
            ),
          ),
          
          // Centered "Loading" text with styling
          Positioned(
            left: 0,
            right: 0,
          bottom: 70,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
            
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "LOADING...",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ),
          
          // Optional: Add a loading indicator at the bottom
          
        ],
      ),
    );
  }
}