// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:rive/rive.dart';
// import 'package:svar_new/core/app_export.dart';
// import 'package:svar_new/data/models/levelManagementModel/visual.dart';
// import 'package:svar_new/database/userController.dart';
// import 'package:svar_new/presentation/exercises/exercise_pronunciation.dart';
// import 'package:svar_new/presentation/exercises/exercise_provider.dart';
// import 'package:svar_new/presentation/exercises/exercise_video.dart';
// import 'package:svar_new/presentation/exercises/exercises_speaking_phoneme.dart';
// import 'package:svar_new/widgets/rive_preloader.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:svar_new/presentation/discrimination/appbar.dart';
// import 'package:svar_new/presentation/settings_screen/setting.dart';

// class ExercisesScreen extends StatefulWidget {
//   const ExercisesScreen({super.key});

//   @override
//   State<ExercisesScreen> createState() => _ExercisesScreenState();
//   static Widget builder(BuildContext context) {
//     return ExercisesScreen();
//   }
// }

// extension _TextExtension on Artboard {
//   TextValueRun? textRun(String name) => component<TextValueRun>(name);
// }

// class _ExercisesScreenState extends State<ExercisesScreen>
//     with TickerProviderStateMixin {
//   ScrollController _scrollController = ScrollController();
//   StateMachineController? _controller;
//   late Future<RiveFile?> _riveFileFuture;
//   late AnimationController _animationController;
//   var train;
//   double? _previousTrainX;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..repeat();

//     _animationController.addListener(() {
//       if (mounted) {
//         _trackTrainPosition();
//       }
//     });

//     // Changed to portrait orientation
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);

//     _riveFileFuture = RivePreloader()
//         .initialize()
//         .then((_) => RivePreloader().getRiveFile('assets/rive/levels.riv'));
//     _trackTrainPosition();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: Stack(
//         children: [
//           // Rive animation content (first/bottom layer)
//           Positioned(
//             bottom: 0,
//             left: 0,
//             top: 0,
//             right: 0,
//             child: FutureBuilder<RiveFile?>(
//               future: _riveFileFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError || snapshot.data == null) {
//                   return const Center(child: Text('Error loading Rive file'));
//                 } else {
//                   final riveFile = snapshot.data!;

//                   // Change the approach to display the train animation
//                   return SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     controller: _scrollController,
//                     physics: const BouncingScrollPhysics(
//                         parent: AlwaysScrollableScrollPhysics()),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 500),
//                       curve: Curves.easeInOut,
//                       width: MediaQuery.of(context).size.height * 7.716,
//                       height: MediaQuery.of(context).size.height,
//                       alignment: Alignment.bottomCenter,
//                       child: Center(
//                         child: RiveAnimation.direct(
//                           riveFile,
//                           // Use different fit mode to better adapt to portrait
//                           fit: BoxFit.contain,
//                           alignment: Alignment.topCenter,
//                           onInit: _onRiveInit,
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//           // DisciAppBar (last/top layer)
//           Positioned(
//             top: 20,
//             left: 0,
//             right: 0,
//             child: DisciAppBar(context),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleLevelType(int startExerciseIndex, String params) async {
//     try {
//       var data_pro = Provider.of<ExerciseProvider>(context, listen: false);

//       if (data_pro.todaysExercises.isEmpty) {
//         debugPrint("No exercises found for today.");
//         return;
//       }
//       String? exerciseType =
//           data_pro.todaysExercises[startExerciseIndex]["exerciseType"];

//       if (exerciseType == null) {
//         debugPrint("Exercise type is null in the arguments.");
//         return;
//       }

//       switch (exerciseType) {
//         case "Detection":
//           _handleDetection(context, "notcompleted", startExerciseIndex);
//           break;
//         case "Discrimination":
//           _handleDiscrimination(context, "notcompleted", startExerciseIndex);
//           break;
//         case "Identification":
//           _handleIdentification(context, "notcompleted", startExerciseIndex);
//           break;
//         case "Level":
//           _handleLevel(context, "notcompleted", startExerciseIndex);
//           break;
//         case 'Pronunciation':
//           _handlePronunciation(context, "notcompleted", startExerciseIndex);
//           break;
//       }
//     } catch (e) {
//       debugPrint("Error in _handleLevelType: $e");
//     }
//   }

//   void _handlePronunciation(
//       BuildContext context, String params, int startExerciseIndex) async {
//     try {
//       var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
//       Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

//       if (data.isEmpty) {
//         return;
//       }

//       String? type = data["type"];
//       if (type == null) {
//         debugPrint("Type is null in the fetched data.");
//         return;
//       }

//       debugPrint("Fetched type for Pronunciation: $type");
//       debugPrint("Data is: $data");

//       final Object dtcontainer = retrieveObject(type, data);

//       List<dynamic> argumentsList = [
//         type,
//         dtcontainer,
//         params,
//         startExerciseIndex,
//         data["eid"],
//         data["date"],
//         data,
//       ];

//       debugPrint("Arguments list is: $argumentsList");

//       await Future.delayed(Duration.zero);
//       NavigatorService.pushNamed(AppRoutes.exercisePronunciation,
//           arguments: argumentsList);
//     } catch (e) {
//       debugPrint("Error in Pronunciation handling: $e");
//     }
//   }

//   void _handleDetection(
//       BuildContext context, String params, int startExerciseIndex) async {
//     try {
//       var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
//       Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
//       ;

//       if (data.isEmpty) {
//         return;
//       }

//       String? type = data["type"];
//       if (type == null) {
//         debugPrint("Type is null in the fetched data.");
//         return;
//       }

//       debugPrint("Fetched type for Detection: $type");

//       if (type == "video") {
//         String? videoUrl = data["video_url"];
//         if (videoUrl == null) {
//           debugPrint("Video URL is null in the fetched data.");
//           return;
//         }

//         debugPrint("Navigating to Video Player Screen with URL: $videoUrl");
//         await Future.delayed(Duration.zero);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ExerciseVideo(
//               videoUrl: videoUrl,
//               onVideoComplete: () {
//                 data_pro.incrementLevel(startExerciseIndex);
//                 if (data["completedAt"] == null) {
//                   UserData(uid: FirebaseAuth.instance.currentUser!.uid)
//                       .updateExerciseData(
//                         euid: data["uid"],
//                         date: data["date"],
//                       )
//                       .then((value) => print("Exercise data updated"));
//                 }
//               },
//             ),
//           ),
//         );
//       } else {
//         print("Type is not video");
//         print(type);
//         print(data);
//         // Handle other types
//         final Object dtcontainer = retrieveObject(type, data);
//         print("dtcontainer: $dtcontainer");
//         List<dynamic> argumentsList = [
//           type,
//           dtcontainer,
//           params,
//           startExerciseIndex,
//           data["eid"],
//           data["date"]
//         ];
//         debugPrint("Arguments list is: $argumentsList");
//         await Future.delayed(Duration.zero);
//         NavigatorService.pushNamed(AppRoutes.exerciseDetection,
//             arguments: argumentsList);
//       }
//     } catch (e) {
//       debugPrint("Error in Detection handling: $e");
//     }
//   }

//   void _handleDiscrimination(
//       BuildContext context, String params, int startExerciseIndex) async {
//     try {
//       var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
//       Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
//       ;

//       if (data.isEmpty) {
//         return;
//       }

//       String? type = data["type"];
//       if (type == null) {
//         debugPrint("Type is null in the fetched data.");
//         return;
//       }

//       debugPrint("Fetched type for Identification: $type");
//       debugPrint("Data is: $data");
//       await Future.delayed(Duration.zero);
//       if (type == "sound") {
//         String? videoUrl = data["video_url"];
//         if (videoUrl == null) {
//           debugPrint("Video URL is null in the fetched data.");
//           return;
//         }

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ExerciseVideo(
//               videoUrl: videoUrl,
//               onVideoComplete: () {
//                 data_pro.incrementLevel(startExerciseIndex);
//                 if (data["completedAt"] == null) {
//                   UserData(uid: FirebaseAuth.instance.currentUser!.uid)
//                       .updateExerciseData(
//                         euid: data["uid"],
//                         date: data["date"],
//                       )
//                       .then((value) => print("Exercise data updated"));
//                 }
//               },
//             ),
//           ),
//         );
//       } else {
//         print("Type is not video");

//         final Object dtcontainer = retrieveObject(type, data);

//         List<dynamic> argumentsList = [
//           type,
//           dtcontainer,
//           params,
//           startExerciseIndex,
//           data["eid"],
//           data["date"]
//         ];
//         debugPrint("Arguments list is: $argumentsList");

//         // Pass the 'type' and 'data' to the Discrimination widget
//         NavigatorService.pushNamed(AppRoutes.exerciseDiscrimination,
//             arguments: argumentsList);
//       }
//     } catch (e) {
//       debugPrint("Error in Discrimination handling: $e");
//     }
//   }

//   void _handleIdentification(
//       BuildContext context, String params, int startExerciseIndex) async {
//     try {
//       var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
//       Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
//       ;

//       if (data.isEmpty) {
//         return;
//       }

//       String? type = data["type"];
//       if (type == null) {
//         debugPrint("Type is null in the fetched data.");
//         return;
//       }

//       debugPrint("Fetched type for Identification: $type");
//       debugPrint("Data is: $data");

//       // Check if the type is 'video' and handle accordingly
//       if (type == "video") {
//         String? videoUrl = data["video_url"];
//         if (videoUrl == null) {
//           debugPrint("Video URL is null in the fetched data.");
//           return;
//         }

//         debugPrint("Navigating to Video Player Screen with URL: $videoUrl");

//         await Future.delayed(Duration.zero);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ExerciseVideo(
//               videoUrl: videoUrl,
//               onVideoComplete: () {
//                 data_pro.incrementLevel(startExerciseIndex);
//                 if (data["completedAt"] == null) {
//                   UserData(uid: FirebaseAuth.instance.currentUser!.uid)
//                       .updateExerciseData(
//                         euid: data["uid"],
//                         date: data["date"],
//                       )
//                       .then((value) => print("Exercise data updated"));
//                 }
//               },
//             ),
//           ),
//         );
//       } else {
//         print("Type is not video");
//         print(type);
//         print(data);
//         // Handle other types
//         final Object dtcontainer = retrieveObject(type, data);

//         List<dynamic> argumentsList = [
//           type,
//           dtcontainer,
//           params,
//           startExerciseIndex,
//           data["eid"],
//           data["date"],
//           data
//         ];
//         debugPrint("Arguments list is: $argumentsList");
//         await Future.delayed(Duration.zero);
//         NavigatorService.pushNamed(AppRoutes.exerciseIdentification,
//             arguments: argumentsList);
//       }
//     } catch (e) {
//       debugPrint("Error in Identification handling: $e");
//     }
//   }

//   void _handleLevel(
//       BuildContext context, String params, int startExerciseIndex) async {
//     try {
//       debugPrint("Entering in level section");
//       var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
//       Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
//       ;

//       String? type = data["type"];
//       if (type == null) {
//         debugPrint("Type is null in the fetched data.");
//         return;
//       }

//       debugPrint("Fetched type for Level: $type");

//       await Future.delayed(Duration.zero);

//       if (type == "video") {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ExerciseVideo(
//               videoUrl: data["video"],
//               onVideoComplete: () {
//                 data_pro.incrementLevel(startExerciseIndex);

//                 if (data["completedAt"] == null) {
//                   UserData(uid: FirebaseAuth.instance.currentUser!.uid)
//                       .updateExerciseData(
//                         euid: data["uid"],
//                         date: data["date"],
//                       )
//                       .then((value) => print("Exercise data updated"));
//                 }
//               },
//             ),
//           ),
//         );
//       } else if (type == "speech") {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ExercisesSpeakingPhoneme(
//               text: (data["text"] as List)
//                   .map((item) => Map<String, dynamic>.from(item))
//                   .toList(),
//               videoUrl: data["video_url"],
//               testSpeech: data["test_speech"],
//               uid: data["uid"],
//               date: data["date"],
//             ),
//           ),
//         );
//       } else {
//         final Object dtcontainer = retrieveObject(type, data);

//         List<dynamic> argumentsList = [
//           type,
//           dtcontainer,
//           params,
//           startExerciseIndex,
//           data["eid"],
//           data["date"]
//         ];
//         debugPrint("Arguments list is: $argumentsList");

//         NavigatorService.pushNamed(AppRoutes.exerciseIdentification,
//             arguments: argumentsList);
//       }
//     } catch (e) {
//       debugPrint("Error in Level handling: $e");
//     }
//   }

//   void tapHandle(RiveEvent event) {
//     var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
//     int startExerciseIndex = (data_pro.currentExerciseIndex ~/ 5) * 5;

//     // Extract level number from event name
//     int targetLevel = int.parse(event.name.split(' ')[1]);
//     print("targetLevel: $targetLevel");

//     print("startExerciseIndex: $startExerciseIndex");

//     // Check if the requested level exists in today's exercises
//     if (data_pro.todaysExercises.length - 1 <
//         startExerciseIndex + targetLevel - 1) {
//       final snackBar = SnackBar(
//         /// need to set following properties for best effect of awesome_snackbar_content
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'On Snap!',
//           message: 'No exercises found today',

//           /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
//           contentType: ContentType.failure,
//         ),
//       );
//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//       return;
//     }

//     // If all checks pass, handle the level
//     _handleLevelType(startExerciseIndex + targetLevel - 1, "notcompleted");
//   }

//   String formatDate(String date) {
//     try {
//       final months = [
//         'Jan',
//         'Feb',
//         'Mar',
//         'Apr',
//         'May',
//         'Jun',
//         'Jul',
//         'Aug',
//         'Sep',
//         'Oct',
//         'Nov',
//         'Dec'
//       ];

//       List<String> parts = date.split('-');
//       if (parts.length >= 3) {
//         // parts[0] is year, parts[1] is month, parts[2] is day
//         int day = int.parse(parts[2]);
//         int month = int.parse(parts[1]);
//         return '$day ${months[month - 1]}';
//       }
//       return 'Invalid Date';
//     } catch (e) {
//       return 'Invalid Date';
//     }
//   }

//   void _onRiveInit(Artboard artboard) {
//     var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
//     int exerciseCount = data_pro.todaysExercises.length;
//     data_pro.artboard = artboard;
//     print("Total exercises to do : ${data_pro.todaysExercises.length}");
//     int startExerciseIndex =
//         (data_pro.currentExerciseIndex ~/ 5) * 5; // Calculate starting index
//     int endExerciseIndex = startExerciseIndex + 4;
//     print("startExerciseIndex: $startExerciseIndex");
//     print("endExerciseIndex: $endExerciseIndex");
//     if (endExerciseIndex > exerciseCount) {
//       endExerciseIndex = exerciseCount - 1;
//     }
//     data_pro.controller =
//         StateMachineController.fromArtboard(artboard, 'State Machine 1');
//     print("Controller: ${data_pro.controller}");
//     print("Artboard: ${data_pro.artboard}");
//     if (data_pro.controller != null) {
//       data_pro.artboard!.addController(data_pro.controller!);
//       data_pro.artboard!.forEachComponent((component) {
//         if (component is TextValueRun) {
//           print(
//               "Component: ${component.runtimeType} - Name: ${component.name}");
//         }
//       });
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         for (int i = 0; i < 5; i++) {
//           int actualIndex = startExerciseIndex + i;
//           print("actualIndex: $actualIndex");

//           if (actualIndex >= exerciseCount) {
//             break;
//           }

//           String subtypeKey = "level${i + 1}";
//           TextValueRun? textRun_subtype =
//               data_pro.artboard!.textRun(subtypeKey);
//           if (textRun_subtype != null) {
//             print(
//                 "type ${actualIndex}: ${data_pro.todaysExercises[actualIndex]['type']}");
//             String description = data_pro.todaysExercises[actualIndex]
//                     ['description'] ??
//                 'No Description';
//             if (description.contains(' (')) {
//               textRun_subtype.text = description.split(' (')[0];
//             } else {
//               textRun_subtype.text = description;
//             }
//           } else {
//             debugPrint("Error: '$subtypeKey' text run not found!");
//           }

//           String descKey = "desc${i + 1}";
//           TextValueRun? textRun_desc = data_pro.artboard!.textRun(descKey);
//           if (textRun_desc != null) {
//             String description = data_pro.todaysExercises[actualIndex]
//                     ['description'] ??
//                 'No Description';
//             if (description.contains(' (')) {
//               List<String> parts = description.split(' (');
//               if (parts.length > 1) {
//                 // Remove the closing parenthesis if it exists
//                 textRun_desc.text = parts[1].replaceAll(')', '');
//               } else {
//                 textRun_desc.text = '';
//               }
//             } else {
//               textRun_desc.text = '';
//             }
//           } else {
//             debugPrint("Error: '$descKey' text run not found!");
//           }

//           String typeKey = "type${i + 1}";
//           TextValueRun? textRun_type = data_pro.artboard!.textRun(typeKey);
//           if (textRun_type != null) {
//             String dateStr =
//                 data_pro.todaysExercises[actualIndex]['date'] ?? 'No Date';
//             if (dateStr != 'No Date') {
//               dateStr = formatDate(dateStr);
//             }
//             textRun_type.text = dateStr;
//           } else {
//             debugPrint("Error: '$typeKey' text run not found!");
//           }
//         }

//         train = data_pro.artboard!.component('train');

//         if (train != null) {
//           print(
//               "train position: ${train.y}"); // Updated to y coordinate for portrait mode
//           _previousTrainX = train.y; // Store y position for portrait mode
//         } else {
//           debugPrint("Error: 'train' not found!");
//         }

//         data_pro.initializeSMINumber(
//             data_pro.controller?.getNumberInput('current level') as SMINumber);

//         if (data_pro.currentLevelInput == null) {
//           debugPrint("Error: 'current level' input not found!");
//         }

//         print("current level: ${data_pro.currentExerciseIndex}");
//         if (data_pro.currentExerciseIndex == 5) {
//           data_pro.changeCurrentLevel(1);
//           data_pro.controller!.addEventListener(tapHandle);
//           return;
//         }
//         data_pro.changeCurrentLevel(
//             (data_pro.currentExerciseIndex.toDouble() % 5 + 1));
//         data_pro.controller!.addEventListener(tapHandle);
//       });
//     } else {
//       print("Controller is null");
//     }
//   }

//   // Modified to handle vertical scrolling in portrait mode
//   void _trackTrainPosition() {
//     if (train != null && train.artboard != null) {
//       double trainX = train.x;

//       if (_previousTrainX == null || _previousTrainX != trainX) {
//         double screenWidth = MediaQuery.of(context).size.height * 7.716;
//         double maxTrainX = train.artboard!.width;
//         double scaledOffset = (trainX / maxTrainX) * screenWidth;

//         if (_scrollController.hasClients) {
//           // Calculate the distance and use it to adjust animation duration
//           double deltaX =
//               _previousTrainX != null ? (trainX - _previousTrainX!).abs() : 0;
//           int animationDuration = (deltaX * 10).toInt().clamp(50, 200);

//           _scrollController.animateTo(
//             scaledOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
//             duration: Duration(milliseconds: animationDuration),
//             curve: Curves.easeOut, // Use a smoother curve
//           );
//         }
//         _previousTrainX = trainX;
//       }
//     }
//   }

//   Object retrieveObject(String type, Map<String, dynamic> data) {
//     if (type == "ImageToAudio") {
//       print("In Image to audio section");
//       print(ImageToAudio.fromJson(data));
//       return ImageToAudio.fromJson(data);
//     } else if (type == "WordToFig") {
//       return WordToFiG.fromJson(data);
//     } else if (type == "FigToWord") {
//       return FigToWord.fromJson(data);
//     } else if (type == "AudioToImage") {
//       debugPrint("In audio to image section");
//       return AudioToImage.fromJson(data);
//     } else if (type == "AudioToAudio") {
//       return AudioToAudio.fromJson(data);
//     } else if (type == "MutedUnmuted") {
//       return MutedUnmuted.fromJson(data);
//     } else if (type == "HalfMuted") {
//       return HalfMuted.fromJson(data);
//     } else if (type == "DiffSounds") {
//       return DiffSounds.fromJson(data);
//     } else if (type == "OddOne") {
//       return OddOne.fromJson(data);
//     } else if (type == "DiffHalf") {
//       return DiffHalf.fromJson(data);
//     } else if (type == "MaleFemale") {
//       return MaleFemale.fromJson(data);
//     } else {
//       return "unexpected value";
//     }
//   }
// }
import 'dart:async';
import 'package:chiclet/chiclet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/exercises/exercise_pronunciation.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/exercises/exercise_video.dart';
import 'package:svar_new/presentation/exercises/exercises_speaking_phoneme.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:intl/intl.dart'; // For date formatting

enum ExerciseStatus { completed, current, pending, locked }

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();

  static Widget builder(BuildContext context) {
    return ExercisesScreen();
  }
}

class _ExercisesScreenState extends State<ExercisesScreen>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  List<String> _dateKeys = [];
  int _selectedDateTabIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize _pageController after the first frame to ensure context is available
    // and provider data might be loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDateTabsAndPage();
    });
  }

  void _initializeDateTabsAndPage() {
    final data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    final grouped = _groupExercisesByDate(data_pro.todaysExercises);
    if (!mounted) return;

    setState(() {
      _dateKeys = grouped.keys.toList();
      if (_dateKeys.isNotEmpty) {
        // Try to find the date of the current exercise
        int currentExerciseGlobalIndex = data_pro.currentExerciseIndex;
        String? currentDateKey;
        if (currentExerciseGlobalIndex >= 0 && currentExerciseGlobalIndex < data_pro.todaysExercises.length) {
          String? currentExerciseDate = data_pro.todaysExercises[currentExerciseGlobalIndex]['date'];
          if (currentExerciseDate != null && _dateKeys.contains(currentExerciseDate)) {
            currentDateKey = currentExerciseDate;
          }
        }

        if (currentDateKey != null) {
          _selectedDateTabIndex = _dateKeys.indexOf(currentDateKey);
        } else {
           _selectedDateTabIndex = 0; // Default to the first (most recent) date
        }

        // Ensure PageController is initialized only once or correctly updated
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_selectedDateTabIndex);
        } else {
          _pageController = PageController(initialPage: _selectedDateTabIndex);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Map<String, List<Map<String, dynamic>>> _groupExercisesByDate(
      List<Map<String, dynamic>> exercises) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var exercise in exercises) {
      String date = exercise['date'] as String? ?? 'Unknown Date';
      if (grouped[date] == null) grouped[date] = [];
      grouped[date]!.add(exercise);
    }
    var sortedKeys = grouped.keys.toList(growable: false)
      ..sort((a, b) => b.compareTo(a)); // Sort dates descending (most recent first)
    return {for (var k in sortedKeys) k: grouped[k]!};
  }

  String formatDateForTabDisplay(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      // Show "Today", "Yesterday" or "Day, dd MMM"
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(Duration(days: 1));

      if (date == today) return "Today";
      if (date == yesterday) return "Yesterday";
      return DateFormat('EEE, dd MMM').format(date); // e.g., "Mon, 16 Apr"
    } catch (e) {
      return dateString; // Fallback
    }
  }

  Widget _buildDateTabs(ExerciseProvider data_pro) {
    if (_dateKeys.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      height: 50,
      color: Theme.of(context).scaffoldBackgroundColor, // Or a subtle color
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dateKeys.length,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        itemBuilder: (context, index) {
          bool isSelected = index == _selectedDateTabIndex;
          return GestureDetector(
            onTap: () {
              if(_pageController.hasClients) {
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
              // PageView's onPageChanged will update _selectedDateTabIndex
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.lightBlue.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20.0),
                border: isSelected ? Border.all(color: Colors.lightBlue, width: 1.5) : null,
              ),
              child: Center(
                child: Text(
                  formatDateForTabDisplay(_dateKeys[index]),
                  style: TextStyle(
                    color: isSelected ? Colors.lightBlue.shade700 : Colors.grey.shade700,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExerciseListItem(
    BuildContext context,
    Map<String, dynamic> exercise,
    ExerciseStatus status,
    int originalIndex,
  ) {
    String description = exercise['description'] as String? ?? 'Unnamed Exercise';
    // String exerciseType = exercise['exerciseType'] as String? ?? 'N/A';

    Color itemColor;
    Color iconColor;
    Color textColor;
    IconData statusIconData;
    Widget leftIconWidget;

    bool isLocked = status == ExerciseStatus.locked;

    switch (status) {
      case ExerciseStatus.completed:
        itemColor = Colors.green.shade600;
        iconColor = Colors.white;
        textColor = Colors.white;
        statusIconData = Icons.check_circle;
        leftIconWidget = Icon(Icons.emoji_events_outlined, color: Colors.white.withOpacity(0.8), size: 36);
        break;
      case ExerciseStatus.current:
        itemColor = Colors.orange.shade600;
        iconColor = Colors.white;
        textColor = Colors.white;
        statusIconData = Icons.play_circle_filled;
        leftIconWidget = Icon(Icons.local_fire_department_outlined, color: Colors.white.withOpacity(0.8), size: 36);
        break;
      case ExerciseStatus.pending: // Not current, not completed, but accessible
      case ExerciseStatus.locked: // Not yet accessible
      default:
        itemColor = Colors.grey.shade300;
        iconColor = Colors.grey.shade600;
        textColor = Colors.grey.shade700;
        statusIconData = Icons.lock;
        leftIconWidget = Icon(Icons.school_outlined, color: Colors.grey.shade500, size: 36);
        break;
    }
    
    // If it's pending but not explicitly locked by game logic, show a different icon than lock
    // For simplicity now, pending and locked use the same visual, but tappability differs.
    // If we want "pending but available" to look different from "locked", add a new case.

    return ChicletOutlinedAnimatedButton(
      onPressed: isLocked ? null : () {
      _handleLevelType(originalIndex, "notcompleted");
    },
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            leftIconWidget,
            SizedBox(width: 16.0),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: textColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 12.0),
            Icon(statusIconData, color: iconColor, size: 28),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var data_pro = Provider.of<ExerciseProvider>(context);
    final groupedExercises = _groupExercisesByDate(data_pro.todaysExercises);
    // _dateKeys is updated in initState and _initializeDateTabsAndPage

    int currentExerciseOverallIndex = data_pro.currentExerciseIndex;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130.0),
        child: AppBar(
          backgroundColor: Colors.lightBlue,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 40, color: Colors.white), // Changed Icon
                  SizedBox(height: 8),
                  Text(
                    "My Exercises", // Changed Text
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Complete your daily activities", // Changed Text
                    style: TextStyle(
                        fontSize: 14, color: Colors.white.withOpacity(0.85)),
                  ),
                ],
              ),
            ),
          ),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          _buildDateTabs(data_pro),
          Expanded(
            child: _dateKeys.isEmpty
                ? Center(
                    child: Text(
                    "No exercises available.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ))
                : PageView.builder(
                    controller: _pageController,
                    itemCount: _dateKeys.length,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedDateTabIndex = index;
                      });
                    },
                    itemBuilder: (context, pageIndex) {
                      String dateKey = _dateKeys[pageIndex];
                      List<Map<String, dynamic>> exercisesForDate =
                          groupedExercises[dateKey] ?? [];

                      if (exercisesForDate.isEmpty) {
                        return Center(child: Text("No exercises for ${formatDateForTabDisplay(dateKey)}."));
                      }

                      return ListView.builder(
                        padding: EdgeInsets.all(16.0),
                        itemCount: exercisesForDate.length,
                        itemBuilder: (context, itemIndex) {
                          Map<String, dynamic> exercise = exercisesForDate[itemIndex];
                          int originalIndexOfThisExercise =
                              data_pro.todaysExercises.indexOf(exercise);
                          
                          bool isCompleted = exercise["completedAt"] != null;
                          ExerciseStatus status;

                          // Determine lock status: an exercise is locked if a *previous* one (in overall list) isn't complete.
                          // The very first exercise is never locked by this rule.
                          bool isLogicallyLocked = false;
                          if (originalIndexOfThisExercise > 0) {
                              // Check if *any* exercise before this one (in the global list) is incomplete.
                              // A simpler rule: if the *immediately* previous global exercise is not complete, this one is locked.
                              // For a more Duolingo-like sequence, you usually unlock one by one.
                              Map<String, dynamic>? previousExercise = (originalIndexOfThisExercise -1 < data_pro.todaysExercises.length && originalIndexOfThisExercise -1 >=0 ) ? data_pro.todaysExercises[originalIndexOfThisExercise - 1] : null;
                              if(previousExercise != null && previousExercise["completedAt"] == null){
                                isLogicallyLocked = true;
                              }
                          }
                          
                          // The "current" one should not be locked by previous incomplete, but by game flow.
                          if (isCompleted) {
                            status = ExerciseStatus.completed;
                          } else if (originalIndexOfThisExercise == currentExerciseOverallIndex) {
                            status = ExerciseStatus.current;
                          } else if (isLogicallyLocked && originalIndexOfThisExercise > currentExerciseOverallIndex) { 
                            // If it's after current and something before it is incomplete
                            status = ExerciseStatus.locked;
                          }
                          else {
                            status = ExerciseStatus.pending; // Available but not current, or before current and not done
                             // If it's before current and not done, it's pending.
                             // If it's after current but the one before it is done, it's pending (next up)
                            if(originalIndexOfThisExercise > currentExerciseOverallIndex) status = ExerciseStatus.locked; // Simplified: lock all after current if not current.
                          }
                          
                          // Refined status logic:
                          if (isCompleted) {
                            status = ExerciseStatus.completed;
                          } else if (originalIndexOfThisExercise == currentExerciseOverallIndex) {
                            status = ExerciseStatus.current;
                          } else if (originalIndexOfThisExercise > currentExerciseOverallIndex) {
                            // Any exercise after the current one is considered locked until current is done.
                            status = ExerciseStatus.locked;
                          }
                           else { // originalIndexOfThisExercise < currentExerciseOverallIndex && !isCompleted
                            status = ExerciseStatus.pending; // An older exercise that wasn't completed
                          }


                          return _buildExerciseListItem(
                            context,
                            exercise,
                            status,
                            originalIndexOfThisExercise,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- All _handleLEVELTYPE, _handlePronunciation, etc. methods remain unchanged from previous version ---
  // --- along with _showErrorSnackbar, retrieveObject ---
  // Make sure they are present in your final code.
  // For brevity, I'm omitting them here as they were correct in the prior step.
  // Ensure you copy them back.
  
  void _handleLevelType(int exerciseIndex, String params) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);

      if (data_pro.todaysExercises.isEmpty ||
          exerciseIndex < 0 || 
          exerciseIndex >= data_pro.todaysExercises.length) {
        debugPrint("No exercises found or index out of bounds: $exerciseIndex");
        _showErrorSnackbar('No exercises found for today or invalid selection.');
        return;
      }
      String? exerciseType =
          data_pro.todaysExercises[exerciseIndex]["exerciseType"];

      if (exerciseType == null) {
        debugPrint("Exercise type is null in the arguments.");
        _showErrorSnackbar('Exercise type is missing for the selected item.');
        return;
      }

      switch (exerciseType) {
        case "Detection":
          _handleDetection(context, "notcompleted", exerciseIndex);
          break;
        case "Discrimination":
          _handleDiscrimination(context, "notcompleted", exerciseIndex);
          break;
        case "Identification":
          _handleIdentification(context, "notcompleted", exerciseIndex);
          break;
        case "Level":
          _handleLevel(context, "notcompleted", exerciseIndex);
          break;
        case 'Pronunciation':
          _handlePronunciation(context, "notcompleted", exerciseIndex);
          break;
        default:
          debugPrint("Unknown exercise type: $exerciseType");
          _showErrorSnackbar('Unknown exercise type: $exerciseType.');
      }
    } catch (e) {
      debugPrint("Error in _handleLevelType: $e");
      _showErrorSnackbar('An error occurred while trying to load the exercise.');
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'On Snap!',
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _handlePronunciation(
      BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

      print("data: $data");
      if (data.isEmpty) return;
      String? type = data["type"];
      if (type == null) {
        debugPrint("Type is null in the fetched data.");
        return;
      }

      debugPrint("Fetched type for Pronunciation: $type");
      debugPrint("Data is: $data");

      // final Object dtcontainer = retrieveObject(type, data);
      // if (dtcontainer is String && dtcontainer == "unexpected value") {
      //    _showErrorSnackbar('Could not process exercise data for $type.');
      //    return;
      // }

      List<dynamic> argumentsList = [
        type, "NULL", params, startExerciseIndex,
        data["uid"], data["date"], data,
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

      if (data.isEmpty) return;
      String? type = data["type"];
      if (type == null) {
         debugPrint("Type is null in Detection data.");
        _showErrorSnackbar('Exercise data is incomplete.');
        return;
      }

      if (type == "video") {
        String? videoUrl = data["video_url"];
        if (videoUrl == null) {
          debugPrint("Video URL is null for Detection video.");
           _showErrorSnackbar('Video link is missing.');
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseVideo(
              videoUrl: videoUrl,
              onVideoComplete: () {
                if(!mounted) return;
                data_pro.incrementLevel(startExerciseIndex);
                if (data["completedAt"] == null) {
                  UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateExerciseData(euid: data["uid"], date: data["date"])
                      .then((value) => print("Exercise data updated for ${data["uid"]}"))
                      .catchError((e) => print("Error updating exercise data: $e"));
                }
              },
            ),
          ),
        );
      } else {
        final Object dtcontainer = retrieveObject(type, data);
        if (dtcontainer is String && dtcontainer == "unexpected value") {
           _showErrorSnackbar('Could not process exercise data for $type.');
           return;
        }
        List<dynamic> argumentsList = [
          type, dtcontainer, params, startExerciseIndex,
          data["uid"], data["date"]
        ];
        NavigatorService.pushNamed(AppRoutes.exerciseDetection, arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Detection handling: $e");
      _showErrorSnackbar('Error loading detection exercise.');
    }
  }

  void _handleDiscrimination(
      BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
      if (data.isEmpty) return;
      String? type = data["type"];
      if (type == null) {
        debugPrint("Type is null in Discrimination data.");
        _showErrorSnackbar('Exercise data is incomplete.');
        return;
      }

      if (type == "sound" || type == "video") {
        String? videoUrl = data["video_url"];
        if (videoUrl == null) {
          debugPrint("Video URL is null for Discrimination $type.");
          _showErrorSnackbar('Media link is missing.');
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseVideo(
              videoUrl: videoUrl,
              onVideoComplete: () {
                if(!mounted) return;
                data_pro.incrementLevel(startExerciseIndex);
                if (data["completedAt"] == null) {
                  UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateExerciseData(euid: data["uid"], date: data["date"])
                      .then((value) => print("Exercise data updated for ${data["uid"]}"))
                      .catchError((e) => print("Error updating exercise data: $e"));
                }
              },
            ),
          ),
        );
      } else {
        final Object dtcontainer = retrieveObject(type, data);
         if (dtcontainer is String && dtcontainer == "unexpected value") {
           _showErrorSnackbar('Could not process exercise data for $type.');
           return;
        }
        List<dynamic> argumentsList = [
          type, dtcontainer, params, startExerciseIndex,
          data["uid"], data["date"]
        ];
        NavigatorService.pushNamed(AppRoutes.exerciseDiscrimination, arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Discrimination handling: $e");
      _showErrorSnackbar('Error loading discrimination exercise.');
    }
  }

  void _handleIdentification(
      BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
      if (data.isEmpty) return;
      String? type = data["type"];
      if (type == null) {
        debugPrint("Type is null in Identification data.");
        _showErrorSnackbar('Exercise data is incomplete.');
        return;
      }

      if (type == "video") {
        String? videoUrl = data["video_url"];
        if (videoUrl == null) {
           debugPrint("Video URL is null for Identification video.");
          _showErrorSnackbar('Video link is missing.');
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseVideo(
              videoUrl: videoUrl,
              onVideoComplete: () {
                if(!mounted) return;
                data_pro.incrementLevel(startExerciseIndex);
                if (data["completedAt"] == null) {
                  UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateExerciseData(euid: data["uid"], date: data["date"])
                      .then((value) => print("Exercise data updated for ${data["uid"]}"))
                      .catchError((e) => print("Error updating exercise data: $e"));
                }
              },
            ),
          ),
        );
      } else {
        final Object dtcontainer = retrieveObject(type, data);
        if (dtcontainer is String && dtcontainer == "unexpected value") {
           _showErrorSnackbar('Could not process exercise data for $type.');
           return;
        }
        List<dynamic> argumentsList = [
          type, dtcontainer, params, startExerciseIndex,
          data["uid"], data["date"], data
        ];
        NavigatorService.pushNamed(AppRoutes.exerciseIdentification, arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Identification handling: $e");
      _showErrorSnackbar('Error loading identification exercise.');
    }
  }

  void _handleLevel(
      BuildContext context, String params, int startExerciseIndex) async {
    try {
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
      String? type = data["type"]; 
      if (type == null) {
        debugPrint("Sub-type is null for 'Level' exercise.");
        _showErrorSnackbar('Exercise sub-type is missing.');
        return;
      }

      if (type == "video") {
        String? videoUrl = data["video_url"] ?? data["video"];
        if (videoUrl == null) {
          debugPrint("Video URL is null for 'Level' video type.");
          _showErrorSnackbar('Video link is missing for this level.');
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseVideo(
              videoUrl: videoUrl,
              onVideoComplete: () {
                if(!mounted) return;
                data_pro.incrementLevel(startExerciseIndex);
                if (data["completedAt"] == null) {
                  UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateExerciseData(euid: data["uid"], date: data["date"])
                      .then((value) => print("Exercise data updated for ${data["uid"]}"))
                      .catchError((e) => print("Error updating exercise data: $e"));
                }
              },
            ),
          ),
        );
      } else if (type == "speech") {
        if (data["text"] == null || data["video_url"] == null || data["test_speech"] == null || data["uid"] == null || data["date"] == null) {
          debugPrint("Missing data for 'Level' speech type: $data");
          _showErrorSnackbar('Incomplete data for speech exercise.');
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExercisesSpeakingPhoneme(
              text: (data["text"] as List).map((item) => Map<String, dynamic>.from(item)).toList(),
              videoUrl: data["video_url"],
              testSpeech: data["test_speech"],
              uid: data["uid"],
              date: data["date"],
            ),
          ),
        );
      } else {
        final Object dtcontainer = retrieveObject(type, data);
        if (dtcontainer is String && dtcontainer == "unexpected value") {
           _showErrorSnackbar('Could not process exercise data for $type.');
           return;
        }
        List<dynamic> argumentsList = [
          type, dtcontainer, params, startExerciseIndex,
          data["uid"], data["date"]
        ];
        NavigatorService.pushNamed(AppRoutes.exerciseIdentification, arguments: argumentsList);
      }
    } catch (e) {
      debugPrint("Error in Level handling: $e");
      _showErrorSnackbar('Error loading this level exercise.');
    }
  }

  Object retrieveObject(String type, Map<String, dynamic> data) {
    try {
      if (type == "ImageToAudio") return ImageToAudio.fromJson(data);
      if (type == "WordToFig") return WordToFiG.fromJson(data);
      if (type == "FigToWord") return FigToWord.fromJson(data);
      if (type == "AudioToImage") return AudioToImage.fromJson(data);
      if (type == "AudioToAudio") return AudioToAudio.fromJson(data);
      if (type == "MutedUnmuted") return MutedUnmuted.fromJson(data);
      if (type == "HalfMuted") return HalfMuted.fromJson(data);
      if (type == "DiffSounds") return DiffSounds.fromJson(data);
      if (type == "OddOne") return OddOne.fromJson(data);
      if (type == "DiffHalf") return DiffHalf.fromJson(data);
      if (type == "MaleFemale") return MaleFemale.fromJson(data);
      
      debugPrint("Unexpected object type to retrieve: $type. Returning 'unexpected value'.");
      return "unexpected value";
    } catch (e) {
      debugPrint("Error in retrieveObject for type $type: $e. Returning 'unexpected value'.");
      return "unexpected value";
    }
  }

}