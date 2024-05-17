import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/presentation/user_profile_screen/user_profile_provider.dart';
import 'package:svar_new/widgets/game_stats_header.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key})
      : super(
          key: key,
        );

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileProvider(),
      child: UserProfileScreen(),
    );
  }
}

class UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
            horizontal: 10.h,
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
              AppStatsHeader(per: 30),
              
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
                          height: 245.v,
                          width: (MediaQuery.of(context).size.width-44.h )* 0.45,
                          decoration: AppDecoration.outlineWhiteA.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder15,
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: CustomImageView(
                                  fit: BoxFit.cover,
                                  height: 245.v,
                                  width:
                                      (MediaQuery.of(context).size.width-44.h )* 0.4,
                                  imagePath: ImageConstant.imgMascotBGProfile,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: CustomImageView(
                                  fit: BoxFit.contain,
                                  height: 180.v,
                                  width:(MediaQuery.of(context).size.width-44.h )* 0.4 *
                                      0.7,
                                  imagePath: ImageConstant.imgMascot,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width-44.h )* 0.45 ,
                      height: 245.v,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.h,
                        vertical: 4.v,
                      ),
                      decoration: AppDecoration.outlineWhiteDeepOrangeA200.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: ((MediaQuery.of(context).size.width-44.h )* 0.45-12.h) *
                                    0.48,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        width: ((MediaQuery.of(context).size.width-44.h )* 0.45-12.h) *
                                    0.48*0.7,
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
                              Container(
                                width:((MediaQuery.of(context).size.width-44.h )* 0.45-12.h) *
                                    0.48,
                                    height: 155.v,
                                  
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildScoreBar(),
                                    
                                    buildScoreBar(),
                                  
                                    buildScoreBar(),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10.v),

                          Container(
                            height: 65.v,
                            width: (MediaQuery.of(context).size.width-44.h ) *
                                    0.45,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.h,
                              vertical: 4.v,
                            ),
                            decoration:
                                AppDecoration.fillDeepOrange10.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder10,
                            ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomImageView(
                                width: ((MediaQuery.of(context).size.width-44.h )*0.45-24.h-30.h)/3,
                                height: 55.v,
                                fit: BoxFit.contain,
                                imagePath: "assets/images/badge_g.png",
                              ),
                              CustomImageView(
                                width: ((MediaQuery.of(context).size.width-44.h )*0.45-24.h-30.h)/3,
                                height: 55.v,
                                fit: BoxFit.contain,
                                imagePath: "assets/images/badge_s.png",
                              ),
                              CustomImageView(
                                width: ((MediaQuery.of(context).size.width-44.h )*0.45-24.h-30.h)/3,
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
  Widget _buildRowgroupthirtyo(
    BuildContext context, {
    required String groupthirtyone,
    required String two,
  }) {
    return Container(
      width: 87.h,
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      decoration: AppDecoration.fillYellow.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72.h,
            margin: EdgeInsets.only(
              top: 2.v,
              bottom: 3.v,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 13.h,
              vertical: 1.v,
            ),
            decoration: AppDecoration.fillDeeporange70002.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder5,
            ),
            child: Text(
              groupthirtyone,
              style: CustomTextStyles.nunitoWhiteA70001Bold.copyWith(
                color: appTheme.whiteA700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 3.h,
              bottom: 1.v,
            ),
            child: Text(
              two,
              style: theme.textTheme.labelMedium!.copyWith(
                color: appTheme.whiteA700,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildScoreBar() {
    return SizedBox(
      height:50.v,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: ((MediaQuery.of(context).size.width-44.h )* 0.45-12.h) *
                                    0.43,
              margin: EdgeInsets.only(
                left: 5.h,
                bottom: 3.v,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 3.h,
                vertical: 2.v,
              ),
              decoration: AppDecoration.outlineWhiteA70001.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder5,
                border: Border.all(width: 2.h,color: appTheme.whiteA700)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "msg_score_multiplier".tr,
                    style: theme.textTheme.labelMedium,
                  ),
                  Text(
                    "msg_increase_duration".tr,
                    style: theme.textTheme.labelSmall!.copyWith(color: appTheme.black900),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        Container(
                          height: 7.13.v,
                          margin: EdgeInsets.only(
                            top: 4.v,
                            bottom: 1.v,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 7.13.v,
                              width: 10.02.h,
                                margin: EdgeInsets.only(left: 2.h),
                                decoration: AppDecoration.outlineBlackYellow.copyWith(borderRadius: BorderRadiusStyle.roundedBorder5),
                              ),
                              Container(
                              height: 7.13.v,
                              width: 10.02.h,
                                  margin: EdgeInsets.only(left: 2.h),
                                decoration: AppDecoration.outlineBlackYellow.copyWith(borderRadius: BorderRadiusStyle.roundedBorder5),
                              ),
                              Container(
                              height: 7.13.v,
                              width: 10.02.h,
                                  margin: EdgeInsets.only(left: 2.h),
                                decoration: AppDecoration.outlineBlackYellow.copyWith(borderRadius: BorderRadiusStyle.roundedBorder5),
                              ),
                              Container(
                              height: 7.13.v,
                              width: 10.02.h,
                                  margin: EdgeInsets.only(left: 2.h),
                                decoration: BoxDecoration(
                                  color: appTheme.brown100,  borderRadius:  BorderRadiusStyle.roundedBorder5
                                ),
                              ),
                              Container(
                                height: 7.13.v,
                              width: 10.02.h,
                                  margin: EdgeInsets.only(left: 2.h),
                                decoration: BoxDecoration(
                                  color: appTheme.brown100,
                                  borderRadius:  BorderRadiusStyle.roundedBorder5
                                ),
                              )
                            
                            ],
                          ),
                              
                        ),SizedBox(width: 8.h,),
                          _buildRowvectorThree(
                                context,
                                zipcode: "5000",
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
          left: -4.h,
          top: 0,
            child: Transform.rotate(
              angle: -20.39 * 3.14/180,
              child: CustomImageView(
                imagePath: ImageConstant.imgStar14,
                height: 45.v,
                width: 40.h,
                fit: BoxFit.contain,
                radius: BorderRadius.circular(
                  1.h,
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildRowvectorThree(
    BuildContext context, {
    required String zipcode,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      decoration: AppDecoration.gradientGreenToLightGreen.copyWith(borderRadius: BorderRadiusStyle.roundedBorder10,border: Border.all(color: appTheme.black900)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgCoin,
            height: 10.v,
            width: 10.h,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: EdgeInsets.only(left: 1.h),
            child: Text(
              zipcode,
              style: CustomTextStyles.nunitoWhiteA70001.copyWith(
                color: appTheme.whiteA700,
              ),
            ),
          )
        ],
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
