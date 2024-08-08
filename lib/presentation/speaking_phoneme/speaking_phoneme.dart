import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/widgets/circularScore.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:svar_new/widgets/loading.dart';
import 'package:video_player/video_player.dart';

class SpeakingPhonemeScreen extends StatefulWidget {
  const SpeakingPhonemeScreen({Key? key}) : super(key: key);

  @override
  SpeakingPhonemeScreenState createState() => SpeakingPhonemeScreenState();

  static Widget builder(BuildContext context) {
    return SpeakingPhonemeScreen();
  }
}

class SpeakingPhonemeScreenState extends State<SpeakingPhonemeScreen> {
  late AudioPlayer _audioPlayer;
  var model;

  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/video/Laal1.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();

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
                  _buildAppBar(context),
                ],
              ),
              Positioned(
                left: 130,
                bottom: 180,
                child: result == null
                    ? GestureDetector(
                        onTap: () {
                          // _playAudio(lingLearningProvider.selectedCharacter);
                        },
                        child: Text(
                          // lingLearningProvider.selectedCharacter,
                          'paani',
                          style: TextStyle(fontSize: 100),
                        ),
                      )
                    : Container(),
              ),
              Positioned(
                left: 150,
                bottom: 20,
                child: result == null
                    ? AvatarGlow(
                        endRadius: 90.0,
                        glowColor: Colors.blue,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: lingLearningProvider.isRecording,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: Container(
                            height: 120,
                            width: 120,

                            decoration: lingLearningProvider.isRecording
                                ? BoxDecoration(
                                    border: Border.all(
                                      color: Colors.green,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(60),
                                  )
                                : null,
                            // child: circularScore(),
                            child: CustomButton(
                              type: ButtonType.Mic,
                              onPressed: () async {
                                bool permission = await requestPermissions();
                                print("----permission---" +
                                    permission.toString());
                                if (!permission) {
                                  return;
                                }

                                onTapMicrophonebutton(
                                    context, lingLearningProvider);
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
              // Positioned(
              //   right: 80,
              //   bottom: 0,
              //   child: Container(
              //     height: 360,
              //     width: 270,
              //     child: _controller.value.isInitialized
              //         ? AspectRatio(
              //             aspectRatio: _controller.value.aspectRatio,
              //             child: VideoPlayer(_controller),
              //           )
              //         : Center(child: CircularProgressIndicator()),
              //   ),
              // ),
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
    var uri = Uri.parse("https://gameapi.svar.in/process_wav");

    var request = http.MultipartRequest('POST', uri)
      ..fields['phoneme'] = phoneme
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
      return data['result'];
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Something went wrong")));
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
      provider.toggleRecording(context).then((value) async {
        if (!value) {
          setState(() {
            loading = true;
          });
          Directory tempDir = await getTemporaryDirectory();
          print("hereafewfwef");
          String tempPath = tempDir.path;
          String path = '$tempPath/audio.wav';
          await sendWavFile(path, provider.selectedCharacter);
          // print(ans);
          // model.result = ans;
          // Navigator.pushNamed(context, AppRoutes.SpeakingPhonemeScreen,
          //     arguments: model);
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}