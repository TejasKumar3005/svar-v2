import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:svar_new/database/authentication.dart';
import 'package:svar_new/presentation/login_screen_portrait/login-methods.dart';
import 'package:svar_new/presentation/login_screen_portrait/login_screen_potrait_provider.dart';
import 'package:svar_new/presentation/register_form_screen_potratit_v1_child_screen/methods.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:svar_new/core/utils/validation_functions.dart';
import 'package:svar_new/widgets/custom_text_form_field.dart';
import 'package:svar_new/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/loading.dart';

class LoginScreenPotraitScreen extends StatefulWidget {
  const LoginScreenPotraitScreen({Key? key})
      : super(
          key: key,
        );

  @override
  LoginScreenPotraitScreenState createState() =>
      LoginScreenPotraitScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginScreenPotraitProvider(),
      child: LoginScreenPotraitScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class LoginScreenPotraitScreenState extends State<LoginScreenPotraitScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<LoginScreenPotraitProvider>();

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.v),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/BG.png"), fit: BoxFit.fill),
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
                        Navigator.of(context).popAndPushNamed(
                            AppRoutes.logInSignUpScreenPotraitScreen);
                      },
                      child: CustomImageView(
                        imagePath: ImageConstant.imgBackBtn,
                      ),
                    ),
                    Spacer()
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
                          Field(50.h, "phone", provider.emailController,
                              context, provider),
                          SizedBox(
                            height: 15.v,
                          ),
                          provider.otpsent
                              ? Field(50.h, 'otp', provider.passController,
                                  context, provider)
                              : Container(),
                          SizedBox(
                            height: 15.v,
                          ),
                          provider.otpsent
                              ? !provider.loading
                                  ? GestureDetector(
                                      onTap: () {
                                        LoginFormMethods methods =
                                            LoginFormMethods(context: context);
                                        methods.login();
                                      },
                                      child: CustomImageView(
                                        imagePath: ImageConstant.imgLoginBTn,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height: 60.h,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : CircularProgressIndicator(
                                      color: appTheme.deepOrange200,
                                    )
                              : Container()
                        ],
                      ),
                    ),
                    Container(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Field(double height, String name, TextEditingController controller,
      BuildContext context, LoginScreenPotraitProvider provider) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: height,
      decoration: BoxDecoration(
          color: appTheme.whiteA70001,
          borderRadius: BorderRadius.circular(height / 2)),
      child: Row(
        children: [
          Container(
            height: height,
            width: 60.h,
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
              child: CustomImageView(
                height: 40.v,
                width: 40.h,
                fit: BoxFit.contain,
                imagePath: "assets/images/$name.png",
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: height,
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
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: controller,
                style: TextStyle(color: Colors.black, fontSize: 22.h),
                decoration: InputDecoration(
                    hintText: name.tr,
                    suffixIcon: name == "phone"
                        ? (provider.sending
                            ? CircularProgressIndicator()
                            : GestureDetector(
                              onTap: (){
                                if(!provider.otpsent){
                                  
                                LoginFormMethods methods =
                                            LoginFormMethods(context: context);
                                        methods.sendOtp();
                                }
                              },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      provider.otpsent
                                          ? "ötp sent"
                                          : "lbl_send_otp".tr,
                                      style: TextStyle(
                                        color:provider.otpsent?appTheme.green900: appTheme.orangeA200,
                                        fontSize: 15.fSize,
                                        fontWeight: FontWeight.w800,
                                      )),
                                ),
                              ))
                        : Container(height: 0.001,width: 0.01,),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 22.h),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.h)
                    // .copyWith(bottom: 15.v)
                    ),
                validator: (value) {
                  if(value==null || value==""){
                    return "Please enter $name";
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgUnionCyanA100,
          height: 159.v,
          width: 157.h,
          alignment: Alignment.topRight,
        ),
        CustomImageView(
          imagePath: ImageConstant.imgUnionCyanA10071x110,
          height: 71.v,
          width: 110.h,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 21.v),
        ),
        Padding(
          padding: EdgeInsets.only(left: 28.h),
          child: Selector<LoginScreenPotraitProvider, TextEditingController?>(
            selector: (context, provider) => provider.emailController,
            builder: (context, emailController, child) {
              return CustomTextFormField(
                width: 337.h,
                controller: emailController,
                hintText: "msg_rakeshramjirast2".tr,
                hintStyle: CustomTextStyles.titleMediumTeal90003,
                textInputType: TextInputType.emailAddress,
                alignment: Alignment.centerLeft,
                prefix: Container(
                  margin: EdgeInsets.fromLTRB(12.h, 12.v, 22.h, 14.v),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgLock,
                    height: 16.v,
                    width: 21.h,
                  ),
                ),
                prefixConstraints: BoxConstraints(
                  maxHeight: 44.v,
                ),
                validator: (value) {
                  if (value == null ||
                      (!isValidEmail(value, isRequired: true))) {
                    return "err_msg_please_enter_valid_email".tr;
                  }
                  return null;
                },
                contentPadding: EdgeInsets.only(
                  top: 9.v,
                  right: 22.h,
                  bottom: 9.v,
                ),
                borderDecoration: TextFormFieldStyleHelper.underLineOrangeA,
                filled: false,
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 82.v,
            width: 337.h,
            margin: EdgeInsets.only(left: 28.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 57.h),
                    child: Text(
                      "lbl".tr,
                      style: CustomTextStyles.displayLargeNunitoTeal90003,
                    ),
                  ),
                ),
                Selector<LoginScreenPotraitProvider, TextEditingController?>(
                  selector: (context, provider) => provider.passController,
                  builder: (context, editTextController, child) {
                    return CustomTextFormField(
                      width: 337.h,
                      controller: editTextController,
                      textInputAction: TextInputAction.done,
                      alignment: Alignment.center,
                      obscureText: true,
                      borderDecoration:
                          TextFormFieldStyleHelper.underLineOrangeA,
                      filled: false,
                      validator: (value) {
                        if (value == null || (value.length < 6)) {
                          return "password must be atleast 6 characters long"
                              .tr;
                        }
                        return null;
                      },
                    );
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  /// Navigates to the previous screen.
  onTapImgClose(BuildContext context) {
    NavigatorService.goBack();
  }
}