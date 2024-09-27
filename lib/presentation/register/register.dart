import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/core/utils/validation_functions.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/localization/app_localization.dart';
import 'package:svar_new/presentation/register/methods.dart';
import 'package:svar_new/presentation/register/provider/register_provider.dart';


import 'package:svar_new/providers/userDataProvider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key})
      : super(
          key: key,
        );

  @override
RegisterScreenState createState() =>
      RegisterScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterProvider(),
      child: RegisterScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class RegisterScreenState
    extends State<RegisterScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneCtrl = TextEditingController();
  List<String> list = <String>["Guardian", "Mother", "Father"];
  String dropdownValue = "Guardian";
  String dropdownValue1="Select Therapist";
  bool hide = true;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    UserData(buildContext: context).getTherapyCenters().then((value) {});
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    final textCtrl = context.watch<RegisterProvider>();
    var provider = context.watch<UserDataProvider>();
    List<String> nameList =["Select Therapist"];
    for (var i = 0; i < provider.therapyCenters.length; i++) {
      nameList.add(provider.therapyCenters[i]['name']);
    }
      

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (textCtrl.loading && _overlayEntry == null) {
        _overlayEntry = createOverlayEntry(context);
        Overlay.of(context).insert(_overlayEntry!);
      } else if (!textCtrl.loading && _overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
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
                                PlayBgm()
                                    .playMusic('Back_Btn.mp3', "mp3", false);
                                Navigator.pop(context);
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.person_2,
                                      color: appTheme.orangeA200,
                                    ),
                                  
                                    Padding(
                                        padding: EdgeInsets.only(
                                        left: 13.h,
                                          top: 3.v,
                                          bottom: 2.v,
                                        ),
                                        child: SizedBox(
                                          height: 40.v,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildEditText(context),
                              Container(
                            
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
                                        padding: EdgeInsets.only(
                                          left: 13.h,
                                          
                                          
                                        ),
                                        child: SizedBox(
                                        
                                          child: DropdownButton<String>(
                                            iconEnabledColor:
                                                PrimaryColors().amber900,
                                            value: dropdownValue1,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            elevation: 16,
                                            style: theme.textTheme.labelLarge,
                                            underline: Container(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                dropdownValue1 = value!;
                                              });
                                            },
                                            items: nameList
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,

                                                  style: TextStyle(
                                                    
                                                      color: PrimaryColors()
                                                          .amber900,
                                                          overflow: TextOverflow.ellipsis,
                                                          ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.v),
                        CustomButton(
                                  type: ButtonType.Next,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate() && dropdownValue1!="Select Therapist") {
                                  await     AnalyticsService().logSignup(textCtrl.emailController.text);
                                      RegisterFormMethods methods =
                                          RegisterFormMethods(context: context);
                                      Map<String, dynamic> result =
                                          provider.therapyCenters.firstWhere(
                                              (json) =>
                                                  json['name'] == dropdownValue1,
                                              orElse: () =>
                                                  {"error": "Name not found"});
                                      
                                      methods.RegisterUser(result["uid"]);
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
    return Selector<RegisterProvider,
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
    return Selector<RegisterProvider,
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
    return Selector<RegisterProvider,
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
    return Selector<RegisterProvider,
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
      child: Selector<RegisterProvider,
          TextEditingController?>(
        selector: (context, provider) => provider.passwordController,
        builder: (context, passwordController, child) {
          return CustomTextFormField(
            width: 150.h,
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
      AppRoutes.home,
    );
  }
}
