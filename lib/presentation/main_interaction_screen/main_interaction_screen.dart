import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart.dart';
import 'package:svar_new/widgets/custom_icon_button.dart';
import 'package:svar_new/widgets/game_stats_header.dart';
import 'models/main_interaction_model.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'provider/main_interaction_provider.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/widgets/custom_button.dart';


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
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
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
                    horizontal: 10.h,
                  ),
                  child: AppStatsHeader(per: 40),
                ),
                Spacer(),
              
                carouselSlider(context),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget carouselSlider(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.95,
        child: CarouselSlider(
          items: [
            ClipRect(
              child: Container(
                width: 300.h,
                height: 150.v,
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
                        child: SvgPicture.asset(
                          height: 45.adaptSize,
                          width: 45.adaptSize,
                          fit: BoxFit.contain,
                         ImageConstant.imgPlayBtn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 300.h,
              height: 150.v,
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
              width: 300.h,
              height: 150.v,
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
            enlargeFactor: 0.5,
            viewportFraction: 0.4,
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
