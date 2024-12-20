import 'package:flutter/services.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/login/forgot-password.dart';
import 'package:svar_new/presentation/login/login-methods.dart';
import 'package:svar_new/presentation/login/login_provider.dart';
import 'package:svar_new/widgets/loading.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: LoginScreen(),
    );
  }
}

class LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool hide = true;
  OverlayEntry? _overlayEntry;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/video/bgg_animation.mp4')
          ..initialize().then((_) {
            setState(() {
              _videoController.play();
              _videoController.setLooping(true);
            });
          });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
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

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Full-screen video background
            _videoController.value.isInitialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController.value.size.width,
                        height: _videoController.value.size.height,
                        child: VideoPlayer(_videoController),
                      ),
                    ),
                  )
                : Container(color: Colors.black),

            // Content
            SingleChildScrollView(
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Back Button
                      Row(
                        children: [
                          CustomButton(
                            type: ButtonType.Back,
                            onPressed: () {
                              PlayBgm().playMusic('Back_Btn.mp3', "mp3", false);
                              Navigator.pop(context);
                            },
                          ),
                          Spacer(),
                        ],
                      ),

                      // SVA Logo
                      CustomImageView(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.15,
                        fit: BoxFit.contain,
                        imagePath: ImageConstant.imgSvaLogo,
                      ),

                      SizedBox(
                        height: screenHeight * 0.05,
                      ),

                      // Login Form
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Email Field
                            Field(70.h, "email", provider.emailController,
                                context, provider),

                            SizedBox(
                              height: 15.v,
                            ),

                            // Password Field
                            Field(70.h, 'password', provider.passController,
                                context, provider),

                            SizedBox(
                              height: 15.v,
                            ),

                            // Forgot Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ForgotPasswordDialog();
                                        });
                                  },
                                  child: Text("Forgot Password?".tr,
                                      style: TextStyle(
                                          color: appTheme.orangeA200,
                                          fontSize: 20.h,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),

                            // Login Button
                            CustomButton(
                              type: ButtonType.Login,
                              onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    !provider.loading) {
                                  await AnalyticsService()
                                      .logSignIn(provider.emailController.text);
                                  LoginFormMethods methods =
                                      LoginFormMethods(context: context);
                                  methods.login();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                  obscureText: name == "password" ? hide : false,
                  keyboardType: name == "email"
                      ? TextInputType.emailAddress
                      : TextInputType.visiblePassword,
                  controller: controller,
                  style: TextStyle(color: Colors.black, fontSize: 22.h),
                  decoration: InputDecoration(
                    hintText: name.tr,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 22.h),
                    // Remove all borders
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,

                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 6.h),
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
                  ),
                  textAlign: TextAlign.left, // Center the text horizontally
                  validator: (value) {
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

  onTapImgClose(BuildContext context) {
    NavigatorService.goBack();
  }
}
