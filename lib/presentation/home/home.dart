import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:rive/rive.dart' as rive;
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/exercises/exercises_screen.dart';
import 'package:svar_new/presentation/quit_screen/quit_game_screen_dialog.dart';
import 'package:svar_new/providers/userDataProvider.dart';
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
  @override
  Widget build(BuildContext context) {
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
              // Main Content
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Stats Header
                    AppStatsHeader(per: 40),
                    SizedBox(height: 24),
                    // Main Content Area - Side by Side Layout with Different Heights
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final totalFlex = 3; // 3 + 2
                          final maxHeight = constraints.maxHeight;
                          
                          // Calculate heights based on flex ratio
                          final mainCardHeight = (maxHeight * 3 / totalFlex);
                          final phonemesCardHeight = (maxHeight * 2 / totalFlex);
                          
                          return 
                          Padding(padding: EdgeInsets.symmetric(horizontal: 40),
                          child:
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center, // Changed from stretch
                            
                            children: [
                              // Main Exercise Card - Larger
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: mainCardHeight,
                                  child: _buildExerciseCard(
                                    context,
                                    "Let's Practice Today's Exercises!",
                                    ImageConstant.thumbnailPhonemes,
                                    isPrimary: true,
                                    () {
                                      var dataPro = Provider.of<ExerciseProvider>(
                                          context,
                                          listen: false);
                                      if (dataPro.todaysExercises.isNotEmpty) {
                                        NavigatorService.pushNamed(
                                            AppRoutes.exercisesScreen);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('No exercises assigned'),
                                        ));
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 52),
                              // Phonemes Card - Smaller
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: phonemesCardHeight,
                                  child: _buildExerciseCard(
                                    context,
                                    "Practice Phonemes!",
                                    ImageConstant.thumbnailBarakhadi,
                                    isPrimary: false,
                                    () {
                                      NavigatorService.pushNamed(
                                          AppRoutes.phonmesListScreen);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
Widget _buildExerciseCard(
  BuildContext context,
  String title,
  String imagePath,
  VoidCallback onTap, {
  bool isPrimary = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPrimary ? Colors.purple[200]! : Colors.blue[200]!,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isPrimary ? 24 : 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Comic Sans MS',
              color: isPrimary
                  ? Color(0xFF7C3AED) // Purple for main exercise
                  : Color(0xFF3B82F6), // Blue for phonemes
            ),
          ),
          SizedBox(height: isPrimary ? 12 : 9),
          
          Expanded(
            child:Padding(
            padding: EdgeInsets.symmetric(horizontal: isPrimary? 22 :0),
          child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the available aspect ratio
                double availableWidth = constraints.maxWidth;
                double availableHeight = constraints.maxHeight;
                double availableAspectRatio = availableWidth / availableHeight;

                // Assuming the image's natural aspect ratio is close to 16:9
                // Adjust this ratio based on your actual image dimensions
                double targetAspectRatio = 2.0;

                // Calculate padding to maintain equal spacing
                double horizontalPadding = 0;
                double verticalPadding = 0;

                if (availableAspectRatio > targetAspectRatio) {
                  // Available space is wider than needed
                  double targetWidth = availableHeight * targetAspectRatio;
                  horizontalPadding = (availableWidth - targetWidth) / 2;
                  verticalPadding = availableHeight * 0.05; // 10% padding
                  horizontalPadding = verticalPadding; // Make padding equal
                } else {
                  // Available space is taller than needed
                  double targetHeight = availableWidth / targetAspectRatio;
                  verticalPadding = (availableHeight - targetHeight) / 2;
                  horizontalPadding = availableWidth * 0.05; // 10% padding
                  verticalPadding = horizontalPadding; // Make padding equal
                }

                return Container(
                  decoration: BoxDecoration(
                    color: isPrimary ? Colors.purple[50] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          )
        ],
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
