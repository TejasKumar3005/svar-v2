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
                  
                  NavigatorService.pushNamed(
                      AppRoutes.phonmesListScreen,
                    );
                },
                child: Center(
                  // Centering the entire container
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.6, // Increased width for the container
                    height: MediaQuery.of(context).size.width *
                        0.3, // Increased height for the container
                    child: Stack(
                      children: [
                        // Background Image
                        Image.asset(
                          ImageConstant.thumbnailBarakhadi,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.3,
                        ),
                        if (_currentIndex == 0)
                          Center(
                            child: Container(
                              height: 101
                                  .adaptSize, // Increased size of play button container
                              width: 101
                                  .adaptSize, // Increased size of play button container
                              padding: EdgeInsets.all(20.h),
                              decoration: AppDecoration.outlineWhiteA.copyWith(
                                color: AppDecoration.fillDeepOrange.color,
                                borderRadius: BorderRadius.all(
                                  Radius.circular((121.adaptSize) / 2),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                ImageConstant.imgPlayBtn,
                                height: 45
                                    .adaptSize, // Increased size of play button
                                width: 45
                                    .adaptSize, // Increased size of play button
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ClipRect(
              child: GestureDetector(
                onTap: () {
                  provider.setScreenInfo("Words");
                  NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: provider.excerciseType);
                },
                child: Center(
                  // Centering the entire container
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.6, // Increased width for the container
                    height: MediaQuery.of(context).size.width *
                        0.3, // Increased height for the container
                    child: Stack(
                      children: [
                        // Background Image
                        Image.asset(
                          ImageConstant.thumbnailPhonemes,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.3,
                        ),
                        if (_currentIndex == 1)
                          Center(
                            child: Container(
                              height: 101
                                  .adaptSize, // Increased size of play button container
                              width: 101
                                  .adaptSize, // Increased size of play button container
                              padding: EdgeInsets.all(20.h),
                              decoration: AppDecoration.outlineWhiteA.copyWith(
                                color: AppDecoration.fillDeepOrange.color,
                                borderRadius: BorderRadius.all(
                                  Radius.circular((121.adaptSize) / 2),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                ImageConstant.imgPlayBtn,
                                height: 45
                                    .adaptSize, // Increased size of play button
                                width: 45
                                    .adaptSize, // Increased size of play button
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ClipRect(
              child: GestureDetector(
                onTap: () {
                  provider.setScreenInfo("Identification");
                  NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: provider.excerciseType);
                },
                child: Center(
                  // Centering the entire container
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.6, // Increased width for the container
                    height: MediaQuery.of(context).size.width *
                        0.3, // Increased height for the container
                    child: Stack(
                      children: [
                        // Background Image
                        Image.asset(
                          ImageConstant.imgDetection,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.3,
                        ),
                        if (_currentIndex == 2)
                          Center(
                            child: Container(
                              height: 101
                                  .adaptSize, // Increased size of play button container
                              width: 101
                                  .adaptSize, // Increased size of play button container
                              padding: EdgeInsets.all(20.h),
                              decoration: AppDecoration.outlineWhiteA.copyWith(
                                color: AppDecoration.fillDeepOrange.color,
                                borderRadius: BorderRadius.all(
                                  Radius.circular((121.adaptSize) / 2),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                ImageConstant.imgPlayBtn,
                                height: 45
                                    .adaptSize, // Increased size of play button
                                width: 45
                                    .adaptSize, // Increased size of play button
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ClipRect(
              child: GestureDetector(
                onTap: () {
                  provider.setScreenInfo("Detection");
                  NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: provider.excerciseType);
                },
                child: Center(
                  // Centering the entire container
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.6, // Increased width for the container
                    height: MediaQuery.of(context).size.width *
                        0.3, // Increased height for the container
                    child: Stack(
                      children: [
                        // Background Image
                        Image.asset(
                          ImageConstant.imgDescription,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.3,
                        ),
                        if (_currentIndex == 3)
                          Center(
                            child: Container(
                              height: 101
                                  .adaptSize, // Increased size of play button container
                              width: 101
                                  .adaptSize, // Increased size of play button container
                              padding: EdgeInsets.all(20.h),
                              decoration: AppDecoration.outlineWhiteA.copyWith(
                                color: AppDecoration.fillDeepOrange.color,
                                borderRadius: BorderRadius.all(
                                  Radius.circular((121.adaptSize) / 2),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                ImageConstant.imgPlayBtn,
                                height: 45
                                    .adaptSize, // Increased size of play button
                                width: 45
                                    .adaptSize, // Increased size of play button
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ClipRect(
              child: GestureDetector(
                onTap: () {
                  provider.setScreenInfo("Discrimination");
                  NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: provider.excerciseType);
                },
                child: Center(
                  // Centering the entire container
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.6, // Increased width for the container
                    height: MediaQuery.of(context).size.width *
                        0.3, // Increased height for the container
                    child: Stack(
                      children: [
                        // Background Image
                        Image.asset(
                          ImageConstant.imgIdentification,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.3,
                        ),
                        if (_currentIndex == 4)
                          Center(
                            child: Container(
                              height: 101
                                  .adaptSize, // Increased size of play button container
                              width: 101
                                  .adaptSize, // Increased size of play button container
                              padding: EdgeInsets.all(20.h),
                              decoration: AppDecoration.outlineWhiteA.copyWith(
                                color: AppDecoration.fillDeepOrange.color,
                                borderRadius: BorderRadius.all(
                                  Radius.circular((121.adaptSize) / 2),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                ImageConstant.imgPlayBtn,
                                height: 45
                                    .adaptSize, // Increased size of play button
                                width: 45
                                    .adaptSize, // Increased size of play button
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                      ],
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
  
  
}
