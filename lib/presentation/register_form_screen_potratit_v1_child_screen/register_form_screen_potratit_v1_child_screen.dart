import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:svar_new/data/models/game_statsModel.dart';
import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/database/authentication.dart';
import 'package:svar_new/presentation/register_form_screen_potratit_v1_child_screen/methods.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:svar_new/widgets/custom_text_form_field.dart';
import 'package:svar_new/core/utils/validation_functions.dart';
import 'package:svar_new/widgets/custom_outlined_button.dart';
import 'package:svar_new/widgets/nextButton.dart';
import 'models/register_form_screen_potratit_v1_child_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/register_form_screen_potratit_v1_child_provider.dart';
import 'package:country_code_picker/country_code_picker.dart';

class RegisterFormScreenPotratitV1ChildScreen extends StatefulWidget {
  const RegisterFormScreenPotratitV1ChildScreen({Key? key})
      : super(
          key: key,
        );

  @override
  RegisterFormScreenPotratitV1ChildScreenState createState() =>
      RegisterFormScreenPotratitV1ChildScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterFormScreenPotratitV1ChildProvider(),
      child: RegisterFormScreenPotratitV1ChildScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class RegisterFormScreenPotratitV1ChildScreenState
    extends State<RegisterFormScreenPotratitV1ChildScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneCtrl = TextEditingController();
  List<String> list = <String>["Guardian", "Mother", "Father"];
  String dropdownValue = "Guardian";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textCtrl = context.watch<RegisterFormScreenPotratitV1ChildProvider>();
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: appTheme.orange100,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: appTheme.orange100,
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgRegisterFormScreen,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Container(
                width: 432.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 37.h,
                  vertical: 17.v,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 8.v),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 1.h),
                            child: GestureDetector(
                              onTap: () {
                                NavigatorService.pushNamedAndRemoveUntil(
                                    AppRoutes.logInSignUpScreenPotraitScreen);
                              },
                              child: CustomImageView(
                                height: 38.adaptSize,
                                width: 38.adaptSize,
                                fit: BoxFit.contain,
                                imagePath: ImageConstant.imgBackBtn,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 1.h),
                            child: CustomImageView(
                              height: 38.adaptSize,
                              width: 38.adaptSize,
                              fit: BoxFit.contain,
                              imagePath: ImageConstant.imgHomeBtn,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 17.v),
                    Container(
                      margin: EdgeInsets.only(
                        left: 7.h,
                        right: 5.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.h,
                        vertical: 37.v,
                      ),
                      decoration: AppDecoration.outlineOrangeA.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildNamePlaceholder(context),
                          SizedBox(height: 16.v),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.h),
                                decoration:
                                    AppDecoration.outlineOrangeA200.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder5,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.imgSettings,
                                      width: 10.h,
                                      margin: EdgeInsets.only(
                                        top: 4.v,
                                        bottom: 1.v,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.h),
                                      child: SizedBox(
                                        height: 23.v,
                                        child: VerticalDivider(
                                          width: 1.h,
                                          thickness: 1.v,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          left: 13.h,
                                          top: 2.v,
                                          bottom: 1.v,
                                        ),
                                        child: SizedBox(
                                          height: 24.v,
                                          child: DropdownButton<String>(
                                            iconEnabledColor:
                                                PrimaryColors().amber900,
                                            value: dropdownValue,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            elevation: 16,
                                            style: theme.textTheme.labelLarge,
                                            underline: Container(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                dropdownValue = value!;
                                              });
                                            },
                                            items: list
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: PrimaryColors()
                                                          .amber900),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24.v,
                                width: 193.h,
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 191.h,
                                        margin: EdgeInsets.only(left: 1.h),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 7.h,
                                          vertical: 2.v,
                                        ),
                                        decoration: AppDecoration
                                            .outlineOrangeA200
                                            .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.roundedBorder5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 138.h,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 19.h),
                                                  child: Selector<
                                                          RegisterFormScreenPotratitV1ChildProvider,
                                                          TextEditingController?>(
                                                      selector: (context,
                                                              provider) =>
                                                          provider
                                                              .phoneNumberController,
                                                      builder: (context,
                                                          phoneNumberController,
                                                          child) {
                                                        return CustomTextFormField(
                                                          controller:
                                                              phoneNumberController,
                                                          borderDecoration:
                                                              InputBorder.none,
                                                          hintText:
                                                              "lbl_9312211596"
                                                                  .tr,
                                                        );
                                                      })),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                RegisterFormMethods methods =
                                                    RegisterFormMethods(
                                                        context: context);

                                                methods.sendOtp();
                                              },
                                              child: Container(
                                                width: 39.h,
                                                margin: EdgeInsets.only(
                                                    bottom: 3.v),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 4.h,
                                                  vertical: 2.v,
                                                ),
                                                decoration: textCtrl.otpsending
                                                    ? null
                                                    : textCtrl.otpSent
                                                        ? AppDecoration
                                                            .outlineGreen
                                                            .copyWith(
                                                            borderRadius:
                                                                BorderRadiusStyle
                                                                    .roundedBorder5,
                                                          )
                                                        : AppDecoration
                                                            .outlineOrangeA2001
                                                            .copyWith(
                                                            borderRadius:
                                                                BorderRadiusStyle
                                                                    .roundedBorder5,
                                                          ),
                                                child: textCtrl.otpsending
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                        color: appTheme
                                                            .deepOrange200,
                                                      ))
                                                    : Text(
                                                        "lbl_send_otp".tr,
                                                        style: CustomTextStyles
                                                            .nunitoteal90003ExtraBold,
                                                      ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: 24.v,
                                        width: 20.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.h,
                                          vertical: 2.v,
                                        ),
                                        decoration: AppDecoration
                                            .outlineOrangeA2002
                                            .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.customBorderTL5,
                                        ),
                                        child:
                                            //                     CountryCodePicker(
                                            //   onChanged: print,
                                            //   initialSelection: 'IN',
                                            //   textStyle: TextStyle(color: Colors.black, fontSize: 15),
                                            //   favorite: ['+91', 'IN'],
                                            //   showCountryOnly: true,
                                            //   flagDecoration: BoxDecoration(),
                                            //   showFlag: true,
                                            //   showOnlyCountryWhenClosed: false,
                                            //   alignLeft: false,
                                            //   flagWidth: 20,
                                            // ),
                                            Container(
                                          height: 24.v,
                                          width: 20.h,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 1.h,
                                            vertical: 2.v,
                                          ),
                                          child: CustomImageView(
                                            imagePath: ImageConstant.imgIndia,
                                            width: 14.h,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.v),
                          _buildAddressGrp(context),
                          SizedBox(height: 17.v),
                          _buildEmail(context),
                          SizedBox(height: 6.v),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50.v,
                                width: 137.h,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _buildEditText(context),
                                    // Align(
                                    //   alignment: Alignment.center,
                                    //   child: Text(
                                    //     "lbl".tr,
                                    //     style: CustomTextStyles
                                    //         .displaySmallNunitoteal90003,
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 12.v),
                                padding: EdgeInsets.symmetric(horizontal: 6.h),
                                decoration:
                                    AppDecoration.outlineOrangeA200.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder5,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 110.h,
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 19.h),
                                          child: Selector<
                                                  RegisterFormScreenPotratitV1ChildProvider,
                                                  TextEditingController?>(
                                              selector: (context, provider) =>
                                                  provider.otpController,
                                              builder: (context, otpController,
                                                  child) {
                                                return CustomTextFormField(
                                                  controller: otpController,
                                                  borderDecoration:
                                                      InputBorder.none,
                                                  hintText: "otp".tr,
                                                );
                                              })),
                                    ),
                                    // GestureDetector(
                                    //   onTap: () {

                                    //   },
                                    //   child: Container(
                                    //     width: 35.h,
                                    //     margin: EdgeInsets.only(
                                    //       left: 22.h,
                                    //       top: 2.v,
                                    //       bottom: 5.v,
                                    //     ),
                                    //     padding: EdgeInsets.symmetric(
                                    //       horizontal: 5.h,
                                    //       vertical: 1.v,
                                    //     ),
                                    //     decoration: AppDecoration
                                    //         .outlineOrangeA2001
                                    //         .copyWith(
                                    //       borderRadius:
                                    //           BorderRadiusStyle.roundedBorder5,
                                    //     ),
                                    //     child: Text(
                                    //       "lbl_verify".tr,
                                    //       style:
                                    //           CustomTextStyles.nunitoteal90003,
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 22.v),
                          GestureDetector(
                              onTap: () {
                                RegisterFormMethods methods =
                                    RegisterFormMethods(context: context);
                                methods.RegisterUser();
                              },
                              child: textCtrl.loading
                                  ? CircularProgressIndicator(
                                      color: appTheme.deepOrange200,
                                    )
                                  : buildNext(context))
                        ],
                      ),
                    ),
                    SizedBox(height: 11.v),
                    SizedBox(
                      height: 313.v,
                      width: 255.h,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgFather,
                            width: 213.h,
                            alignment: Alignment.centerLeft,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgMascot173x143,
                            width: 143.h,
                            alignment: Alignment.bottomRight,
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
  Widget _buildNamePlaceholder(BuildContext context) {
    return Selector<RegisterFormScreenPotratitV1ChildProvider,
        TextEditingController?>(
      selector: (context, provider) => provider.namePlaceholderController,
      builder: (context, namePlaceholderController, child) {
        return CustomTextFormField(
          controller: namePlaceholderController,
          hintText: "name".tr,
          autofocus: false,
        );
      },
    );
  }

  /// Section Widget
  Widget _buildAddressGrp(BuildContext context) {
    return Selector<RegisterFormScreenPotratitV1ChildProvider,
        TextEditingController?>(
      selector: (context, provider) => provider.addressGrpController,
      builder: (context, addressGrpController, child) {
        return CustomTextFormField(
          controller: addressGrpController,
          hintText: "address".tr,
        );
      },
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return Selector<RegisterFormScreenPotratitV1ChildProvider,
        TextEditingController?>(
      selector: (context, provider) => provider.emailController,
      builder: (context, emailController, child) {
        return CustomTextFormField(
          controller: emailController,
          hintText: "email".tr,
          textInputType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || (!isValidEmail(value, isRequired: true))) {
              return "err_msg_please_enter_valid_email".tr;
            }
            return null;
          },
        );
      },
    );
  }

  /// Section Widget
  Widget _buildEditText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.v),
      child: Selector<RegisterFormScreenPotratitV1ChildProvider,
          TextEditingController?>(
        selector: (context, provider) => provider.passwordController,
        builder: (context, passwordController, child) {
          return CustomTextFormField(
            width: 137.h,
            controller: passwordController,
            // textInputAction: TextInputAction.done,
            alignment: Alignment.topCenter,
            obscureText: true,
            hintText: "password",
          );
        },
      ),
    );
  }

  /// Section Widget

  /// Navigates to the welcomeScreenPotraitScreen when the action is triggered.
  onTapBtnHomeBTN(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.welcomeScreenPotraitScreen,
    );
  }

  /// Navigates to the mainInteractionScreen when the action is triggered.
  onTapNext(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.mainInteractionScreen,
    );
  }
}
