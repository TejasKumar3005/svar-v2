import 'package:flutter/services.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/login/forgot-password.dart';
import 'package:svar_new/presentation/login/login-methods.dart';
import 'package:svar_new/presentation/login/login_provider.dart';
import 'package:svar_new/widgets/loading.dart';
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
        Overlay.of(context).insert(_overlayEntry!);
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
        body: SingleChildScrollView(
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
                      IconButton(
                        onPressed: () {
                          PlayBgm().playMusic('Back_Btn.mp3', "mp3", false);
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back,size: 30.h,),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 20.h),
 CustomImageView(
      width: screenWidth * 0.4,
      height: screenHeight * 0.1,
      fit: BoxFit.contain,
      imagePath: ImageConstant.imgSvaLogo1,
    ),
              
              SizedBox(height: 20.h),
        
              TextFormField(
                  cursorColor: appTheme.orangeA200,
                controller: provider.emailController,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 241, 240, 240),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                  borderSide: BorderSide(color: const Color.fromARGB(255, 135, 135, 135),width: 2),
                  ),
                  hintText: "Email",
                focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                  borderSide: BorderSide(color: const Color.fromARGB(255, 135, 135, 135),width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                    borderSide: BorderSide(color: const Color.fromARGB(255, 187, 186, 186),width: 2),
                  ),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                  cursorColor: appTheme.orangeA200,
                controller: provider.passController,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 241, 240, 240),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  border: OutlineInputBorder(
                    
                    borderRadius: BorderRadius.circular(10),

                    borderSide: BorderSide(color: const Color.fromARGB(255, 135, 135, 135),width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                    borderSide: BorderSide(color: const Color.fromARGB(255, 187, 186, 186),width: 2),
                  ),
                
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                  borderSide: BorderSide(color: const Color.fromARGB(255, 135, 135, 135),width: 2),
                  ),
              

                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        showDialog(context: context, builder: (context) => ForgotPasswordDialog());
                      },
                    child: Text("Forgot Password?",textAlign: TextAlign.end, style: TextStyle(color: appTheme.orangeA200, fontSize: 18.h,fontWeight: FontWeight.w600),)),
                ],
              ),
              SizedBox(height: 20.h),
              CustomButton(
                          type: ButtonType.CreateAccount,
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
        
                  // Login Form
                
                ],
              ),
            ),
          ),
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
