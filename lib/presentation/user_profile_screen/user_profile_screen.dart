// import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/game_stats_header.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  _fetchUserData() async {
    // Assuming 'uid' is the user ID, replace with your method to get current user's UID
    String uid = 'BeonEOATC2ZfaNbGaIFJLeNlxy33'; 
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      _nameController.text = userDoc['name'];
      _phoneController.text = userDoc['mobile'];
      _addressController.text = userDoc['address'];
      _emailController.text = userDoc['email'];
    });
  }



  _updateUserData() async {
  String uid =
      'BeonEOATC2ZfaNbGaIFJLeNlxy33'; // Replace with your method to get current user's UID
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'name': _nameController.text,
    'mobile': _phoneController.text,
    'address': _addressController.text,
    'email': _emailController.text,
  });

  // Show a success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Profile updated successfully!')),
  );

  // Navigate to the next screen
  Navigator.pushReplacementNamed(
      context, '/nextScreenRoute'); // Replace with your next screen's route
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
                          height: 400.v,
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                SizedBox(height: 10),
                                TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Student Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _phoneController,
                                        decoration: InputDecoration(
                                          hintText: 'Phone Number',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: _addressController,
                                  decoration: InputDecoration(
                                    hintText: 'Address',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        await _updateUserData();
                                        // Any additional actions after update
                                      },
                                      child: CustomImageView(
                                        imagePath: ImageConstant.imgNextBtn,
                                      ),
                                    ),
                                  ],
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
