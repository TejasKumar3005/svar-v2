import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/presentation/phenoms_level_screen_one/video_player_screen.dart';
import 'provider/phonems_level_screen_one_provider.dart';
import 'package:svar_new/widgets/custom_level_map/level_map.dart';

class PhonemsLevelScreenOneScreen extends StatefulWidget {
  PhonemsLevelScreenOneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  PhonemsLevelScreenOneScreenState createState() =>
      PhonemsLevelScreenOneScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        PhonemsLevelScreenOneProvider();
      },
      child: PhonemsLevelScreenOneScreen(),
    );
  }
}

class PhonemsLevelScreenOneScreenState
    extends State<PhonemsLevelScreenOneScreen> {
  late double currentLevelCount = 1.0;
  bool _initialized = false;
// Add a loading state

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final int args = ModalRoute.of(context)!.settings.arguments as int;
      debugPrint("arguments is $args");
      String origin = args == 0 ? "Auditory" : "Quizes";
      _fetchCurrenLevel(origin);
      _initialized = true; // Ensure this block runs only once
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<PhonemsLevelScreenOneProvider>(context, listen: false);
    final Object? val = ModalRoute.of(context)!.settings.arguments;

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
              levelCount: 21,
              currentLevel: currentLevelCount, // provider.level!.toDouble(),
              enableVariationBetweenCurves: true,
              pathColor: appTheme.amber90001,
              shadowColor: appTheme.brown100,
              currentLevelImage: ImageParams(
                path: "assets/images/Current_LVL.png",
                size: Size(104.v, 104.h),
                onTap: (int level) {
                  // taking level count from here and everything will be handled in AuditoryScreen class
                  if (val == 0) {
                    debugPrint("auditory");
                    _handleAuditory(context, level);
                  } else if (val == 1) {
                    debugPrint("in quizes level");
                    _handleLevel(context, level);
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
                  // if (val as int == 0) {
                  //   debugPrint("auditory");
                  //   _handleAuditory(context, level);
                  // } else if (val == 1) {
                  //   debugPrint("in quizes level");
                  //   _handleLevel(context, level);
                  // } else {
                  //   debugPrint("error zone");
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => Text("data")));
                  // }
                },
              ),
              completedLevelImage: ImageParams(
                path: "assets/images/Complete_LVL.png",
                size: Size(104.v, 104.h),
                onTap: (int level) {
                  if (val == 0) {
                    _handleAuditory(context, level);
                  } else if (val as int == 1) {
                    _handleLevel(context, level);
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

  void _handleLevel(BuildContext context, int level) async {
    try {
      debugPrint("entering in level section");
      final levelProvider =
          Provider.of<PhonemsLevelScreenOneProvider>(context, listen: false);
      final String type;
      debugPrint("data fetching");
      final Map<String, dynamic>? data =
          await levelProvider.fetchData(1, level);
      type = data!["type"];
      if (type == "video") {
        debugPrint("in video setion");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(videoUrl: data["video"])),
        );
        levelProvider.incrementLevelCount("Quizes");
        setState(() {});
      } else {
        final Object dtcontainer;
        dtcontainer = retrieveObject(type, data);
        debugPrint("data is ");
        debugPrint(data.toString());
        List<dynamic> lis = [type, dtcontainer];
        NavigatorService.pushNamed(
            AppRoutes.auditoryScreenAssessmentScreenVisualAudioResizScreen,
            arguments: lis);
        setState(() {});
      }
    } catch (e) {
      debugPrint("catch section");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _handleAuditory(BuildContext context, int level) async {
    final levelProvider =
        Provider.of<PhonemsLevelScreenOneProvider>(context, listen: false);
    final String type;
    try {
      final Map<String, dynamic>? data =
          await levelProvider.fetchData(0, level);
      type = data!["type"];
      if (type == "video") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(videoUrl: data["video"])),
        );
        levelProvider.incrementLevelCount("auditory");
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
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
      debugPrint("in audio to image section ");
      AudioToImage audioToImage = AudioToImage.fromJson(data);
      return audioToImage;
    } else
      return "unexpected value";
  }

  void _fetchCurrenLevel(String origin) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      String screen = origin == "Quizes"
          ? "phoneme_current_level"
          : "auditory_current_level";
      // debugPrint("daa is printitng");
      // debugPrint(user!.uid.toString());

      if (user != null) {
        final String uid = user.uid;
        final data =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        setState(() {
          currentLevelCount = data[screen].toDouble();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
