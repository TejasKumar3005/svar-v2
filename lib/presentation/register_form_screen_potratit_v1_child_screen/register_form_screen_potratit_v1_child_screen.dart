import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:svar_new/data/models/game_statsModel.dart';
import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/database/authentication.dart';
import 'package:svar_new/presentation/register_form_screen_potratit_v1_child_screen/methods.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:svar_new/widgets/custom_text_form_field.dart';
import 'package:svar_new/core/utils/validation_functions.dart';
import 'package:svar_new/widgets/custom_outlined_button.dart';
import 'package:svar_new/widgets/loading.dart';
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
  bool hide = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    final textCtrl = context.watch<RegisterFormScreenPotratitV1ChildProvider>();
    if (textCtrl.loading) {
      wheelLoadingDialog(context);
    }
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
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.symmetric(
                  horizontal: 30.h,
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
                                    Icon(
                                      Icons.person_2,
                                      color: appTheme.orangeA200,
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
                                          top: 3.v,
                                          bottom: 2.v,
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
                              _buildPhoneNo(context)
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
                            children: [_buildEditText(context)],
                          ),
                          SizedBox(height: 22.v),
                          textCtrl.loading
                              ? CircularProgressIndicator(
                                  color: appTheme.deepOrange200,
                                )
                              : CustomButton(
                                  type: ButtonType.Next,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      RegisterFormMethods methods =
                                          RegisterFormMethods(context: context);
                                      methods.RegisterUser();
                                    }
                                  },
                                )
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

  Widget _buildPhoneNo(BuildContext context) {
    return Selector<RegisterFormScreenPotratitV1ChildProvider,
            TextEditingController?>(
        builder: (context, phoneNumberController, child) {
          return CustomTextFormField(
            width: 160.h,
            controller: phoneNumberController,
            prefix: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgIndia,
                    width: 24.h,
                    height: 23.v,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: SizedBox(
                    height: 23.v,
                    child: VerticalDivider(
                      width: 1.h,
                      thickness: 1.v,
                    ),
                  ),
                ),
              ],
            ),
            validator: (value) {
              if (value!.length < 10) {
                return "Please enter valid phone number";
              } else {
                return null;
              }
            },
            hintText: "lbl_9312211596".tr,
          );
        },
        selector: (context, provider) => provider.phoneNumberController);
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
          prefix: Icon(
            Icons.person,
            size: 25,
            color: appTheme.orangeA200,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 6.v, horizontal: 2.h),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter name";
            } else {
              return null;
            }
          },
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
          prefix: Icon(
            Icons.location_on,
            size: 25,
            color: appTheme.orangeA200,
          ),
          hintText: "address".tr,
          contentPadding: EdgeInsets.symmetric(vertical: 6.v, horizontal: 2.h),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "err_msg_please_enter_valid_address".tr;
            }
            return null;
          },
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
          prefix: Icon(
            size: 25,
            Icons.email,
            color: appTheme.orangeA200,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 6.v, horizontal: 2.h),
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
            width: 200.h,
            controller: passwordController,
            suffix: GestureDetector(
              onTap: () {
                setState(() {
                  hide = !hide;
                });
              },
              child: Icon(
                hide ? Icons.visibility : Icons.visibility_off,
                color: appTheme.orangeA200,
              ),
            ),
            validator: (value) {
              if (value!.length < 6) {
                return "Password must be at least 6 characters";
              } else {
                return null;
              }
            },
            prefix: Icon(
              Icons.lock,
              size: 25,
              color: appTheme.orangeA200,
            ),
            // textInputAction: TextInputAction.done,
            alignment: Alignment.topCenter,
            obscureText: hide,
            hintText: "password",
            contentPadding:
                EdgeInsets.symmetric(vertical: 6.v, horizontal: 2.h),
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
