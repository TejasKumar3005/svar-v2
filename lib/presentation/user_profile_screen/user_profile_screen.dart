// import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/game_stats_header.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key})
      : super(
          key: key,
        );

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
  static Widget builder(BuildContext context) {
    return UserProfileScreen();
  }
}

class UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  bool hide = true;
  bool _showPasswordFields = true;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently logged in.')),
        );
        return;
      }

      String uid = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['name'] ?? '';
          _phoneController.text = userDoc['mobile'] ?? '';
          _addressController.text = userDoc['address'] ?? '';
          _emailController.text = userDoc['email'] ?? '';
        });
        print("User data fetched successfully: ${userDoc.data()}");
      } else {
        print("No user data found for the UID: $uid");
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
    }
  }

  Future<void> _updateUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently logged in.')),
        );
        return;
      }

      String uid = user.uid;
      await FirebaseFirestore.instance.collection('patients').doc(uid).update({
        'name': _nameController.text,
        'mobile': _phoneController.text,
        'address': _addressController.text,
        'email': _emailController.text,
      });

      print("User data updated successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pushReplacementNamed(context, '/nextScreenRoute');
    } catch (e) {
      print("Failed to update user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  Future<void> _updatePassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently logged in.')),
        );
        return;
      }

      String uid = user.uid;

      // Fetch the user's stored password from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        String storedPassword =
            userDoc['password']; // Assume the password is stored in this field

        // Compare the entered current password with the stored password
        if (_currentPasswordController.text == storedPassword) {
          // If passwords match, update the password
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(uid)
              .update({
            'password': _newPasswordController.text,
          });

          // Optionally, update the password in Firebase Authentication
          await user.updatePassword(_newPasswordController.text);

          print("User Password updated successfully!");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password updated successfully!')),
          );
        } else {
          // If passwords don't match, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Current password is incorrect.')),
          );
        }
      } else {
        print("User document not found.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User document not found.')),
        );
      }
    } catch (e) {
      print("Failed to update password: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
            horizontal: 5.h,
            vertical: 10.v,
          ),
          decoration: AppDecoration.fillGray.copyWith(
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgProfileBg,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // AppStatsHeader(per: 30),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onTapMascotscreen(context);
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        margin: EdgeInsets.all(0),
                        color: appTheme.whiteA700,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: appTheme.whiteA700,
                            width: 5.h,
                          ),
                          borderRadius: BorderRadiusStyle.roundedBorder15,
                        ),
                        child: Container(
                          height: 320.v,
                          width:
                              (MediaQuery.of(context).size.width - 44.h) * 0.45,
                          decoration: AppDecoration.outlineWhiteA.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder15,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 10),
                                      CustomTextFormField(
                                        controller: _nameController,
                                        hintText: "name".tr,
                                        autofocus: false,
                                        prefix: Icon(
                                          Icons.person,
                                          size: 25,
                                          color: appTheme.orangeA200,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 6.v, horizontal: 2.h),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please enter name";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      CustomTextFormField(
                                        width: 370.h,
                                        controller: _phoneController,
                                        prefix: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: CustomImageView(
                                                imagePath:
                                                    ImageConstant.imgIndia,
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
                                      ),
                                      SizedBox(height: 10),
                                      CustomTextFormField(
                                        controller: _addressController,
                                        prefix: Icon(
                                          Icons.location_on,
                                          size: 25,
                                          color: appTheme.orangeA200,
                                        ),
                                        hintText: "address".tr,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 6.v, horizontal: 2.h),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "err_msg_please_enter_valid_address"
                                                .tr;
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      CustomTextFormField(
                                        controller: _emailController,
                                        hintText: "email".tr,
                                        textInputType:
                                            TextInputType.emailAddress,
                                        prefix: Icon(
                                          size: 25,
                                          Icons.email,
                                          color: appTheme.orangeA200,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 6.v, horizontal: 2.h),
                                      ),
                                      if (_showPasswordFields) ...[
                                        SizedBox(height: 10),
                                        CustomTextFormField(
                                          width: 370.h,
                                          controller:
                                              _currentPasswordController,
                                          suffix: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                hide = !hide;
                                              });
                                            },
                                            child: Icon(
                                              hide
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
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
                                          obscureText: hide,
                                          hintText: "Current Password",
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 6.v, horizontal: 2.h),
                                        ),
                                        SizedBox(height: 10),
                                        CustomTextFormField(
                                          width: 370.h,
                                          controller: _newPasswordController,
                                          suffix: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                hide = !hide;
                                              });
                                            },
                                            child: Icon(
                                              hide
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
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
                                          obscureText: hide,
                                          hintText: "New Password",
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 6.v, horizontal: 2.h),
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await _updatePassword();
                                          },
                                          child: Text('Change Password'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                appTheme.orangeA200,
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 12),
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await _updateUserData();
                                        },
                                        child: Text('Save Changes'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: appTheme.orangeA200,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 44.h) * 0.45,
                      height: 245.v,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.h,
                        vertical: 4.v,
                      ),
                      decoration:
                          AppDecoration.outlineWhiteDeepOrangeA200.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 280.h,
                                height: 149.v,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 7.h,
                                  vertical: 7.v,
                                ),
                                decoration:
                                    AppDecoration.fillDeepOrange10.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: double.maxFinite,
                                      height: 40.v,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.h,
                                        vertical: 2.v,
                                      ),
                                      decoration: AppDecoration
                                          .outlineFilledBlue
                                          .copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder5,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "lbl_your_score".tr,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomTextStyles
                                                .labelMediumGray90002,
                                          ),
                                          SizedBox(height: 2.v),
                                          Container(
                                            height: 15.v,
                                            width: 80.h,
                                            decoration: BoxDecoration(
                                              color: appTheme.gray200,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                3.h,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2.v)
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.maxFinite,
                                      height: 40.v,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.h,
                                        vertical: 2.v,
                                      ),
                                      decoration: AppDecoration
                                          .outlineFilledBlue
                                          .copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder5,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            "lbl_coins_earned".tr,
                                            style: CustomTextStyles
                                                .labelMediumGray90002,
                                          ),
                                          SizedBox(height: 2.v),
                                          Container(
                                            height: 15.v,
                                            width: 80.h,
                                            decoration: BoxDecoration(
                                              color: appTheme.gray200,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                3.h,
                                              ),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "lbl_234".tr,
                                                    style: CustomTextStyles
                                                        .labelMediumGray90002,
                                                  ),
                                                  CustomImageView(
                                                    imagePath:
                                                        ImageConstant.imgCoin,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2.v)
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width:
                                          ((MediaQuery.of(context).size.width -
                                                          44.h) *
                                                      0.45 -
                                                  12.h) *
                                              0.48 *
                                              0.7,
                                      height: 30.v,
                                      decoration: BoxDecoration(
                                        color: appTheme.yellow500,
                                        borderRadius: BorderRadius.circular(
                                          6.h,
                                        ),
                                        border: Border.all(
                                          color: appTheme.whiteA700,
                                          width: 2.h,
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.v),

                          Container(
                            height: 65.v,
                            width: (MediaQuery.of(context).size.width - 44.h) *
                                0.45,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.h,
                              vertical: 4.v,
                            ),
                            decoration: AppDecoration.fillDeepOrange10.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomImageView(
                                  width: ((MediaQuery.of(context).size.width -
                                                  44.h) *
                                              0.45 -
                                          24.h -
                                          30.h) /
                                      3,
                                  height: 55.v,
                                  fit: BoxFit.contain,
                                  imagePath: "assets/images/badge_g.png",
                                ),
                                CustomImageView(
                                  width: ((MediaQuery.of(context).size.width -
                                                  44.h) *
                                              0.45 -
                                          24.h -
                                          30.h) /
                                      3,
                                  height: 55.v,
                                  fit: BoxFit.contain,
                                  imagePath: "assets/images/badge_s.png",
                                ),
                                CustomImageView(
                                  width: ((MediaQuery.of(context).size.width -
                                                  44.h) *
                                              0.45 -
                                          24.h -
                                          30.h) /
                                      3,
                                  height: 55.v,
                                  fit: BoxFit.contain,
                                  imagePath: "assets/images/badge_b.png",
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: 5.v)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 3.v)
            ],
          ),
        ),
      ),
    );
  }

  /// Common widget
  Widget _buildSilverbadge(
    BuildContext context, {
    required String television,
    required String userEleven,
    required String inboxOne,
    required String closeNine,
  }) {
    return SizedBox(
      height: 55.v,
      width: 35.h,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CustomImageView(
            imagePath: television,
            height: 31.v,
            width: 20.h,
            radius: BorderRadius.circular(
              2.h,
            ),
            alignment: Alignment.bottomLeft,
          ),
          CustomImageView(
            imagePath: userEleven,
            height: 31.v,
            width: 20.h,
            radius: BorderRadius.circular(
              2.h,
            ),
            alignment: Alignment.bottomRight,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 32.v,
              width: 30.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomImageView(
                    imagePath: inboxOne,
                    height: 32.v,
                    width: 30.h,
                    alignment: Alignment.center,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 23.v,
                      width: 20.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomImageView(
                            imagePath: closeNine,
                            height: 23.v,
                            width: 20.h,
                            alignment: Alignment.center,
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgStar14,
                            height: 17.v,
                            width: 15.h,
                            radius: BorderRadius.circular(
                              1.h,
                            ),
                            alignment: Alignment.center,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Navigates to the wardrobeScreen when the action is triggered.
  onTapMascotscreen(BuildContext context) {
    // NavigatorService.pushNamed(
    //   // AppRoutes.wardrobeScreen,
    // );
  }
}
