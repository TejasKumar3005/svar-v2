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
import 'package:cloud_firestore/cloud_firestore.dart';

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
                onTap: () async {
                  // Set the screen type first
                  provider.setScreenInfo("Detection");

                  // Fetch the number of levels asynchronously
                  int? levels = await fetchNumberOfLevels(
                      provider.exerciseType ??
                          ""); // Ensure exerciseType is not null

                  if (levels != null) {
                    // Set the number of levels in the provider
                    provider.setNumberOfLevels(levels);

                    // Navigate to the next screen with the levels as an argument
                    NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: {
                        'exerciseType': provider.exerciseType,
                        'numberOfLevels': levels,
                      },
                    );
                  } else {
                    // Handle the case when fetching levels fails
                    debugPrint("Failed to fetch the number of levels.");
                  }
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
                onTap: () async {
                  // Set the screen type first
                  provider.setScreenInfo("Level");

                  // Fetch the number of levels asynchronously
                  int? levels = await fetchNumberOfLevels(
                      provider.exerciseType ??
                          ""); // Ensure exerciseType is not null

                  if (levels != null) {
                    // Set the number of levels in the provider
                    provider.setNumberOfLevels(levels);

                    // Navigate to the next screen with the levels as an argument
                    NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: {
                        'exerciseType': provider.exerciseType,
                        'numberOfLevels': levels,
                      },
                    );
                  } else {
                    // Handle the case when fetching levels fails
                    debugPrint("Failed to fetch the number of levels.");
                  }
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
                onTap: () async {
                  // Set the screen type first
                  provider.setScreenInfo("Detection");

                  // Fetch the number of levels asynchronously
                  int? levels = await fetchNumberOfLevels(
                      provider.exerciseType ??
                          ""); // Ensure exerciseType is not null

                  if (levels != null) {
                    // Set the number of levels in the provider
                    provider.setNumberOfLevels(levels);

                    // Navigate to the next screen with the levels as an argument
                    NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: {
                        'exerciseType': provider.exerciseType,
                        'numberOfLevels': levels,
                      },
                    );
                  } else {
                    // Handle the case when fetching levels fails
                    debugPrint("Failed to fetch the number of levels.");
                  }
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
                onTap: () async {
                  // Set the screen type first
                  provider.setScreenInfo("Discrimination");

                  // Fetch the number of levels asynchronously
                  int? levels = await fetchNumberOfLevels(
                      provider.exerciseType ??
                          ""); // Ensure exerciseType is not null

                  if (levels != null) {
                    // Set the number of levels in the provider
                    provider.setNumberOfLevels(levels);

                    // Navigate to the next screen with the levels as an argument
                    NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: {
                        'exerciseType': provider.exerciseType,
                        'numberOfLevels': levels,
                      },
                    );
                  } else {
                    // Handle the case when fetching levels fails
                    debugPrint("Failed to fetch the number of levels.");
                  }
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
                          ImageConstant.imgDiscrimination,
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
                onTap: () async {
                  // Set the screen type first
                  provider.setScreenInfo("Identification");

                  // Fetch the number of levels asynchronously
                  int? levels = await fetchNumberOfLevels(
                      provider.exerciseType ??
                          ""); // Ensure exerciseType is not null

                  if (levels != null) {
                    // Set the number of levels in the provider
                    provider.setNumberOfLevels(levels);

                    // Navigate to the next screen with the levels as an argument
                    NavigatorService.pushNamed(
                      AppRoutes.phonemsLevelScreenOneScreen,
                      arguments: {
                        'exerciseType': provider.exerciseType,
                        'numberOfLevels': levels,
                      },
                    );
                  } else {
                    // Handle the case when fetching levels fails
                    debugPrint("Failed to fetch the number of levels.");
                  }
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

Future<int?> fetchNumberOfLevels(String docName) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Reference the document inside the 'Auditory' collection
  DocumentSnapshot doc =
      await firestore.collection("Auditory").doc(docName).get();

  // Check if the document exists
  if (!doc.exists) {
    debugPrint("Document $docName does not exist in the Auditory collection.");
    return null;
  }

  try {
    // Fetch the 'data' field as a Map
    Map<String, dynamic> data = doc.get("data") as Map<String, dynamic>;

    // Count the number of levels by checking the keys in the 'data' map
    int numberOfLevels =
        data.keys.where((key) => key.startsWith('Level')).length;

    debugPrint("Number of levels in $docName: $numberOfLevels");
    return numberOfLevels;
  } catch (e) {
    debugPrint("Error fetching the number of levels: $e");
    return null;
  }
}
