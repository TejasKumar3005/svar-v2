import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/exercises/exercise_pronunciation.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/exercises/exercise_video.dart';
import 'package:svar_new/presentation/exercises/exercises_speaking_phoneme.dart';
import 'package:svar_new/widgets/rive_preloader.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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

class _ExercisesScreenState extends State<ExercisesScreen>
    with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  StateMachineController? _controller;
  late Future<RiveFile?> _riveFileFuture;
  late AnimationController _animationController;
  var train;
  double? _previousTrainX;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _animationController.addListener(() {
      if (mounted) {
        _trackTrainPosition();
      }
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
    _riveFileFuture = RivePreloader()
        .initialize()
        .then((_) => RivePreloader().getRiveFile('assets/rive/levels.riv'));
    _trackTrainPosition();
  }

  @override
  void dispose() {
    // Cancel any active timers

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  void _handleLevelType(int startExerciseIndex, String params) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);

      if (data_pro.todaysExercises.isEmpty) {
        debugPrint("No exercises found for today.");
        return;
      }
      String? exerciseType =
          data_pro.todaysExercises[startExerciseIndex]["exerciseType"];

      if (exerciseType == null) {
        debugPrint("Exercise type is null in the arguments.");
        return;
      }

      switch (exerciseType) {
        case "Detection":
          _handleDetection(context, "notcompleted", startExerciseIndex);
          break;
        case "Discrimination":
          _handleDiscrimination(context, "notcompleted", startExerciseIndex);
          break;
        case "Identification":
          _handleIdentification(context, "notcompleted", startExerciseIndex);
          break;
        case "Level":
          _handleLevel(context, "notcompleted", startExerciseIndex);
          break;
        case 'Pronunciation':
          _handlePronunciation(context, "notcompleted", startExerciseIndex);
      }
    } catch (e) {
      debugPrint("Error in _handleLevelType: $e");
    }
  }

  void _handlePronunciation(
      BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

      if (data.isEmpty) {
        return;
      }

      String? type = data["type"];
      if (type == null) {
        debugPrint("Type is null in the fetched data.");
        return;
      }

      debugPrint("Fetched type for Pronunciation: $type");
      debugPrint("Data is: $data");

      final Object dtcontainer = retrieveObject(type, data);

      List<dynamic> argumentsList = [
        type,
        dtcontainer,
        params,
        startExerciseIndex,
        data["eid"],
        data["date"],
        data,
      ];

      debugPrint("Arguments list is: $argumentsList");

      await Future.delayed(Duration.zero);
      NavigatorService.pushNamed(AppRoutes.exercisePronunciation,
          arguments: argumentsList);
    } catch (e) {
      debugPrint("Error in Pronunciation handling: $e");
    }
  }

  void _handleDetection(
      BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
      ;

      if (data.isEmpty) {
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
                data_pro.incrementLevel(startExerciseIndex);
                if (data["completedAt"] == null) {
                  UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateExerciseData(
                        euid: data["uid"],
                        date: data["date"],
                      )
                      .then((value) => print("Exercise data updated"));
                }
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
        print("dtcontainer: $dtcontainer");
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
        NavigatorService.pushNamed(AppRoutes.exerciseDetection,
            arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Detection handling: $e");
    }
  }

  void _handleDiscrimination(
      BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
      ;

      if (data.isEmpty) {
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
                data_pro.incrementLevel(startExerciseIndex);
                if (data["completedAt"] == null) {
                  UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateExerciseData(
                        euid: data["uid"],
                        date: data["date"],
                      )
                      .then((value) => print("Exercise data updated"));
                }
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

  void _handleIdentification(
      BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
      ;

      if (data.isEmpty) {
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
                data_pro.incrementLevel(startExerciseIndex);
                if (data["completedAt"] == null) {
                  UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateExerciseData(
                        euid: data["uid"],
                        date: data["date"],
                      )
                      .then((value) => print("Exercise data updated"));
                }
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
          data["date"],
          data
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

  void _handleLevel(
      BuildContext context, String params, int startExerciseIndex) async {
    try {
      debugPrint("Entering in level section");
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
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
                data_pro.incrementLevel(startExerciseIndex);

                if (data["completedAt"] == null) {
                  UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateExerciseData(
                        euid: data["uid"],
                        date: data["date"],
                      )
                      .then((value) => print("Exercise data updated"));
                }
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
              uid: data["uid"],
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
    int startExerciseIndex = (data_pro.currentExerciseIndex ~/ 5) * 5;
    int currentLevel = data_pro.currentExerciseIndex;
    // Extract level number from event name
    int targetLevel = int.parse(event.name.split(' ')[1]);
    print("targetLevel: $targetLevel");

    print("startExerciseIndex: $startExerciseIndex");

    // Check if the requested level exists in today's exercises
    if (data_pro.todaysExercises.length - 1 <
        startExerciseIndex + targetLevel - 1) {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'On Snap!',
          message: 'No exercises found today',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      return;
    }

    // // Check if trying to access a future level
    // if (targetLevel > currentLevel) {
    //   final snackBar = SnackBar(
    //     /// need to set following properties for best effect of awesome_snackbar_content
    //     elevation: 0,
    //     behavior: SnackBarBehavior.floating,
    //     backgroundColor: Colors.transparent,
    //     content: AwesomeSnackbarContent(
    //       title: 'On Snap!',
    //       message: 'PLease complete the previous levels',

    //       /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
    //       contentType: ContentType.failure,
    //     ),
    //   );
    //   ScaffoldMessenger.of(context)
    //     ..hideCurrentSnackBar()
    //     ..showSnackBar(snackBar);
    //   return;
    // }

    // If all checks pass, handle the level
    _handleLevelType(startExerciseIndex + targetLevel - 1, "notcompleted");
  }

  String formatDate(String date) {
    try {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      List<String> parts = date.split('-');
      if (parts.length >= 3) {
        // parts[0] is year, parts[1] is month, parts[2] is day
        int day = int.parse(parts[2]);
        int month = int.parse(parts[1]);
        return '$day ${months[month - 1]}';
      }
      return 'Invalid Date';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  void _onRiveInit(Artboard artboard) {

    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int exerciseCount = data_pro.todaysExercises.length;
    data_pro.artboard = artboard;
    print("Total exercises to do : ${data_pro.todaysExercises.length}");
    int startExerciseIndex =
        (data_pro.currentExerciseIndex ~/ 5) * 5; // Calculate starting index
    int endExerciseIndex = startExerciseIndex + 4;
    print("startExerciseIndex: $startExerciseIndex");
    print("endExerciseIndex: $endExerciseIndex");
    if (endExerciseIndex > exerciseCount) {
      endExerciseIndex = exerciseCount - 1;
    }
    data_pro.controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    print("Controller: ${data_pro.controller}");  
    print("Artboard: ${data_pro.artboard}");  
    if (data_pro.controller != null) {
      data_pro.artboard!.addController(data_pro.controller!);
      data_pro.artboard!.forEachComponent((component) {
        if (component is TextValueRun) {
          print(
              "Component: ${component.runtimeType} - Name: ${component.name}");
        }
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (int i = 0; i < 5; i++) {
          int actualIndex = startExerciseIndex + i;
          print("actualIndex: $actualIndex");
         
          if (actualIndex >= exerciseCount) {
            break;
          }

          String subtypeKey = "level${i + 1}";
          TextValueRun? textRun_subtype = data_pro.artboard!.textRun(subtypeKey);
          if (textRun_subtype != null) {
            print(
                "type ${actualIndex}: ${data_pro.todaysExercises[actualIndex]['type']}");
            textRun_subtype.text =
                data_pro.todaysExercises[actualIndex]['type'];
          } else {
            debugPrint("Error: '$subtypeKey' text run not found!");
          }

          String descKey = "desc${i + 1}";
          TextValueRun? textRun_desc =data_pro.artboard!.textRun(descKey);
          if (textRun_desc != null) {
            textRun_desc.text =
                data_pro.todaysExercises[actualIndex]['description'] == null
                    ? 'No Description'
                    : data_pro.todaysExercises[actualIndex]['description'];
          } else {
            debugPrint("Error: '$descKey' text run not found!");
          }

          String typeKey = "type${i + 1}";
          TextValueRun? textRun_type = data_pro.artboard!.textRun(typeKey);
          if (textRun_type != null) {
            String dateStr =
                data_pro.todaysExercises[actualIndex]['date'] ?? 'No Date';
            if (dateStr != 'No Date') {
              dateStr = formatDate(dateStr);
            }
            textRun_type.text = dateStr;
          } else {
            debugPrint("Error: '$typeKey' text run not found!");
          }
        }

        train = data_pro.artboard!.component('train');

        if (train != null) {
          print("train position: ${train.x}");

          _previousTrainX = train.x;
        } else {
          debugPrint("Error: 'train' not found!");
        }

        data_pro.initializeSMINumber(
            data_pro.controller?.getNumberInput('current level') as SMINumber);
            
        if (data_pro.currentLevelInput == null) {
          debugPrint("Error: 'current level' input not found!");
        }

        print("current level: ${data_pro.currentExerciseIndex}");
        if (data_pro.currentExerciseIndex == 5) {
          data_pro.changeCurrentLevel(1);
          data_pro.controller!.addEventListener(tapHandle);
          return;
        }
        data_pro
            .changeCurrentLevel((data_pro.currentExerciseIndex.toDouble()%5 + 1));
        data_pro.controller!.addEventListener(tapHandle);
      });
    }
    else{
      print("Controller is null");
    }
  }

  void _trackTrainPosition() {
    if (train != null && train.artboard != null) {
      double trainX = train.x;

      if (_previousTrainX != trainX) {
        double screenWidth = MediaQuery.of(context).size.height * 13.7176;
        double maxTrainX = train.artboard!.width;
        double scaledOffset = (trainX / maxTrainX) * screenWidth;

        if (_scrollController.hasClients) {
          // Calculate the distance and use it to adjust animation duration
          double deltaX = (trainX - _previousTrainX!).abs();
          int animationDuration = (deltaX * 10).toInt().clamp(50, 200);

          _scrollController.animateTo(
            scaledOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: Duration(milliseconds: animationDuration),
            curve: Curves.easeOut, // Use a smoother curve
          );
        }
        _previousTrainX = trainX;
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
}
