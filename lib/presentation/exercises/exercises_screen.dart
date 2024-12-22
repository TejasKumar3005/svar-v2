import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/core/app_export.dart';
// import 'package:svar_new/data/models/levelManagementModel/audio.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/exercises/exercise_video.dart';
import 'package:svar_new/presentation/exercises/exercises_speaking_phoneme.dart';
import 'package:svar_new/presentation/speaking_phoneme/speaking_phoneme.dart';
import 'package:svar_new/widgets/rive_preloader.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
  static Widget builder(BuildContext context) {
    return ExercisesScreen();
  }
}

extension _TextExtension on Artboard {
  TextValueRun? textRun(String name) => component<TextValueRun>(name);
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  ScrollController _scrollController = ScrollController();
  StateMachineController? _controller;
  late Future<RiveFile?> _riveFileFuture;
  final GlobalKey _key = GlobalKey();
  Artboard? _riveArtboard;
  var train;
  double? _previousTrainX;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
      _riveFileFuture = RivePreloader()
        .initialize()
        .then((_) => RivePreloader().getRiveFile('assets/rive/levels.riv'));
    trackTrainPosition();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ExerciseProvider>();
    print("provider.todaysExercises");
    print(provider.todaysExercises);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: FutureBuilder<RiveFile?>(
          future: _riveFileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Show loading indicator
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Center(
                  child: Text('Error loading Rive file')); // Handle errors
            } else {
              final riveFile = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                // Use a custom ScrollPhysics for smoother scrolling
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: AnimatedContainer(
                  duration: const Duration(
                      milliseconds: 500), // Adjust animation duration as needed
                  curve: Curves.easeInOut, // Customize animation curve
                  width: MediaQuery.of(context).size.height * 13.7176,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.centerLeft,
                  child: RiveAnimation.direct(
                    riveFile,
                    fit: BoxFit.contain,
                    onInit: _onRiveInit,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _handleLevelType(int startExerciseIndex, String params) {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);

      if (data_pro.todaysExercises.isEmpty) {
        debugPrint("No exercises found for today.");
        return;
      }
      String? exerciseType = data_pro
          .todaysExercises[startExerciseIndex]["exerciseType"];

      if (exerciseType == null) {
        debugPrint("Exercise type is null in the arguments.");
        return;
      }

      switch (exerciseType) {
        case "Detection":
          _handleDetection(context, "notcompleted", startExerciseIndex);
          break;
        case "Discrimination":
          _handleDiscrimination(context, "notcompleted", startExerciseIndex );
          break;
        case "Identification":
          _handleIdentification(context, "notcompleted", startExerciseIndex);
          break;
        case "Level":
          _handleLevel(context, "notcompleted", startExerciseIndex);
          break;
        default:
          debugPrint("Unexpected exercise type: $exerciseType");
          break;
      }
    } catch (e) {
      debugPrint("Error in _handleLevelType: $e");
    }
  }

  void _handleDetection(BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data =
          data_pro.todaysExercises[startExerciseIndex];
      ;

      if (data == null || data.isEmpty) {
        return;
      }

      String? type = data["subtype"];
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
  await Future.delayed(Duration.zero);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseVideo(
              videoUrl: videoUrl,
              onVideoComplete: () {
                UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                    .updateExerciseData(
                      eid: data["eid"],
                      date: data["date"],
                    )
                    .then((value) => print("Exercise data updated"));
              },
            ),
          ),
        );
      } else {
        print("Type is not video");
        print(type);
        print(data);
        // Handle other types
        final Object dtcontainer = retrieveObject(type, data);

        List<dynamic> argumentsList = [
          type,
          dtcontainer,
          params,
          startExerciseIndex,
          data["eid"],
          data["date"]
        ];
        debugPrint("Arguments list is: $argumentsList");

        NavigatorService.pushNamed(AppRoutes.exerciseDetection,
            arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Detection handling: $e");
    }
  }

  void _handleDiscrimination(BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data =
          data_pro.todaysExercises[startExerciseIndex];
      ;

      if (data == null || data.isEmpty) {
        return;
      }

      String? type = data["type"];
      if (type == null) {
        debugPrint("Type is null in the fetched data.");
        return;
      }

      debugPrint("Fetched type for Identification: $type");
      debugPrint("Data is: $data");
  await Future.delayed(Duration.zero);
      if (type == "sound") {
        String? videoUrl = data["video_url"];
        if (videoUrl == null) {
          debugPrint("Video URL is null in the fetched data.");
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseVideo(
              videoUrl: videoUrl,
              onVideoComplete: () {
                UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                    .updateExerciseData(
                      eid: data["eid"],
                      date: data["date"],
                    )
                    .then((value) => print("Exercise data updated"));
              },
            ),
          ),
        );
      } else {
        print("Type is not video");

        final Object dtcontainer = retrieveObject(type, data);

        List<dynamic> argumentsList = [
          type,
          dtcontainer,
          params,
          startExerciseIndex,
          data["eid"],
          data["date"]
        ];
        debugPrint("Arguments list is: $argumentsList");

        // Pass the 'type' and 'data' to the Discrimination widget
        NavigatorService.pushNamed(AppRoutes.exerciseDiscrimination,
            arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Discrimination handling: $e");
    }
  }

  void _handleIdentification(BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data =
            data_pro.todaysExercises[startExerciseIndex];
      ;

      if (data == null || data.isEmpty) {
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

        await Future.delayed(Duration.zero);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseVideo(
              videoUrl: videoUrl,
              onVideoComplete: () {
                  data_pro.incrementLevel();
                UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                    .updateExerciseData(
                      eid: data["eid"],
                      date: data["date"],
                    )
                    .then((value) => print("Exercise data updated"));
              },
            ),
          ),
        );
      } else {
        print("Type is not video");
        print(type);
        print(data);
        // Handle other types
        final Object dtcontainer = retrieveObject(type, data);

        List<dynamic> argumentsList = [
          type,
          dtcontainer,
          params,
          startExerciseIndex,
          data["eid"],
          data["date"]
        ];
        debugPrint("Arguments list is: $argumentsList");
    await Future.delayed(Duration.zero);
        NavigatorService.pushNamed(AppRoutes.exerciseIdentification,
            arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Identification handling: $e");
    }
  }

  void _handleLevel(BuildContext context, String params, int startExerciseIndex) async {
    try {
      debugPrint("Entering in level section");
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data =
            data_pro.todaysExercises[startExerciseIndex];
      ;

      String? type = data["type"];
      if (type == null) {
        debugPrint("Type is null in the fetched data.");
        return;
      }

      debugPrint("Fetched type for Level: $type");
  await Future.delayed(Duration.zero);
      if (type == "video") {
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseVideo(
              videoUrl: data["video"],
              onVideoComplete: () {
              
                  data_pro.incrementLevel();
                
              
                UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                    .updateExerciseData(
                      eid: data["eid"],
                      date: data["date"],
                    )
                    .then((value) => print("Exercise data updated"));
                    
              },
            ),
          ),
        );
      } else if (type == "speech") {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExercisesSpeakingPhoneme(
              text: (data["text"] as List)
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList(),
              videoUrl: data["video_url"],
              testSpeech: data["test_speech"],
              eid: data["eid"],
              date: data["date"],
            ),
          ),
        );
      } else {
        final Object dtcontainer = retrieveObject(type, data);

        List<dynamic> argumentsList = [
          type,
          dtcontainer,
          params,
          startExerciseIndex,
          data["eid"],
          data["date"]
        ];
        debugPrint("Arguments list is: $argumentsList");

        NavigatorService.pushNamed(AppRoutes.exerciseIdentification,
            arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Level handling: $e");
    }
  }

  void tapHandle(RiveEvent event) {
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      int startExerciseIndex =
        (data_pro.currentExerciseIndex ~/ 5) * 5; 
  print("startExerciseIndex: $startExerciseIndex");
    if (event.name == "level 1") {
    
      _handleLevelType(startExerciseIndex, "notcompleted");
    }else if (event.name == "level 2") {
      _handleLevelType(startExerciseIndex+1, "notcompleted");
    }else if (event.name == "level 3") {
      _handleLevelType(startExerciseIndex+2, "notcompleted");
    }else if (event.name == "level 4") {
      _handleLevelType(startExerciseIndex+3, "notcompleted");
    }else if (event.name == "level 5") {
      _handleLevelType(startExerciseIndex+4, "notcompleted");
    }
  }

  void _onRiveInit(Artboard artboard) {
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int exerciseCount = data_pro.todaysExercises.length;
    int startExerciseIndex =
        (data_pro.currentExerciseIndex ~/ 5) * 5; // Calculate starting index
    int endExerciseIndex = startExerciseIndex + 5;
    if (endExerciseIndex > exerciseCount) {
      endExerciseIndex = exerciseCount;
    }
    _controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    if (_controller != null) {
      artboard.addController(_controller!);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (int i = 0; i < 5; i++) {
          int actualIndex = startExerciseIndex +
              i; // Calculate the actual index in todaysExercises
          if (actualIndex >= endExerciseIndex)
            break; // Stop if we've processed all available exercises

          String subtypeKey = "level${i + 1}";
          TextValueRun? textRun_subtype = artboard.textRun(subtypeKey);
          if (textRun_subtype != null) {
            print("type ${actualIndex}: ${data_pro.todaysExercises[actualIndex]['type']}");
            textRun_subtype.text =
                data_pro.todaysExercises[actualIndex]['type'];
          } else {
            debugPrint("Error: '$subtypeKey' text run not found!");
          }

          String descKey = "desc${i + 1}";
          TextValueRun? textRun_desc = artboard.textRun(descKey);
          if (textRun_desc != null) {
            textRun_desc.text =
                data_pro.todaysExercises[actualIndex]['description'].isEmpty
                    ? 'No Description'
                    : data_pro.todaysExercises[actualIndex]['description'];
          } else {
            debugPrint("Error: '$descKey' text run not found!");
          }

          String typeKey = "type${i + 1}";
          TextValueRun? textRun_type = artboard.textRun(typeKey);
          if (textRun_type != null) {
            textRun_type.text =
                data_pro.todaysExercises[actualIndex]['exerciseType']??"Exercise Type";
          } else {
            debugPrint("Error: '$typeKey' text run not found!");
          }
        }

        train = artboard.component('train');
        if (train != null) {
          print("train position: ${train.x}");
          _previousTrainX = train.x;
          trackTrainPosition();
        } else {
          debugPrint("Error: 'train' not found!");
        }

        data_pro.initiliaseSMINumber(
            _controller?.getNumberInput('current level') as SMINumber);
        if (data_pro.currentLevelInput == null) {
          debugPrint("Error: 'current level' input not found!");
        }

        data_pro.changeCurrentLevel(startExerciseIndex.toDouble()+1);
        _controller!.addEventListener(tapHandle);
      });

      trackTrainPosition();
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
        double screenWidth = MediaQuery.of(context).size.height *
            13.7176; // Get the screen width
        double maxTrainX =
            1000; // Example max value for train.x; replace with your actual maximum value
        double scaledOffset =
            (train.x / maxTrainX) * screenWidth; // Scale train.x proportionally

        if (_scrollController.hasClients) {
          // Update scroll position (clamp to valid range if necessary)
          // _scrollController.jumpTo(scaledOffset.clamp(
          //     0.0, _scrollController.position.maxScrollExtent));
        }

        _previousTrainX = train.x; // Update the previous value

        // Recursively call trackTrainPosition to keep checking for changes
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
