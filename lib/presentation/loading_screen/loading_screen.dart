import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/database/userController.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LoadingScreenState createState() => LoadingScreenState();

  static Widget builder(BuildContext context) {
    return 
    LoadingScreen();
  }
}

class LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void getUserData(BuildContext context) async{
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
    PlayBgm().playMusic('loading.mp3',"mp3",false);
    // Navigate after both functions are complete
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.mainInteractionScreen, 
      (route) => false,
    );
  } catch (error) {
    // Handle any exceptions that occur during the process
    print('Error occurred: $error');
  }
  }

  @override
  Widget build(BuildContext context) {
    getUserData(context);
    return Scaffold(
      backgroundColor: Color(0xff00FFFF),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImageConstant.imgMainInteraction,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          
          padding: EdgeInsets.symmetric(vertical: 38.v),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              SizedBox(
                height: 102.v,
                width: 454.h,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 87.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 47.v,
                              width: 279.h,
                              decoration: BoxDecoration(
                                color: appTheme.whiteA70001,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(72.h),
                                ),
                              ),
                            ),
                            SizedBox(height: 25.v),
                            Text(
                              "lbl_loading".tr,
                              style: CustomTextStyles.titleLarge21,
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 28.v,
                        width: 300.h,
                        margin: EdgeInsets.only(bottom: 27.v),
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.h,
                          vertical: 3.v,
                        ),
                        decoration: AppDecoration.fillLightGreen.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder15,
                        ),
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadiusStyle.roundedBorder15,
                          color: PrimaryColors().green30001,
                          
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
