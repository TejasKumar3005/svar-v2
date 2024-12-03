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
  late double currentLevelCount = 3;
  bool _initialized = false;
  int val = 1;
  final GlobalKey _key = GlobalKey();
  double _containerWidth = 0.0;
  double _animationHeight = 0.0;
  ScrollController _scrollController = ScrollController();
  var train;
  double? _previousTrainX;
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMINumber? _currentLevelInput;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _fetchCurrentLevel();
    trackTrainPosition();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _fetchCurrentLevel() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final String uid = user.uid;
        var obj =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        var data = await FirebaseFirestore.instance
            .collection('patients')
            .doc(uid)
            .get();

        if (data.exists) {
          Map<String, dynamic> levelMap =
              data['levelMap'] as Map<String, dynamic>? ?? {};

          var levelData = levelMap[obj?["exerciseType"]];

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
      print("object is $obj");
      if (obj == null) {
        debugPrint("No arguments found on this route.");
        return Container();
      }

      return SafeArea(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              key: _key,
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height * 13.7176,
              child: RiveAnimation.asset(
                'assets/rive/levels.riv',
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

  void tapHandle(rive.RiveEvent event) {
    debugPrint("Event: ${event.name}");
    // Calculate the starting level for the current range of 5 levels
    int startLevel = (currentLevelCount ~/ 5) * 5 +
        1; // This will give the start of the current range (e.g., 16 for currentLevel = 17)
    int endLevel = startLevel +
        4; // End of the current range (e.g., 20 for currentLevel = 17)
    print("Start level: $startLevel, End level: $endLevel");
    // Map the current level range to the 5 animation levels (level 1 to level 5)
    if (event.name == "level 1") {
      _handleLevelType(startLevel, "notcompleted");
    } else if (event.name == "level 2") {
      _handleLevelType(startLevel + 1, "notcompleted");
    } else if (event.name == "level 3") {
      // _handleLevelType(startLevel + 2, "notcompleted");
      _currentLevelInput!.change(3);
    } else if (event.name == "level 4") {
      // _handleLevelType(startLevel + 3, "notcompleted");
      _currentLevelInput!.change(4);
    } else if (event.name == "level 5") {
      // _handleLevelType(startLevel + 4, "notcompleted");
      _currentLevelInput!.change(5);
    }
  }

  void _onRiveInit(Artboard artboard) {
    int startLevel = (currentLevelCount ~/ 5) * 5 +
        1; // This will give the start of the current range (e.g., 16 for currentLevel = 17)

    _controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (_controller != null) {
      artboard.addController(_controller!);
      debugPrint("State Machine Controller added.");

      for (int i = 0; i < 5; i++) {
        String level = "level${i + 1}";
        TextValueRun? _levelText = artboard.textRun(level);
        if (_levelText == null) {
          debugPrint("Error: 'Text 2' not found!");
        }
        _levelText?.text = "Level ${startLevel + i}";
      }

      for (int i = 0; i < 5; i++) {
        String level = "desc${i + 1}";
        TextValueRun? _levelText = artboard.textRun(level);
        if (_levelText == null) {
          debugPrint("Error: 'Text 2' not found!");
        }
        _levelText?.text = "desc ${startLevel + i}";
      }

      for (int i = 0; i < 5; i++) {
        String level = "type${i + 1}";
        TextValueRun? _levelText = artboard.textRun(level);
        if (_levelText == null) {
          debugPrint("Error: 'Text 2' not found!");
        }
        _levelText?.text = "type ${startLevel + i}";
      }

      train = artboard.component('train');
      if (train != null) {
        print("train position: ${train.x}");
        // Store the initial value of train.x
        _previousTrainX = train.x;
      } else {
        debugPrint("Error: 'train' not found!");
      }

      _currentLevelInput =
          _controller?.getNumberInput('current level') as SMINumber?;
      if (_currentLevelInput == null) {
        debugPrint("Error: 'current level' input not found!");
      }

      _currentLevelInput!.change(2);
      _controller!.addEventListener(tapHandle);

      // Track changes in train.x
      trackTrainPosition();
    } else {
      debugPrint("Error: State Machine 'State Machine 1' not found.");
    }
  }

  void trackTrainPosition() {
    // You can use a simple loop or a frame callback to track changes continuously
    Future.delayed(Duration(milliseconds: 16), () {
      if (train != null &&
          _previousTrainX != null &&
          train.x != _previousTrainX) {
        // Train position has changed, update the scroll position
        print("New train position: ${train.x}");

        // Ensure that train.x is within the valid scroll range
       double screenWidth = MediaQuery.of(context).size.height*13.7176; // Get the screen width
double maxTrainX = 1000; // Example max value for train.x; replace with your actual maximum value
double scaledOffset = (train.x / maxTrainX) * screenWidth; // Scale train.x proportionally

if (_scrollController.hasClients) {
  // Update scroll position (clamp to valid range if necessary)
  _scrollController.jumpTo(scaledOffset.clamp(0.0, _scrollController.position.maxScrollExtent));
}

_previousTrainX = train.x; // Update the previous value

      // Recursively call trackTrainPosition to keep checking for changes
      trackTrainPosition();
    }
    });
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
}
