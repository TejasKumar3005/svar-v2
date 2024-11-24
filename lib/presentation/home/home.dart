import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:rive/rive.dart' as rive;
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart';
import 'package:svar_new/widgets/game_stats_header.dart';
import 'provider/main_interaction_provider.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
          body: Stack(
            children: [
              // Background Rive animation
              Positioned.fill(
                child: rive.RiveAnimation.asset(
                  'assets/rive/bg2.riv',
                  fit: BoxFit.cover,
                ),
              ),
              // Foreground content
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.v),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.h),
                      child: AppStatsHeader(per: 40),
                    ),
                    Spacer(),
                    carouselSlider(provider, context),
                  ],
                ),
              ),
            ],
          ),
        ),
      )

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
            buildCarouselItem(
              context,
              provider,
              "phonmesListScreen",
              ImageConstant.thumbnailBarakhadi,
              0,
              () {
                NavigatorService.pushNamed(AppRoutes.phonmesListScreen);
              },
            ),
            buildCarouselItem(
              context,
              provider,
              "Level",
              ImageConstant.thumbnailPhonemes,
              1,
              () => handleExercise(provider, "Level", context),
            ),
            buildCarouselItem(
              context,
              provider,
              "Detection",
              ImageConstant.imgDetection,
              2,
              () => handleExercise(provider, "Detection", context),
            ),
            buildCarouselItem(
              context,
              provider,
              "Discrimination",
              ImageConstant.imgDiscrimination,
              3,
              () => handleExercise(provider, "Discrimination", context),
            ),
            buildCarouselItem(
              context,
              provider,
              "Identification",
              ImageConstant.imgIdentification,
              4,
              () => handleExercise(provider, "Identification", context),
            ),
          ],
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

  Widget buildCarouselItem(
    BuildContext context,
    MainInteractionProvider provider,
    String exerciseType,
    String imagePath,
    int index,
    VoidCallback onTap,
  ) {
    return ClipRect(
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.3,
            
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Set the desired corner radius
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.6,
                    // Remove height so it adjusts to the image's aspect ratio
                  ),
                ),


                if (false)
                  Center(
                    child: Container(
                      height: 101.adaptSize,
                      width: 101.adaptSize,
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
                        height: 45.adaptSize,
                        width: 45.adaptSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleExercise(MainInteractionProvider provider,
      String exerciseType, BuildContext context) async {
    debugPrint("Handling exercise: $exerciseType");
    provider.setScreenInfo(exerciseType);

    int? levels = await fetchNumberOfLevels(provider.exerciseType ?? "");

    if (levels != null) {
      provider.setNumberOfLevels(levels);
      debugPrint("Exercise Type: ${provider.exerciseType}");
      debugPrint("Number of Levels: $levels");

      NavigatorService.pushNamed(
        AppRoutes.phonemsLevelScreenOneScreen,
        arguments: {
          'exerciseType': provider.exerciseType,
          'numberOfLevels': levels,
        },
      );
    } else {
      debugPrint("Failed to fetch the number of levels for $exerciseType.");
    }
  }

  Future<int?> fetchNumberOfLevels(String docName) async {
    debugPrint("Fetching number of levels for document: $docName");
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await firestore.collection("Auditory").get();

    querySnapshot.docs.forEach((doc) {
      debugPrint("Document found in Auditory collection: ${doc.id}");
    });

    docName = docName.trim();
    debugPrint("Trimmed document name: $docName");

    DocumentSnapshot doc =
        await firestore.collection("Auditory").doc(docName).get();

    if (!doc.exists) {
      debugPrint("Document $docName does not exist in the Auditory collection.");
      return null;
    }

    try {
      if (doc.data() != null && doc.data() is Map<String, dynamic>) {
        Map<String, dynamic> documentData = doc.data() as Map<String, dynamic>;

        if (documentData.containsKey('data') &&
            documentData['data'] is Map<String, dynamic>) {
          Map<String, dynamic> data = documentData['data'] as Map<String, dynamic>;

          int numberOfLevels = 0;

          data.forEach((key, value) {
            if (key.startsWith('Level') && value is List && value.isNotEmpty) {
              numberOfLevels++;
              debugPrint("Data inside $key: $value");
            }
          });

          debugPrint("Number of levels in $docName: $numberOfLevels");
          return numberOfLevels;
        } else {
          debugPrint("The 'data' field is missing or not in the correct format in document $docName.");
        }
      } else {
        debugPrint("The document does not contain valid data.");
      }
    } catch (e) {
      debugPrint("Error fetching the number of levels: $e");
    }

    return null;
  }
}
