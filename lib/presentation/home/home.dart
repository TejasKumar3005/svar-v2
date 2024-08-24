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
              child: Container(
                width: 400.h,
                height: 250
                    .v, // Ensure the height and width are set to make the container rectangular
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusStyle
                      .roundedBorder20, // Adjust if you need rounded corners
                  image: DecorationImage(
                    image: AssetImage(ImageConstant.thumbnailBarakhadi),
                    fit: BoxFit
                        .contain, // Ensure the image is contained within the box
                  ),
                ),
                child: Center(
                  child: _currentIndex == 0
                      ? GestureDetector(
                          onTap: () {
                            NavigatorService.pushNamed(
                              AppRoutes.phonmesListScreen,
                            );
                          },
                          child: Container(
                            height: 101
                                .adaptSize, // Adjust these sizes to match the image
                            width: 101.adaptSize,
                            padding: EdgeInsets.all(20.h),
                            decoration: BoxDecoration(
                              color: AppDecoration.fillDeepOrange.color,
                              shape: BoxShape
                                  .circle, // Keep this circular if the play button needs to be circular
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
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
                      : Container(color: Colors.transparent),
                ),
              ),
            ),
            ClipRect(
              child: Container(
                width: 400.h,
                height: 250
                    .v, // Ensure the height and width are set to make the container rectangular
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusStyle
                      .roundedBorder20, // Adjust if you need rounded corners
                  image: DecorationImage(
                    image: AssetImage(ImageConstant.thumbnailPhonemes),
                    fit: BoxFit
                        .contain, // Ensure the image is contained within the box
                  ),
                ),
                child: Center(
                  child: _currentIndex == 1
                      ? GestureDetector(
                          onTap: () {
                            NavigatorService.pushNamed(
                              AppRoutes.phonmesListScreen,
                            );
                          },
                          child: Container(
                            height: 101
                                .adaptSize, // Adjust these sizes to match the image
                            width: 101.adaptSize,
                            padding: EdgeInsets.all(20.h),
                            decoration: BoxDecoration(
                              color: AppDecoration.fillDeepOrange.color,
                              shape: BoxShape
                                  .circle, // Keep this circular if the play button needs to be circular
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
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
                      : Container(color: Colors.transparent),
                ),
              ),
            ),
            ClipRect(
              child: Container(
                width: 400.h,
                height: 250
                    .v, // Ensure the height and width are set to make the container rectangular
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusStyle
                      .roundedBorder20, // Adjust if you need rounded corners
                  image: DecorationImage(
                    image: AssetImage(ImageConstant.imgDetection),
                    fit: BoxFit
                        .contain, // Ensure the image is contained within the box
                  ),
                ),
                child: Center(
                  child: _currentIndex == 2
                      ? GestureDetector(
                          onTap: () {
                            NavigatorService.pushNamed(
                              AppRoutes.phonemsLevelScreenOneScreen,
                            );
                          },
                          child: Container(
                            height: 101
                                .adaptSize, // Adjust these sizes to match the image
                            width: 101.adaptSize,
                            padding: EdgeInsets.all(20.h),
                            decoration: BoxDecoration(
                              color: AppDecoration.fillDeepOrange.color,
                              shape: BoxShape
                                  .circle, // Keep this circular if the play button needs to be circular
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
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
                      : Container(color: Colors.transparent),
                ),
              ),
            ),
            ClipRect(
              child: Container(
                width: 400.h,
                height: 250
                    .v, // Ensure the height and width are set to make the container rectangular
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusStyle
                      .roundedBorder20, // Adjust if you need rounded corners
                  image: DecorationImage(
                    image: AssetImage(ImageConstant.imgDescription),
                    fit: BoxFit
                        .contain, // Ensure the image is contained within the box
                  ),
                ),
                child: Center(
                  child: _currentIndex == 3
                      ? GestureDetector(
                          onTap: () {
                            NavigatorService.pushNamed(
                              AppRoutes.phonemsLevelScreenOneScreen,
                            );
                          },
                          child: Container(
                            height: 101
                                .adaptSize, // Adjust these sizes to match the image
                            width: 101.adaptSize,
                            padding: EdgeInsets.all(20.h),
                            decoration: BoxDecoration(
                              color: AppDecoration.fillDeepOrange.color,
                              shape: BoxShape
                                  .circle, // Keep this circular if the play button needs to be circular
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
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
                      : Container(color: Colors.transparent),
                ),
              ),
            ),
            ClipRect(
              child: Container(
                width: 400.h,
                height: 250
                    .v, // Ensure the height and width are set to make the container rectangular
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusStyle
                      .roundedBorder20, // Adjust if you need rounded corners
                  image: DecorationImage(
                    image: AssetImage(ImageConstant.imgIdentification),
                    fit: BoxFit
                        .contain, // Ensure the image is contained within the box
                  ),
                ),
                child: Center(
                  child: _currentIndex == 4
                      ? GestureDetector(
                          onTap: () {
                            NavigatorService.pushNamed(
                              AppRoutes.phonemsLevelScreenOneScreen,
                            );
                          },
                          child: Container(
                            height: 101
                                .adaptSize, // Adjust these sizes to match the image
                            width: 101.adaptSize,
                            padding: EdgeInsets.all(20.h),
                            decoration: BoxDecoration(
                              color: AppDecoration.fillDeepOrange.color,
                              shape: BoxShape
                                  .circle, // Keep this circular if the play button needs to be circular
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
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
                      : Container(color: Colors.transparent),
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
