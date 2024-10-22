import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/tutorial_coach_mark/lib/tutorial_coach_mark.dart'; // Import tutorial package

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
  late TutorialCoachMark tutorialCoachMark;
  CarouselSliderController _carouselController = CarouselSliderController();

  // Define GlobalKeys for each carousel item
  GlobalKey keyCarouselItem0 = GlobalKey();
  GlobalKey keyCarouselItem1 = GlobalKey();
  GlobalKey keyCarouselItem2 = GlobalKey();
  GlobalKey keyCarouselItem3 = GlobalKey();
  GlobalKey keyCarouselItem4 = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Set the orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Create the tutorial
    createTutorial();

    // Show the tutorial after layout
    Future.delayed(Duration.zero, showTutorial);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MainInteractionProvider>(context, listen: false);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          // Handle successful pop
          showAboutDialog(context: context);
        } else {
          // Handle canceled pop
          print('Pop was canceled');
        }
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
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
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
            buildCarouselItem(
              context,
              provider,
              "phonmesListScreen",
              ImageConstant.thumbnailBarakhadi,
              0,
              keyCarouselItem0,
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
              keyCarouselItem1,
              () => handleExercise(provider, "Level", context),
            ),
            buildCarouselItem(
              context,
              provider,
              "Detection",
              ImageConstant.imgDetection,
              2,
              keyCarouselItem2,
              () => handleExercise(provider, "Detection", context),
            ),
            buildCarouselItem(
              context,
              provider,
              "Discrimination",
              ImageConstant.imgDiscrimination,
              3,
              keyCarouselItem3,
              () => handleExercise(provider, "Discrimination", context),
            ),
            buildCarouselItem(
              context,
              provider,
              "Identification",
              ImageConstant.imgIdentification,
              4,
              keyCarouselItem4,
              () => handleExercise(provider, "Identification", context),
            ),
          ],
          controller: _carouselController,
          options: CarouselOptions(
            autoPlay: false, // Disable auto play to synchronize with tutorial
            enlargeCenterPage: true,
            enlargeFactor: 0.5,
            viewportFraction: 0.4,
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
    GlobalKey key, // Add GlobalKey parameter
    VoidCallback onTap,
  ) {
    return ClipRect(
      key: key, // Assign key to the item
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.3,
            child: Stack(
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.3,
                ),
                if (_currentIndex == index)
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

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: const Color.fromARGB(0, 251, 251, 251),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
        _carouselController.nextPage(duration: Duration(milliseconds: 800)); // Move to the next carousel item after clicking the tutorial target
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
        _carouselController.nextPage(duration: Duration(milliseconds: 800)); // Move to the next carousel item after clicking the tutorial target
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
        _carouselController.nextPage(duration: Duration(milliseconds: 800)); // Move to the next carousel item after clicking the tutorial overlay
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    targets.add(
      TargetFocus(
        identify: "CarouselItem0",
        keyTarget: keyCarouselItem0,
        contents: [
          TargetContent(
            align: ContentAlign.ontop,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Multiples content",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 222, 14, 14),
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Color.fromARGB(255, 204, 25, 25)),
                  ),
                )
              ],
            ),
          ),
          TargetContent(
              align: ContentAlign.ontop,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Multiples content",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 156, 28, 28),
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Color.fromARGB(255, 227, 14, 14)),
                    ),
                  )
                ],
              ))
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "CarouselItem1",
        keyTarget: keyCarouselItem1,
        contents: [
          TargetContent(
            align: ContentAlign.ontop,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Multiples content",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 198, 28, 28),
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Color.fromARGB(255, 187, 28, 28)),
                  ),
                )
              ],
            ),
          ),
          TargetContent(
              align: ContentAlign.ontop,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Multiples content",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 156, 21, 21),
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Color.fromARGB(255, 194, 25, 25)),
                    ),
                  )
                ],
              ))
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "CarouselItem2",
        keyTarget: keyCarouselItem2,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Multiples content",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          TargetContent(
              align: ContentAlign.top,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Multiples content",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ))
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "CarouselItem3",
        keyTarget: keyCarouselItem3,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Multiples content",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          TargetContent(
              align: ContentAlign.top,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Multiples content",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ))
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "CarouselItem4",
        keyTarget: keyCarouselItem4,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Multiples content",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          TargetContent(
              align: ContentAlign.ontop,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Multiples content",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ))
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    return targets;
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  Future<void> handleExercise(MainInteractionProvider provider,
      String exerciseType, BuildContext context) async {
    debugPrint("Handling exercise: $exerciseType");
    provider.setScreenInfo(exerciseType);

    int? levels = await fetchNumberOfLevels(provider.exerciseType ?? "");

    if (levels != null) {
      provider.setNumberOfLevels(levels);
      debugPrint("Exercise Type: \${provider.exerciseType}");
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
      debugPrint("Document found in Auditory collection: \${doc.id}");
    });

    docName = docName.trim();
    debugPrint("Trimmed document name: $docName");

    DocumentSnapshot doc =
        await firestore.collection("Auditory").doc(docName).get();

    if (!doc.exists) {
      debugPrint(
          "Document $docName does not exist in the Auditory collection.");
      return null;
    }

    try {
      if (doc.data() != null && doc.data() is Map<String, dynamic>) {
        Map<String, dynamic> documentData = doc.data() as Map<String, dynamic>;

        if (documentData.containsKey('data') &&
            documentData['data'] is Map<String, dynamic>) {
          Map<String, dynamic> data =
              documentData['data'] as Map<String, dynamic>;

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
          debugPrint(
              "The 'data' field is missing or not in the correct format in document $docName.");
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
