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
  }

  @override
  Widget build(BuildContext context) {
     var obj = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;

     void _handleAuditory(BuildContext context, int level, String params) async {
    final levelProvider =
        Provider.of<PhonemsLevelOneProvider>(context, listen: false);
    final String type;
    try {
      final Map<String, dynamic>? data =
          await levelProvider.fetchData(obj["exerciseType"], level);
      type = data!["type"];
      if (type == "video") {
        bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(videoUrl: data["video"])),
        );
        if (params != "completed") {
          await levelProvider.incrementLevelCount("auditory");
        }
        if (result) {
          debugPrint("set state is called for rebuilding the widget for ady");
          String origin = val == 0 ? "Auditory" : "Quizes";
          await _fetchCurrentLevel(origin);
        }
      }
    } catch (e) {}
  }

     void _handleLevel(BuildContext context, int level, String params) async {
  
    try {
      debugPrint("entering in level section");
      final levelProvider =
          Provider.of<PhonemsLevelOneProvider>(context, listen: false);
      final String type;
      debugPrint("data fetching");
      final Map<String, dynamic>? data =
          await levelProvider.fetchData(obj["exerciseType"], level);
      type = data!["type"];
      if (type == "video") {
        debugPrint("in video setion");
        bool result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoUrl: data["video"]),
          ),
        );
        if (params != "completed") {
          await levelProvider.incrementLevelCount("Quizes");
        }
        if (result) {
          debugPrint("set state is called for rebuilding the widget");
          String origin = val == 0 ? "Auditory" : "Quizes";
          await _fetchCurrentLevel(origin);
        }
      } else if (type == "speech") {
        debugPrint("in speech section");
        bool result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeakingPhonemeScreen(
              text: (data["text"] as List)
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList(),
              videoUrl: data["video_url"],
              testSpeech: data["test_speech"],
            ),
          ),
        );
        if (params != "completed") {
          await levelProvider.incrementLevelCount("SpeechTests");
        }
        if (result) {
          debugPrint("set state is called for rebuilding the widget");
          String origin = val == 0 ? "Auditory" : "SpeechTests";
          await _fetchCurrentLevel(origin);
        }
      } else {
        final Object dtcontainer;
        dtcontainer = retrieveObject(type, data);

        debugPrint("data is ");
        debugPrint(data.toString());
        List<dynamic> lis = [type, dtcontainer, params];
        print("lis is $lis");

        bool result = await NavigatorService.pushNamed(AppRoutes.identification,
            arguments: lis);

        if (result) {
          debugPrint("set state is called for rebuilding the widget");
          String origin = val == 0 ? "Auditory" : "Quizes";
          await _fetchCurrentLevel(origin);
        }
      }
    } catch (e) {
      debugPrint("catch section");
    }
  }

   
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
              levelCount: obj["numberOfLevels"],
              currentLevel: currentLevelCount, // provider.level!.toDouble(),
              enableVariationBetweenCurves: true,
              pathColor: appTheme.amber90001,
              shadowColor: appTheme.brown100,
              currentLevelImage: ImageParams(
                path: "assets/images/Current_LVL.png",
                size: Size(104.v, 104.h),
                onTap: (int level) {
                  print("val is $val");
                  // taking level count from here and everything will be handled in AuditoryScreen class
                  if (val == 0) {
                    debugPrint("auditory");
                    _handleAuditory(context, level, "notcompleted");
                  } else if (val == 1) {
                    debugPrint("in quizes level");
                    _handleLevel(context, level, "notcompleted");
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Center(
                                  child: Text("data"),
                                )));
                  }
                },
              ),
              lockedLevelImage: ImageParams(
                path: "assets/images/Locked_LVL.png",
                size: Size(104.v, 104.h),
                onTap: (int level) {
                  // taking level count from here and everything will be handled in AuditoryScreen class
                  if (val == 0) {
                    debugPrint("auditory");
                    _handleAuditory(context, level, "completed");
                  } else if (val == 1) {
                    debugPrint("in quizes level");
                    _handleLevel(context, level, "completed");
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Center(
                                  child: Text("data"),
                                )));
                  }
                },
              ),
              completedLevelImage: ImageParams(
                path: "assets/images/Complete_LVL.png",
                size: Size(104.v, 104.h),
                onTap: (int level) {
                  if (val == 0) {
                    _handleAuditory(context, level, "completed");
                  } else if (val == 1) {
                    _handleLevel(context, level, "completed");
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Text("data")));
                  }
                },
              ),
              dashLengthFactor: 0.01,
              pathStrokeWidth: 10.h,
              bgImagesToBePaintedRandomly: [
                ImageParams(
                    path: "assets/images/img_bush.png",
                    size: Size(80, 80),
                    repeatCountPerLevel: 0.5),
                ImageParams(
                  path: "assets/images/img_tree.png",
                  size: Size(80, 80),
                  repeatCountPerLevel: 0.5,
                )
              ],
            ),
          ),
        ),
      ),
    );

  
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
