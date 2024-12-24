import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_model.dart';
import 'package:svar_new/widgets/circularScore.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:svar_new/widgets/loading.dart';

class ExercisePronunciation extends StatefulWidget {
  final String character;
  final String eid;
  final String date;    
  const ExercisePronunciation(
      {Key? key, required this.character, required this.eid, required this.date})
      : super(key: key);

  @override
  ExercisePronunciationState createState() => ExercisePronunciationState();

  static Widget builder(BuildContext context) {
    return ExercisePronunciation(character: "", eid: "", date: "");
  }
}

class ExercisePronunciationState extends State<ExercisePronunciation> {
  String? _errorMessage;
  late AudioPlayer _audioPlayer;
  var model;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = ModalRoute.of(context)!.settings.arguments;
  }

  void _playAudio(String character) async {
    // Map character to audio file
    String audioPath = '';
    switch (character) {
      case 'क':
        audioPath = 'assets/audio/ka.mp3';
        break;
      case 'ख':
        audioPath = 'assets/audio/kha.mp3';
        break;
      case 'ग':
        audioPath = 'assets/audio/ga.mp3';

        break;
      case 'घ':
        audioPath = 'assets/audio/gha.mp3';
        break;
      case 'च':
        audioPath = 'assets/audio/cha.mp3';
        break;
      case 'छ':
        audioPath = 'assets/audio/chha.mp3';
        break;
      case 'ज':
        audioPath = 'assets/audio/ja.mp3';
        break;
      case 'झ':
        audioPath = 'assets/audio/jha.mp3';
        break;
      case 'ट':
        audioPath = 'assets/audio/ta.mp3';
        break;
      case 'ठ':
        audioPath = 'assets/audio/thaa.mp3';
        break;
      case 'ड':
        audioPath = 'assets/audio/da.mp3';
        break;
      case 'ढ':
        audioPath = 'assets/audio/dhaa.mp3';
        break;
      case 'त':
        audioPath = 'assets/audio/tha.mp3';
        break;
      case 'थ':
        audioPath = 'assets/audio/taa.mp3';
        break;
      case 'ध':
        audioPath = 'assets/audio/dhha.mp3';
        break;
      case 'न':
        audioPath = 'assets/audio/naa.mp3';
        break;
      case 'प':
        audioPath = 'assets/audio/pa.mp3';
        break;
      case 'फ':
        audioPath = 'assets/audio/pha.mp3';
        break;
      case 'ब':
        audioPath = 'assets/audio/ba.mp3';
        break;
      case 'भ':
        audioPath = 'assets/audio/bha.mp3';
        break;
      case 'म':
        audioPath = 'assets/audio/ma.mp3';
        break;
      default:
        audioPath =
            'assets/audio/default.mp3'; // Ensure a default.mp3 file exists or handle this case appropriately
    }

    bool fileExists = await rootBundle
        .load(audioPath)
        .then((value) => true)
        .catchError((_) => false);
    if (fileExists) {
      await _audioPlayer.play(
        AssetSource(audioPath, mimeType: "mp3"),
      );
    } else {
      print("Audio file not found: $audioPath");
    }
  }

  String? result;
  bool loading = false;
  OverlayEntry? _overlayEntry;
  @override
  Widget build(BuildContext context) {
    LingLearningProvider lingLearningProvider =
        context.watch<LingLearningProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loading && _overlayEntry == null) {
        _overlayEntry = createOverlayEntry(context);
        Overlay.of(context)?.insert(_overlayEntry!);
      } else if (!loading && _overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.imgGroup7),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  DisciAppBar(context),
                ],
              ),
              Positioned(
                left: 80,
                bottom: 100,
                child: result == null
                    ? GestureDetector(
                        onTap: () {
                          // _playAudio(lingLearningProvider.selectedCharacter);
                        },
                        child: Text(
                          widget.character,
                          style: TextStyle(fontSize: 160),
                        ),
                      )
                    : Container(),
              ),
              Positioned(
                left: 180,
                bottom: 120,
                child: result == null
                    ? AvatarGlow(
                        endRadius: 90.0,
                        glowColor: Colors.blue,
                        duration: const Duration(milliseconds: 2000),
                        repeat: false,
                        showTwoGlows: false,
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        child: Material(
                          elevation: 8.0,
                          shape: const CircleBorder(),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: lingLearningProvider.isRecording
                                ? BoxDecoration(
                                    border: Border.all(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(60),
                                  )
                                : null,
                            child: CustomButton(
                              type: ButtonType.Mic,
                              onPressed: () async {
                                print("pressed");
                                bool permission = await requestPermissions();
                                print(permission);
                                print("hiiiii");
                                onTapMicrophonebutton(
                                    context, lingLearningProvider);
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
              Positioned(
                right: 80,
                bottom: 0,
                child: Container(
                  height: 360,
                  width: 270,
                  child: Image.asset(
                    ImageConstant.imgProtaganist1,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 50,
                child: Container(
                  height: 70,
                  width: 70,
                  child: CustomButton(
                    type: ButtonType.Tip,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.tipBoxVideoScreen);
                    },
                  ),
                ),
              ),
              result != null
                  ? Positioned(
                      left: MediaQuery.of(context).size.width * 0.1,
                      bottom: 10,
                      child: circularScore(result!),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            type: ButtonType.Back,
            onPressed: () {
              NavigatorService.goBack();
            },
          ),
          Spacer(),
        ],
      ),
    );
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();

    if (statuses[Permission.microphone]!.isGranted &&
        statuses[Permission.storage]!.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<double> sendWavFile(String wavFile, String word) async {
    var uri = Uri.parse("https://gameapi.svar.in/process_wav");

    var request = http.MultipartRequest('POST', uri)
      ..fields['phoneme'] = word
      ..files.add(await http.MultipartFile.fromPath('wav_file', wavFile));

    var response = await request.send();

    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      print(body);
      Map<String, dynamic> data = json.decode(body);
      setState(() {
        result = ((data["result"] * 100.0).toInt()).toString();
        loading = false;
      });
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      data_pro.incrementLevel();
      UserData(uid: FirebaseAuth.instance.currentUser!.uid).updateExerciseData(
        eid: widget.eid,
        date: widget.date,
        performance: {
          "score": (data["result"] * 100.0).toInt(),
          "word": word,
        },
      ).then((value) => print("Exercise data updated"));
      return data['result'];
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong")));
      throw Exception(
          "Failed to send .wav file. Status code: ${response.statusCode}");
    }
  }

  onTapMicrophonebutton(
    BuildContext context,
    LingLearningProvider provider,
  ) async {
    print("Microphone button tapped");

    try {
      bool recordingStarted = await provider.toggleRecording(context);
      print("Recording started: $recordingStarted");

      if (recordingStarted) {
        print("Recording in progress...");
        // The glow effect will start automatically due to isRecording being true
      } else {
        print("Recording stopped");
        setState(() {
          loading = true;
        });

        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        String path = '$tempPath/audio.wav';
        print("Audio file path: $path");

        const timeoutDuration = Duration(seconds: 5);
        var timer = Timer(timeoutDuration, () {
          if (mounted) {
            setState(() {
              loading = false;
              provider.isRecording = false; // Stop recording animation
              _errorMessage = "API call timed out. Please try again later.";
            });
          }
        });

        try {
          double result = await sendWavFile(path, widget.character);
          print("Processing result: $result");
          timer.cancel(); // Cancel timer if successful
        } catch (e) {
          print("Error processing audio: ${e.toString()}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error processing audio: ${e.toString()}")),
          );
        } finally {
          setState(() {
            loading = false;
          });
        }
      }
    } catch (e) {
      print("Error toggling recording: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error toggling recording: ${e.toString()}")),
      );
    }
  }
}