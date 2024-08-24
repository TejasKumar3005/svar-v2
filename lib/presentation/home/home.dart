import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart';
import 'package:svar_new/providers/appUpdateProvider.dart';
import 'package:svar_new/widgets/game_stats_header.dart';
import 'provider/main_interaction_provider.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key})
      : super(
          key: key,
        );

  @override
  HomeScreenState createState() => HomeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainInteractionProvider(),
      child: HomeScreen(),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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
  Widget build(BuildContext context) {
    var provider = Provider.of<MainInteractionProvider>(context, listen: false);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showQuitDialog(context);
      },
      child: SafeArea(
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
                  carouselSlider(provider, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget carouselSlider(
      MainInteractionProvider provider, BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.95,
        child: CarouselSlider(
          items: [
            ClipRect(
              child: GestureDetector(
                onTap: () {
                  provider.setScreenInfo(0);
                  NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: provider.val);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,  // Increased width for rectangle
                  height: MediaQuery.of(context).size.height * 0.4,  // Adjusted height
                  decoration: AppDecoration.outlineWhiteA.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                      image: DecorationImage(
                          image: AssetImage(ImageConstant.thumbnailAuditory),
                          fit: BoxFit.fill)),
                  child: _currentIndex == 0
                      ? Center(
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
                        )
                      : Container(
                          color: Colors.transparent,
                        ),
                ),
              ),
            ),
            ClipRect(
              child: GestureDetector(
                onTap: () {
                  NavigatorService.pushNamed(
                    AppRoutes.phonmesListScreen,
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,  // Increased width for rectangle
                  height: MediaQuery.of(context).size.height * 0.4,  // Adjusted height
                  decoration: AppDecoration.gradientRedToWhiteA.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                      image: DecorationImage(
                          image: AssetImage(ImageConstant.thumbnailBarakhadi),
                          fit: BoxFit.fill)),
                  child: Center(
                    child: _currentIndex == 1
                        ? Container(
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
                          )
                        : Container(
                            color: Colors.transparent,
                          ),
                  ),
                ),
              ),
            ),
            ClipRect(
              child: GestureDetector(
                onTap: () {
                  provider.setScreenInfo(1);
                  NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: provider.val);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,  // Increased width for rectangle
                  height: MediaQuery.of(context).size.height * 0.4,  // Adjusted height
                  decoration: AppDecoration.gradientRedToWhiteA.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                      image: DecorationImage(
                          image: AssetImage(ImageConstant.thumbnailPhonemes),
                          fit: BoxFit.fill)),
                  child: Center(
                    child: _currentIndex == 2
                        ? Container(
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
                          )
                        : Container(
                            color: Colors.transparent,
                          ),
                  ),
                ),
              ),
            ),
            ClipRect(
              child: GestureDetector(
                onTap: () {
                  provider.setScreenInfo(1);
                  NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: provider.val);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,  // Increased width for rectangle
                  height: MediaQuery.of(context).size.height * 0.4,  // Adjusted height
                  decoration: AppDecoration.gradientRedToWhiteA.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                      image: DecorationImage(
                          image: AssetImage(ImageConstant.imgDetection),
                          fit: BoxFit.fill)),
                  child: Center(
                    child: _currentIndex == 3
                        ? Container(
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
                          )
                        : Container(
                            color: Colors.transparent,
                          ),
                  ),
                ),
              ),
            ),
            ClipRect(
              child: GestureDetector(
                onTap: () {
                  provider.setScreenInfo(1);
                  NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: provider.val);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,  // Increased width for rectangle
                  height: MediaQuery.of(context).size.height * 0.4,  // Adjusted height
                  decoration: AppDecoration.gradientRedToWhiteA.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                      image: DecorationImage(
                          image: AssetImage(ImageConstant.imgDescription),
                          fit: BoxFit.fill)),
                  child: Center(
                    child: _currentIndex == 4
                        ? Container(
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
                          )
                        : Container(
                            color: Colors.transparent,
                          ),
                  ),
                ),
              ),
            ),
            ClipRect(
              child: GestureDetector(
                onTap: () {
                  provider.setScreenInfo(1);
                  NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: provider.val);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,  // Increased width for rectangle
                  height: MediaQuery.of(context).size.height * 0.4,  // Adjusted height
                  decoration: AppDecoration.gradientRedToWhiteA.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20,
                      image: DecorationImage(
                          image: AssetImage(ImageConstant.imgIdentification),
                          fit: BoxFit.fill)),
                  child: Center(
                    child: _currentIndex == 5
                        ? Container(
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
                          )
                        : Container(
                            color: Colors.transparent,
                          ),
                  ),
                ),
              ),
            ),
          ],

          //Slider Container properties
          options: CarouselOptions(
            autoPlay: true,
            autoPlayCurve: Curves.decelerate,
            enlargeCenterPage: true,
            enlargeFactor: 0.5,
            viewportFraction: 0.4,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
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
