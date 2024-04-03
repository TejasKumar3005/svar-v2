import 'package:svar_new/widgets/custom_icon_button.dart';
import 'models/main_interaction_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/main_interaction_provider.dart';

class MainInteractionScreen extends StatefulWidget {
  const MainInteractionScreen({Key? key})
      : super(
          key: key,
        );

  @override
  MainInteractionScreenState createState() => MainInteractionScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainInteractionProvider(),
      child: MainInteractionScreen(),
    );
  }
}

class MainInteractionScreenState extends State<MainInteractionScreen> {
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
        body: Container(
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgMainInteraction,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: 768.h,
            padding: EdgeInsets.symmetric(vertical: 47.v),
            child: Column(
              children: [
                _buildAppBar(context),
                Spacer(),
                SizedBox(height: 19.v),
                _buildUser(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 47.h,
        right: 30.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgUserYellow700,
            height: 38.adaptSize,
            width: 38.adaptSize,
            onTap: () {
              onTapImgUser(context);
            },
          ),
          Container(
            height: 31.v,
            width: 198.h,
            margin: EdgeInsets.only(
              left: 5.h,
              bottom: 7.v,
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: 12.v,
                    width: 186.h,
                    margin: EdgeInsets.only(top: 7.v),
                    decoration: AppDecoration.outlineOrangeA700.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder5,
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgBarcode,
                      height: 10.v,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 26.adaptSize,
                    width: 26.adaptSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgStar14,
                          height: 26.adaptSize,
                          width: 26.adaptSize,
                          radius: BorderRadius.circular(
                            1.h,
                          ),
                          alignment: Alignment.center,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "lbl_10".tr,
                            style: CustomTextStyles.nunitoWhiteA70001Black6,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 9.v,
                    width: 78.h,
                    decoration: BoxDecoration(
                      color: appTheme.deepOrange70001,
                      borderRadius: BorderRadius.circular(
                        4.h,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.h),
                    child: Text(
                      "lbl_2500_10000".tr,
                      style: CustomTextStyles.nunitoWhiteA70001Black6,
                    ),
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          Container(
            height: 19.v,
            width: 78.h,
            margin: EdgeInsets.symmetric(vertical: 9.v),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(left: 13.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.h,
                      vertical: 1.v,
                    ),
                    decoration: AppDecoration.fillYellow.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder5,
                    ),
                    child: Container(
                      width: 50.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.h,
                        vertical: 1.v,
                      ),
                      decoration: AppDecoration.fillDeepOrange.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: Text(
                        "lbl_10000_10000".tr,
                        style: CustomTextStyles.nunitoWhiteA70001Bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "lbl2".tr,
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 19.v,
                    width: 17.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 17.v,
                            width: 13.h,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgUserDeepOrange600,
                                  width: 13.h,
                                  alignment: Alignment.center,
                                ),
                                CustomImageView(
                                  imagePath:
                                      ImageConstant.imgSettingsDeepOrange700,
                                  height: 11.v,
                                  alignment: Alignment.bottomCenter,
                                )
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 19.v,
                            width: 16.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomImageView(
                                  imagePath: ImageConstant.imgClose,
                                  width: 16.h,
                                  alignment: Alignment.center,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 16.v,
                                    width: 11.h,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CustomImageView(
                                          imagePath:
                                              ImageConstant.imgCloseYellow90003,
                                          width: 11.h,
                                          alignment: Alignment.center,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "lbl3".tr,
                                            style: CustomTextStyles
                                                .labelMediumYellow500,
                                          ),
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
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 19.v,
            width: 78.h,
            margin: EdgeInsets.only(
              left: 17.h,
              top: 9.v,
              bottom: 9.v,
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(left: 13.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.h,
                      vertical: 1.v,
                    ),
                    decoration: AppDecoration.fillYellow.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder5,
                    ),
                    child: Container(
                      width: 50.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.h,
                        vertical: 1.v,
                      ),
                      decoration: AppDecoration.fillDeeporange70002.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder5,
                      ),
                      child: Text(
                        "lbl_10000_10000".tr,
                        style: CustomTextStyles.nunitoWhiteA70001Bold,
                      ),
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgUserYellow500,
                  width: 17.h,
                  alignment: Alignment.centerLeft,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "lbl2".tr,
                    style: theme.textTheme.labelMedium,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 19.h),
            child: CustomIconButton(
              height: 37.adaptSize,
              width: 37.adaptSize,
              padding: EdgeInsets.all(3.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgCloseWhiteA70001,
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildUser(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 204.h),
        child: IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 178.v,
                width: 361.h,
                padding: EdgeInsets.symmetric(vertical: 32.v),
                decoration: AppDecoration.outlineWhiteA.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder20,
                ),
                child: CustomIconButton(
                  height: 101.adaptSize,
                  width: 101.adaptSize,
                  padding: EdgeInsets.all(20.h),
                  decoration: IconButtonStyleHelper.outlineBlack,
                  alignment: Alignment.center,
                  onTap: () {
                    onTapBtnUser(context);
                  },
                  child: CustomImageView(
                    imagePath: ImageConstant.imgUserWhiteA70001,
                  ),
                ),
              ),
              Container(
                width: 281.h,
                margin: EdgeInsets.only(
                  left: 21.h,
                  top: 11.v,
                  bottom: 11.v,
                ),
                decoration: AppDecoration.gradientRedToWhiteA.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder20,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 156.v,
                      width: 281.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20.h,
                        ),
                        border: Border.all(
                          color: appTheme.whiteA70001,
                          width: 5.h,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment(1, 0.5),
                          end: Alignment(0.35, 0.5),
                          colors: [
                            appTheme.red10001,
                            appTheme.whiteA70001,
                            appTheme.orange5000
                          ],
                        ),
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgLocation,
                      width: 54.h,
                      margin: EdgeInsets.only(
                        left: 518.h,
                        top: 46.v,
                        bottom: 43.v,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onTapImgUser(BuildContext context) {
    // TODO: implement Actions
  }

  /// Navigates to the loadingScreen when the action is triggered.
  onTapBtnUser(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.loadingScreen,
    );
  }
}
