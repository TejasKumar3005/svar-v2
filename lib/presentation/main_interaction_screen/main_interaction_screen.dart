import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:svar_new/widgets/game_stats_header.dart';
import 'models/main_interaction_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/main_interaction_provider.dart';
import 'package:flutter/services.dart';

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

    // Set the orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Reset the orientation when the screen is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgMainInteraction,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.v),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.h,
                  ),
                  child: AppStatsHeader(per: 40),
                ),
                Spacer(),
                SizedBox(height: 19.v),
                carouselSlider(context),
              ],
            ),
          ),
        ),
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
                  decoration: AppDecoration.outlineWhiteA.copyWith(
                      color: AppDecoration.fillDeepOrange.color,
                      borderRadius: BorderRadius.all(
                          Radius.circular((101.adaptSize) / 2))),
                  alignment: Alignment.center,
                  onTap: () {
                    onTapBtnUser(context);
                  },
                  child: Center(
                    child: CustomImageView(
                      imagePath: ImageConstant.imgUserWhiteA70001,
                    ),
                  ),
                ),
              ),
              Container(
                width: 281.h,
                height: 156.v,
                margin: EdgeInsets.only(
                  left: 21.h,
                  top: 11.v,
                  bottom: 11.v,
                ),
                decoration: AppDecoration.gradientRedToWhiteA.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget carouselSlider(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 156.v,
        width: MediaQuery.of(context).size.width * 0.9,
        child: CarouselSlider(
          items: [
            ClipRect(
              child: Container(
                width: 281.h,
                height: 156.v,
                // padding: EdgeInsets.symmetric(vertical: 32.v),
                decoration: AppDecoration.outlineWhiteA.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder20,
                ),
                child: GestureDetector(
                  onTap: () {
                    showQuitDialog(context);
                  },
                  child: Center(
                    child: Container(
                      height: 101.adaptSize,
                      width: 101.adaptSize,
                      padding: EdgeInsets.all(20.h),
                      decoration: AppDecoration.outlineWhiteA.copyWith(
                          color: AppDecoration.fillDeepOrange.color,
                          borderRadius: BorderRadius.all(
                              Radius.circular((101.adaptSize) / 2))),
                      alignment: Alignment.center,
                      child: Center(
                        child: CustomImageView(
                          height: 45.adaptSize,
                          width: 45.adaptSize,
                          fit: BoxFit.contain,
                          imagePath: ImageConstant.imgUserWhiteA70001,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 281.h,
              height: 156.v,
              decoration: AppDecoration.gradientRedToWhiteA.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder20,
              ),
              child: Center(
                child: CustomImageView(
                  height: 108.v,
                  width: 134.h,
                  fit: BoxFit.contain,
                  imagePath: ImageConstant.imgLock,
                ),
              ),
            ),
            Container(
              width: 281.h,
              height: 156.v,
              decoration: AppDecoration.gradientRedToWhiteA.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder20,
              ),
            )
          ],

          //Slider Container properties
          options: CarouselOptions(
            autoPlay: true,
            autoPlayCurve: Curves.decelerate,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            viewportFraction: 0.5,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
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
