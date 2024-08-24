import 'package:flutter/services.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/login/login-methods.dart';
import 'package:svar_new/presentation/login/login_provider.dart';
import 'package:svar_new/widgets/loading.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LoginScreenState createState() =>
      LoginScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: LoginScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool hide = true;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<LoginProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.loading && _overlayEntry == null) {
        _overlayEntry = createOverlayEntry(context);
        Overlay.of(context)?.insert(_overlayEntry!);
      } else if (!provider.loading && _overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });



    

   return SafeArea(
  child: Scaffold(
    extendBody: true,
    extendBodyBehindAppBar: true,
    resizeToAvoidBottomInset: false,
    body: Stack(  // Use Stack to layer widgets
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Login_Screen_Potrait.png"), fit: BoxFit.fill),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        PlayBgm().playMusic('Back_Btn.mp3', "mp3", false);
                        Navigator.pop(context);
                      },
                      child: CustomImageView(
                        imagePath: ImageConstant.imgBackBtn,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomImageView(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 110.v,
                      fit: BoxFit.contain,
                      imagePath: ImageConstant.imgSvaLogo,
                    ),
                    SizedBox(
                      height: 90.v,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Field(40.h, "email", provider.emailController,
                              context, provider),
                          SizedBox(
                            height: 15.v,
                          ),
                          Field(40.h, 'password', provider.passController,
                              context, provider),
                          SizedBox(
                            height: 15.v,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate() &&
                                  !provider.loading) {
                                LoginFormMethods methods =
                                    LoginFormMethods(context: context);
                                methods.login();
                              }
                            },
                            child: CustomImageView(
                              imagePath: ImageConstant.imgLoginBTn,
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 60.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(  // Add the Rive animation as a Positioned widget
          bottom: 20.v,  // Adjust bottom position
          right: 20.h,   // Adjust right position
          child: Container(
            width: 100.v,  // Set the width for the Rive animation
            height: 100.v, // Set the height for the Rive animation
            child: RiveAnimation.asset(
              'assets/animations/mascot-rig-final.riv',  // Update with your Rive file path
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    ),
  ),
);

  }

  Widget Field(double height, String name, TextEditingController controller,
      BuildContext context, LoginProvider provider) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: height,
      decoration: BoxDecoration(
          color: appTheme.whiteA70001,
          borderRadius: BorderRadius.circular(height / 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60.h,
            padding: EdgeInsets.symmetric(vertical: 6.v),
            decoration: BoxDecoration(
                color: appTheme.whiteA70001,
                border: Border.all(
                  color: appTheme.orangeA200,
                  width: 4.h,
                  strokeAlign: strokeAlignOutside,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(height / 2),
                    bottomLeft: Radius.circular(height / 2))),
            child: Center(
              child: Icon(
                name == "email" ? Icons.email : Icons.lock,
                color: appTheme.orangeA200,
                size: 30.h,
              ),
            ),
          ),
          Expanded(
            child: Container(
              // height: height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: appTheme.whiteA70001,
                  border: Border.all(
                    color: appTheme.orangeA200,
                    width: 4.h,
                    strokeAlign: strokeAlignOutside,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(height / 2),
                      bottomRight: Radius.circular(height / 2))),
              child: Center(
                child: TextFormField(
                  // cursorHeight: height,
                  obscureText: name == "password" ? hide : false,
                  keyboardType: name == "email"
                      ? TextInputType.emailAddress
                      : TextInputType.visiblePassword,
                  controller: controller,
                  style: TextStyle(color: Colors.black, fontSize: 22.h),
                  decoration: InputDecoration(
                      hintText: name.tr,
                      suffixIcon: name == "password"
                          ? hide
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      hide = !hide;
                                    });
                                  },
                                  child: Icon(Icons.visibility))
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      hide = !hide;
                                    });
                                  },
                                  child: Icon(Icons.visibility_off))
                          : null,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 22.h),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 6.h)
                          ),
                  validator: (value){
                    if (value == null || value == "") {
                      return "Please enter $name";
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Navigates to the previous screen.
  onTapImgClose(BuildContext context) {
    NavigatorService.goBack();
  }
}
