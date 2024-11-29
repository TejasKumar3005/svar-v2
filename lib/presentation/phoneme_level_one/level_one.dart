import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/presentation/phoneme_level_one/video_player_screen.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'provider/level_one_provider.dart';
import 'package:svar_new/widgets/custom_level_map/level_map.dart';
import 'package:svar_new/presentation/speaking_phoneme/speaking_phoneme.dart';
import 'package:svar_new/presentation/Identification_screen/identification.dart';
import 'package:svar_new/presentation/detection/detection.dart';
import 'package:svar_new/presentation/discrimination/discrimination.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive/rive.dart' hide LinearGradient;

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

extension _TextExtension on rive.Artboard {
  TextValueRun? textRun(String name) => component<TextValueRun>(name);
}

class PhonemeLevelOneScreenState extends State<PhonemeLevelOneScreen> {
  late double currentLevelCount = 1;
  bool _initialized = false;
  int val = 1;
  final GlobalKey _key = GlobalKey();
  double _containerWidth = 0.0;
  double _animationHeight = 0.0;
  Timer? _timer;


  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
     _startPeriodicFetch();
  }
 
  void _startPeriodicFetch() {
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      _fetchCurrentLevel("Identification");
    });
  }
 

  void _handleLevelType(int level, String params) {
    try {
      var obj =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (obj == null) {
        debugPrint("No arguments were passed to this route.");
        return;
      }

      debugPrint("Handling level type with arguments: $obj");
      String? exerciseType = obj["exerciseType"] as String?;

      if (exerciseType == null) {
        debugPrint("Exercise type is null in the arguments.");
        return;
      }

      switch (exerciseType) {
        case "Detection":
          _handleDetection(context, level, "notcompleted");
          break;
        case "Discrimination":
          _handleDiscrimination(context, level, "notcompleted");
          break;
        case "Identification":
          _handleIdentification(context, level, "notcompleted");
          break;
        case "Level":
          _handleLevel(context, level, "notcompleted");
          break;
        default:
          debugPrint("Unexpected exercise type: $exerciseType");
          break;
      }
    } catch (e) {
      debugPrint("Error in _handleLevelType: $e");
    }
  }

  void _handleDetection(BuildContext context, int level, String params) async {
    try {
      debugPrint("Handling Detection for level: $level");
      final levelProvider =
          Provider.of<PhonemsLevelOneProvider>(context, listen: false);

      final Map<String, dynamic>? data =
          await levelProvider.fetchData('Detection', level);

      if (data == null) {
        debugPrint("No data fetched for Detection at level $level.");
        return;
      }

      String? type = data["type"];
      if (type == null) {
        debugPrint("Type is null in the fetched data.");
        return;
      }

      debugPrint("Fetched type for Detection: $type");

      if (type == "video") {
        String? videoUrl = data["video_url"];
        if (videoUrl == null) {
          debugPrint("Video URL is null in the fetched data.");
          return;
        }

        debugPrint("Navigating to Video Player Screen with URL: $videoUrl");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
          ),
        );
      } else {
        print("Type is not video");
        print(type);
        print(data);
        // Handle other types
        final Object dtcontainer = retrieveObject(type, data);

        List<dynamic> argumentsList = [type, dtcontainer, params];
        debugPrint("Arguments list is: $argumentsList");

        NavigatorService.pushNamed(AppRoutes.detection,
            arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Detection handling: $e");
    }
  }

  void _handleDiscrimination(
      BuildContext context, int level, String params) async {
    try {
      final levelProvider =
          Provider.of<PhonemsLevelOneProvider>(context, listen: false);
      final Map<String, dynamic>? data =
          await levelProvider.fetchData('Discrimination', level);

      if (data == null) {
        debugPrint("No data fetched for Discrimination at level $level.");
        return;
      }

      String? type = data["type"];
      if (type == null) {
        debugPrint("Type is null in the fetched data.");
        return;
      }

      debugPrint("Fetched type for Identification: $type");
      debugPrint("Data is: $data");

      if (type == "sound") {
        String? videoUrl = data["video_url"];
        if (videoUrl == null) {
          debugPrint("Video URL is null in the fetched data.");
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
          ),
        );
      } else {
        print("Type is not video");

        final Object dtcontainer = retrieveObject(type, data);

        List<dynamic> argumentsList = [type, data, dtcontainer, params, level];
        debugPrint("Arguments list is: $argumentsList");

        // Pass the 'type' and 'data' to the Discrimination widget
        NavigatorService.pushNamed(AppRoutes.discrimination,
            arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Discrimination handling: $e");
    }
  }

  void _handleIdentification(
      BuildContext context, int level, String params) async {
    try {
      final levelProvider =
          Provider.of<PhonemsLevelOneProvider>(context, listen: false);
      final Map<String, dynamic>? data =
          await levelProvider.fetchData('Identification', level);

      if (data == null) {
        debugPrint("No data fetched for Identification at level $level.");
        return;
      }

      String? type = data["type"];
      if (type == null) {
        debugPrint("Type is null in the fetched data.");
        return;
      }

      debugPrint("Fetched type for Identification: $type");
      debugPrint("Data is: $data");

      // Check if the type is 'video' and handle accordingly
      if (type == "video") {
        String? videoUrl = data["video_url"];
        if (videoUrl == null) {
          debugPrint("Video URL is null in the fetched data.");
          return;
        }

        debugPrint("Navigating to Video Player Screen with URL: $videoUrl");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
          ),
        );
      } else {
        print("Type is not video");
        print(type);
        print(data);
        // Handle other types
        final Object dtcontainer = retrieveObject(type, data);

        List<dynamic> argumentsList = [type, dtcontainer, params];
        debugPrint("Arguments list is: $argumentsList");

        NavigatorService.pushNamed(AppRoutes.identification,
            arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Identification handling: $e");
    }
  }

  void _handleLevel(BuildContext context, int level, String params) async {
    try {
      debugPrint("Entering in level section");
      final levelProvider =
          Provider.of<PhonemsLevelOneProvider>(context, listen: false);

      final Map<String, dynamic>? data =
          await levelProvider.fetchData('Level', level);

      if (data == null) {
        debugPrint("No data fetched for Level at level $level.");
        return;
      }

      String? type = data["type"];
      if (type == null) {
        debugPrint("Type is null in the fetched data.");
        return;
      }

      debugPrint("Fetched type for Level: $type");

      if (type == "video") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoUrl: data["video"]),
          ),
        );
      } else if (type == "speech") {
        Navigator.push(
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
      } else {
        final Object dtcontainer = retrieveObject(type, data);

        List<dynamic> argumentsList = [type, dtcontainer, params];
        debugPrint("Arguments list is: $argumentsList");

        NavigatorService.pushNamed(AppRoutes.identification,
            arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Level handling: $e");
    }
  }

  Future<void> _fetchCurrentLevel(String type) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String uid = user.uid;

        var data = await FirebaseFirestore.instance
            .collection('patients')
            .doc(uid)
            .get();

        if (data.exists) {
          Map<String, dynamic> levelMap =
              data['levelMap'] as Map<String, dynamic>? ?? {};
          var levelData = levelMap[type] ?? 1;

          double currentLevel = levelData >= 1 ? levelData.toDouble() : 1.0;

          if (currentLevelCount != currentLevel) {
            setState(() {
              currentLevelCount = currentLevel;
            });
            _currentLevelInput!.change(currentLevelCount);

            print("level changed to $currentLevel");
          }
        } else {
          debugPrint("No data found for user $uid.");
        }
      }
    } catch (e) {
      debugPrint("Error in fetching current level");
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      var obj =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (obj == null) {
        debugPrint("No arguments found on this route.");
        return Container();
      }

      return SafeArea(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              key: _key,
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 8,
              child: RiveAnimation.asset(
                'assets/rive/LEVEL_ANIMATION.riv',
                fit: BoxFit.contain,
                onInit: _onRiveInit,
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error in building the widget: $e");
      return Container();
    }
  }

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMINumber? _currentLevelInput;

  void tapHandle(rive.RiveEvent event) {
    debugPrint("Tapped on the Rive animation.");
    debugPrint("Event: ${event.name}");
    if (event.name == "level 2") {
      _currentLevelInput!.change(2);
    }
    if (event.name == "level 3") {
       _currentLevelInput!.change(3);
    }
    if (event.name == "level 4") {
      _handleLevelType(4, "notcompleted");
    }
    if (event.name == "level 5") {
      _handleLevelType(5, "notcompleted");
    }
  }

  void _onRiveInit(Artboard artboard) {
    _controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (_controller != null) {
      artboard.addController(_controller!);
      debugPrint("State Machine Controller added.");

      TextValueRun? _levelText = artboard.textRun('LEVEL 1');
      if (_levelText == null) {
        debugPrint("Error: 'Text 2' not found!");
      }
      _levelText?.text = "level_text_changed";
      _currentLevelInput =
          _controller?.getNumberInput('current level') as SMINumber?;
      if (_currentLevelInput == null) {
        debugPrint("Error: 'current level' input not found!");
      }
      _currentLevelInput!.change(currentLevelCount);

      _controller!.addEventListener(tapHandle);
    } else {
      debugPrint("Error: State Machine 'State Machine 1' not found.");
    }
  }
}

Object retrieveObject(String type, Map<String, dynamic> data) {
  if (type == "ImageToAudio") {
    print("In Image to audio section");
    print(ImageToAudio.fromJson(data));
    return ImageToAudio.fromJson(data);
  } else if (type == "WordToFig") {
    return WordToFiG.fromJson(data);
  } else if (type == "FigToWord") {
    return FigToWord.fromJson(data);
  } else if (type == "AudioToImage") {
    debugPrint("In audio to image section");
    return AudioToImage.fromJson(data);
  } else if (type == "AudioToAudio") {
    return AudioToAudio.fromJson(data);
  } else if (type == "MutedUnmuted") {
    return MutedUnmuted.fromJson(data);
  } else if (type == "HalfMuted") {
    return HalfMuted.fromJson(data);
  } else if (type == "DiffSounds") {
    return DiffSounds.fromJson(data);
  } else if (type == "OddOne") {
    return OddOne.fromJson(data);
  } else if (type == "DiffHalf") {
    return DiffHalf.fromJson(data);
  } else if (type == "MaleFemale") {
    return MaleFemale.fromJson(data);
  } else {
    return "unexpected value";
  }
}
