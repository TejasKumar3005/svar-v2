import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/presentation/phoneme_level_one/video_player_screen.dart';
import 'provider/level_one_provider.dart';
import 'package:svar_new/widgets/custom_level_map/level_map.dart';
import 'package:svar_new/presentation/speaking_phoneme/speaking_phoneme.dart';
import 'package:svar_new/presentation/Identification_screen/identification.dart';
import 'package:svar_new/presentation/detection/detection.dart';
import 'package:svar_new/presentation/discrimination/discrimination.dart';

class PhonemeLevelOneScreen extends StatefulWidget {
  PhonemeLevelOneScreen({Key? key}) : super(key: key);

  @override
  PhonemeLevelOneScreenState createState() => PhonemeLevelOneScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhonemsLevelOneProvider(),
      child: PhonemeLevelOneScreen(),
    );
  }
}

class PhonemeLevelOneScreenState extends State<PhonemeLevelOneScreen> {
  late double currentLevelCount = 1;
  bool _initialized = false;
  int val = 1;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();

    // Determine and redirect to the respective page after a short delay
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _redirectToRespectivePage();
    });
  }

  // Function to decide which page to redirect to
  void _redirectToRespectivePage() {
    var obj = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    String exerciseType = obj["exerciseType"] as String;

    switch (exerciseType) {
      case "Detection":
        _handleDetection(context, currentLevelCount.toInt(), "notcompleted");
        break;
      case "Discrimination":
        _handleDiscrimination(context, currentLevelCount.toInt(), "notcompleted");
        break;
      case "Identification":
        _handleIdentification(context, currentLevelCount.toInt(), "notcompleted");
        break;
      case "Level":
        _handleLevel(context, currentLevelCount.toInt(), "notcompleted");
        break;
      default:
        debugPrint("Unexpected exercise type");
        break;
    }
  }

  void _handleLevelType(int level, String params) {
  var obj = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  String exerciseType = obj!["exerciseType"] as String;

  switch (exerciseType) {
    case "Detection":
      _handleDetection(context, level, params);
      break;
    case "Discrimination":
      _handleDiscrimination(context, level, params);
      break;
    case "Identification":
      _handleIdentification(context, level, params);
      break;
    case "Level":
      _handleLevel(context, level, params);
      break;
    default:
      debugPrint("Unexpected exercise type");
      break;
  }
}

  // Functions to handle redirection
  void _handleDetection(BuildContext context, int level, String params) async {
    // Fetch data and redirect to DetectionPage
    try {
      final levelProvider = Provider.of<PhonemsLevelOneProvider>(context, listen: false);
      final Map<String, dynamic>? data = await levelProvider.fetchData('Detection', level);
      String type = data!["type"];

      Widget quizWidget = detectionQuiz(type);

      bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detection(quizWidget: quizWidget),
        ),
      );

      if (params != "completed") {
        await levelProvider.incrementLevelCount("Detection");
      }
      if (result) {
        await _fetchCurrentLevel('Detection');
      }
    } catch (e) {
      debugPrint("Error in Detection handling: $e");
    }
  }

 void _handleDiscrimination(BuildContext context, int level, String params) async {
  // Fetch data and redirect to DiscriminationPage
  try {
    final levelProvider = Provider.of<PhonemsLevelOneProvider>(context, listen: false);
    final Map<String, dynamic>? data = await levelProvider.fetchData('Discrimination', level);
    String type = data!["type"];

    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Discrimination(type: type, data: data), // Pass type and data directly
      ),
    );

    if (params != "completed") {
      await levelProvider.incrementLevelCount("Discrimination");
    }
    if (result) {
      await _fetchCurrentLevel('Discrimination');
    }
  } catch (e) {
    debugPrint("Error in Discrimination handling: $e");
  }
}

  

  void _handleIdentification(BuildContext context, int level, String params) async {
    // Fetch data and redirect to IdentificationPage
    try {
      final levelProvider = Provider.of<PhonemsLevelOneProvider>(context, listen: false);
      final Map<String, dynamic>? data = await levelProvider.fetchData('Identification', level);
      String type = data!["type"];

      Widget quizWidget = identificationOptions(type, data);

      bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IdentificationScreen(quizWidget: quizWidget),
        ),
      );

      if (params != "completed") {
        await levelProvider.incrementLevelCount("Identification");
      }
      if (result) {
        await _fetchCurrentLevel('Identification');
      }
    } catch (e) {
      debugPrint("Error in Identification handling: $e");
    }
  }

  void _handleLevel(BuildContext context, int level, String params) async {
    // Fetch data and redirect to Level handling page
    try {
      final levelProvider = Provider.of<PhonemsLevelOneProvider>(context, listen: false);
      final Map<String, dynamic>? data = await levelProvider.fetchData('Level', level);
      String type = data!["type"];

      Widget quizWidget = identificationOptions(type, data);

      bool result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IdentificationPage(quizWidget: quizWidget),
        ),
      );

      if (params != "completed") {
        await levelProvider.incrementLevelCount("Level");
      }
      if (result) {
        await _fetchCurrentLevel('Level');
      }
    } catch (e) {
      debugPrint("Error in Level handling: $e");
    }
  }

 @override
Widget build(BuildContext context) {
   var obj = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

  return SafeArea(
    child: Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.47, 0.06),
            end: Alignment(0.59, 1.61),
            colors: [
              appTheme.lightGreen400,
              appTheme.teal800,
            ],
          ),
        ),
        child: LevelMap(
          levelMapParams: LevelMapParams(
            levelCount: obj!["numberOfLevels"],
            currentLevel: currentLevelCount,
            enableVariationBetweenCurves: true,
            pathColor: appTheme.amber90001,
            shadowColor: appTheme.brown100,
            currentLevelImage: ImageParams(
              path: "assets/images/Current_LVL.png",
              size: Size(104.v, 104.h),
              onTap: (int level) {
                _handleLevelType(level, "notcompleted");
              },
            ),
            lockedLevelImage: ImageParams(
              path: "assets/images/Locked_LVL.png",
              size: Size(104.v, 104.h),
              onTap: (int level) {
                _handleLevelType(level, "completed");
              },
            ),
            completedLevelImage: ImageParams(
              path: "assets/images/Complete_LVL.png",
              size: Size(104.v, 104.h),
              onTap: (int level) {
                _handleLevelType(level, "completed");
              },
            ),
            dashLengthFactor: 0.01,
            pathStrokeWidth: 10.h,
            bgImagesToBePaintedRandomly: [
              ImageParams(
                path: "assets/images/img_bush.png",
                size: Size(80, 80),
                repeatCountPerLevel: 0.5,
              ),
              ImageParams(
                path: "assets/images/img_tree.png",
                size: Size(80, 80),
                repeatCountPerLevel: 0.5,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}

 

 

Object retrieveObject(String type, Map<String, dynamic> data) {
  if (type == "ImageToAudio") {
    ImageToAudio imageToAudio = ImageToAudio.fromJson(data);
    return imageToAudio;
  } else if (type == "WordToFig") {
    WordToFiG wordToFiG = WordToFiG.fromJson(data);
    return wordToFiG;
  } else if (type == "FigToWord") {
    FigToWord figToWord = FigToWord.fromJson(data);
    return figToWord;
  } else if (type == "AudioToImage") {
    debugPrint("in audio to image section");
    AudioToImage audioToImage = AudioToImage.fromJson(data);
    return audioToImage;
  } else if (type == "AudioToAudio") {
    AudioToAudio audioToAudio = AudioToAudio.fromJson(data);
    return audioToAudio;
  } else if (type == "Muted&Unmuted") {
    MutedUnmuted mutedUnmuted = MutedUnmuted.fromJson(data);
    return mutedUnmuted;
  } else if (type == "HalfMuted") {
    HalfMuted halfMuted = HalfMuted.fromJson(data);
    return halfMuted;
  } else if (type == "DiffSounds") {
    DiffSounds diffSounds = DiffSounds.fromJson(data);
    return diffSounds;
  } else if (type == "OddOne") {
    OddOne oddOne = OddOne.fromJson(data);
    return oddOne;
  } else if (type == "DiffHalf") {
    DiffHalf diffHalf = DiffHalf.fromJson(data);
    return diffHalf;
  } else {
    return "unexpected value";
  }
}


  Future<void> _fetchCurrentLevel(String type) async {
  try {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String uid = user.uid;

      // Fetch the current user's document from Firestore
      var data = await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .get();

      if (data.exists) {
        // Get the 'LevelMap' field from the document
        Map<String, dynamic> levelMap = data['LevelMap'] as Map<String, dynamic>? ?? {};

        // Fetch the level for the specified type
        var levelData = levelMap[type] ?? 1; // Default to 1 if the type is not found

        double currentLevel = levelData >= 1 ? levelData.toDouble() : 1.0;

        // Update the state
        setState(() {
          currentLevelCount = currentLevel;
        });
      } else {
        debugPrint("No data found for user $uid.");
      }
    }
  } catch (e) {
    debugPrint("Error in fetching current level");
    debugPrint(e.toString());
  }
}

}
