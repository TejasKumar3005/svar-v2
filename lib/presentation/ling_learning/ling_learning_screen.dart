import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/presentation/ling_learning_detailed/ling_learning_detailed_tip_box_provider.dart';
import 'package:svar_new/widgets/circularScore.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class LingLearningScreen extends StatefulWidget {
  const LingLearningScreen({Key? key}) : super(key: key);

  @override
  LingLearningScreenState createState() => LingLearningScreenState();

  static Widget builder(BuildContext context) {
    return LingLearningScreen();
  }
}

class LingLearningScreenState extends State<LingLearningScreen> {
  late AudioPlayer _audioPlayer;
  var model;

  @override
  void initState() {
    super.initState();

    AudioCache.instance = AudioCache(prefix: '');
    _audioPlayer = AudioPlayer();
    // requestPermissions();
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

  @override
  Widget build(BuildContext context) {
    LingLearningProvider lingLearningProvider =
        context.watch<LingLearningProvider>();

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
                  _buildAppBar(context),
                ],
              ),
              Positioned(
                left: 80,
                bottom: 100,
                child: GestureDetector(
                  onTap: () {
                    _playAudio(lingLearningProvider.selectedCharacter);
                  },
                  child: Text(
                    lingLearningProvider.selectedCharacter,
                    style: TextStyle(fontSize: 160),
                  ),
                ),
              ),
              Positioned(
                left: 180,
                bottom: 120,
                child: AvatarGlow(
                  endRadius: 90.0,
                  glowColor: Colors.blue,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: Container(
                      height: 120,
                      width: 120,
                      // child: circularScore(),
                      child: CustomButton(
                        type: ButtonType.Mic,
                        onPressed: () async{
                            bool permission = await requestPermissions();
    print("----permission---"+permission.toString());
    if (!permission) {
      return;
    }
                          onTapMicrophonebutton(context, lingLearningProvider);
                        },
                      ),
                    ),
                  ),
                ),
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
                  width: 100,
                  child: CustomButton(
                    type: ButtonType.Tip,
                    onPressed: () {
                      NavigatorService.pushNamed(
                        AppRoutes.tipBoxVideoScreen,
                      );
                    },
                  ),
                ),
              ),
              // Positioned(
              //   left: MediaQuery.of(context).size.width *0.1,
              //   bottom: 10,
              //   child: circularScore(),
              // )
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
              NavigatorService.pushNamed(
                AppRoutes.phonmesListScreen,
              );
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

  Future<double> sendWavFile(String wavFile, String phoneme) async {
    var uri = Uri.parse("http://65.0.76.10:3002/process_wav");

    var request = http.MultipartRequest('POST', uri)
      ..fields['phoneme'] = phoneme
      ..files.add(await http.MultipartFile.fromPath('wav_file', wavFile));

    var response = await request.send();

    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      print(body);
      Map<String, dynamic> data = json.decode(body);
      return data['result'];
    } else {
      throw Exception(
          "Failed to send .wav file. Status code: ${response.statusCode}");
    }
  }

  onTapMicrophonebutton(
      BuildContext context, LingLearningProvider provider) async {
    print("-------hello");
  
    // if (provider.isRecording) {
    //   await provider.stopRecording();
    // } else {
    //   await provider.startRecording();
    // }

    // print(provider.isRecording);
    // }
    try {
      
      bool done = await provider.toggleRecording(context);
      print(done);
      if (!provider.isRecording) {
        Directory tempDir = await getTemporaryDirectory();
        print("hereafewfwef");
        String tempPath = tempDir.path;
        String path = '$tempPath/audio.wav';
        var ans = await sendWavFile(path, model.typeTxt.value);
        print(ans);
        model.result = ans;
        Navigator.pushNamed(context, AppRoutes.lingLearningScreen,
            arguments: model);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
