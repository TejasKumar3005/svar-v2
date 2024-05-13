import 'package:svar_new/presentation/login_screen_portrait/login_screen_potrait_provider.dart.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:svar_new/core/utils/validation_functions.dart';
import 'package:svar_new/widgets/custom_text_form_field.dart';
import 'package:svar_new/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.52, 0.33),
              end: Alignment(1, 0.61),
              colors: [
                appTheme.gray5003,
                appTheme.cyan200,
                appTheme.lightBlueA200
              ],
            ),
          ),
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildClose(context),
                    _buildEmail(context),
                    SizedBox(height: 13.v),
                    SizedBox(
                      height: 537.v,
                      width: double.maxFinite,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgTree,
                            height: 191.v,
                            width: 109.h,
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 11.v),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgTreeGreen400,
                            height: 118.v,
                            width: 68.h,
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(top: 81.v),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgTreeGreen400102x88,
                            height: 102.v,
                            width: 88.h,
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(
                              top: 109.v,
                              right: 110.h,
                            ),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgEllipse1761,
                            height: 253.v,
                            width: 430.h,
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(bottom: 111.v),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgEllipse1771,
                            height: 286.v,
                            width: 164.h,
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(bottom: 78.v),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgEllipse1751,
                            height: 291.v,
                            width: 430.h,
                            alignment: Alignment.bottomCenter,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgMascot,
                            height: 231.v,
                            width: 191.h,
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(
                              top: 69.v,
                              right: 24.h,
                            ),
                          ),
                          CustomOutlinedButton(
                            width: 216.h,
                            text: "lbl_log_in".tr,
                            leftIcon: Container(
                              margin: EdgeInsets.only(right: 30.h),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgShineWhiteA70001,
                                height: 12.v,
                                width: 23.h,
                              ),
                            ),
                            buttonStyle: CustomButtonStyles.none,
                            decoration: CustomButtonStyles
                                .gradientPrimaryToLightGreenDecoration,
                            alignment: Alignment.topCenter,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildClose(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 95.v,
            width: 62.h,
            margin: EdgeInsets.only(
              top: 18.v,
              bottom: 118.v,
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgCloseCyanA100,
                  height: 95.v,
                  width: 59.h,
                  alignment: Alignment.centerLeft,
                  onTap: () {
                    onTapImgClose(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.v),
                  child: CustomIconButton(
                    height: 37.adaptSize,
                    width: 37.adaptSize,
                    padding: EdgeInsets.all(9.h),
                    decoration: IconButtonStyleHelper
                        .gradientDeepOrangeToDeepOrangeTL18,
                    alignment: Alignment.topRight,
                    child: CustomImageView(
                      imagePath: ImageConstant.imgArrowDown,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 232.v,
            width: 363.h,
            margin: EdgeInsets.only(left: 5.h),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgUnion,
                  height: 90.v,
                  width: 195.h,
                  alignment: Alignment.topRight,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgSvarLogo,
                  height: 150.v,
                  width: 295.h,
                  alignment: Alignment.bottomLeft,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return SizedBox(
      height: 207.v,
      width: 412.h,
      child: Stack(
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
                    selector: (context, provider) =>
                        provider.editTextController,
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
                      );
                    },
                  )
                ],
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
