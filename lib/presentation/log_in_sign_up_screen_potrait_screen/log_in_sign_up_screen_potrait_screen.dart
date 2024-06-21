import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/log_in_sign_up_screen_potrait_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';


class LogInSignUpScreenPotraitScreen extends StatefulWidget {
  const LogInSignUpScreenPotraitScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LogInSignUpScreenPotraitScreenState createState() =>
      LogInSignUpScreenPotraitScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogInSignUpScreenPotraitProvider(),
      child: LogInSignUpScreenPotraitScreen(),
    );
  }
}

class LogInSignUpScreenPotraitScreenState
    extends State<LogInSignUpScreenPotraitScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   var provider = Provider.of<AppUpdateProvider>(context, listen: false);
    //   provider.checkForUpdate();
    //   provider.setCallHandler();
    // });
  }

  @override
  Widget build(BuildContext context) {
    // var providerAppUpdate =
    //     Provider.of<AppUpdateProvider>(context, listen: false);
    // if (providerAppUpdate.dialogOpen) {
    //   showDialog(
    //     barrierDismissible: false,
    //       context: context, builder: (BuildContext context) => UpdateDialog());
    // }
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/BG.png"), fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomImageView(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 110.v,
                    fit: BoxFit.contain,
                    imagePath: ImageConstant.imgSvaLogo,),
                      SizedBox(
                      height: 100.v,
                    ),
                
                  Column(
                    children: [
                        CustomButton(
                        type: ButtonType.Login,
                        onPressed: () {
                          NavigatorService.pushNamed(
                            AppRoutes.loginScreenPotraitScreen,
                          );
                        }),
                      SizedBox(height: 10.v,),
                      CustomButton(
                        type: ButtonType.SignUp,
                        onPressed: () {
                          NavigatorService.pushNamed(
                            AppRoutes.registerFormScreenPotratitV1ChildScreen,
                          );
                        }),
                    ],
                  ),
                  Container(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
