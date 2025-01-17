import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_model.dart';
import 'package:svar_new/widgets/circularScore.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:svar_new/widgets/loading.dart';
import 'package:video_player/video_player.dart';

class SpeakingPhonemeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> text;
  final String videoUrl;
  final bool testSpeech;

  const SpeakingPhonemeScreen({
    Key? key,
    required this.text,
    required this.videoUrl,
    required this.testSpeech,
  }) : super(key: key);

  @override
  SpeakingPhonemeScreenState createState() => SpeakingPhonemeScreenState();

  static Widget builder(BuildContext context) {
    return SpeakingPhonemeScreen(
      text: [], // You need to pass the actual text data here
      videoUrl: '', // You need to pass the actual video URL here
      testSpeech: true, // You need to pass the actual testSpeech value here
    );
  }
}

class SpeakingPhonemeScreenState extends State<SpeakingPhonemeScreen> {
  late AudioPlayer _audioPlayer;
  var model;

  String word_tmp = "पानी";
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    PlayBgm().stopMusic();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();

    AudioCache.instance = AudioCache(prefix: '');
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    // _controller.dispose();
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
  List<Map<String, String>>? wrd_map;

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
              _buildText(),
              if (widget.testSpeech)
                _buildMicrophoneButton(lingLearningProvider),
              _buildVideo(),
              _buildTipButton(),
              if (result != null) _buildResult(),
              if (wrd_map != null)
                pronunciationResultWidget(wrd_map!, context, word_tmp),
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

  Widget _buildText() {
    return Positioned(
      left: 130,
      bottom: 180,
      child: RichText(
        text: TextSpan(
          children: widget.text.map((textMap) {
            String key = textMap.keys.first;
            bool value = textMap[key];
            return TextSpan(
              text: key,
              style: TextStyle(
                fontSize: 100,
                color: value ? Colors.blue : Colors.black,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMicrophoneButton(LingLearningProvider lingLearningProvider) {
    return Positioned(
      left: 150,
      bottom: 20,
      child: AvatarGlow(
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
            child: CustomButton(
              type: ButtonType.Mic,
              onPressed: () async {
                bool permission = await requestPermissions();
                if (!permission) {
                  return;
                }
                onTapMicrophonebutton(context, lingLearningProvider, word_tmp);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideo() {
    return Positioned(
      right: 75.v,
      bottom: 120.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        child: Container(
          height: 180,
          width: 320,
          color: Colors.black, // Optional background to distinguish
          child: _controller.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover, // Ensures the video covers the container
                  child: SizedBox(
                    width: _controller.value.size.height,
                    height: _controller.value.size.width,
                    child: VideoPlayer(_controller),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildTipButton() {
    return Positioned(
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
    );
  }

  Widget _buildResult() {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.1,
      bottom: 10,
      child: circularScore(result!),
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
    print("entering in the send wav file section ! ");
    var uri;
    if (widget.testSpeech) {
      debugPrint("in the word section , request is sent ....");
      uri = Uri.parse("https://gameapi.svar.in/process_aduio_sent");
      var request = http.MultipartRequest('POST', uri)
        ..fields['text'] = phoneme
        ..files.add(await http.MultipartFile.fromPath('wav_file', wavFile));

      var response = await request.send();
      if (response.statusCode == 200) {
        String body = await response.stream.bytesToString();
        // print(body);
        Map<dynamic, dynamic> data = json.decode(body);
        debugPrint("data received is ");

        List<Map<String, String>> val = [];
        for (var item in data['result']) {
          val.add(Map<String, String>.from(item));
        }

        print(val);
        setState(() {
          wrd_map = val;
          loading = false;
        });
        return Future.value(0.0);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Something went wrong")));
        throw Exception(
            "Failed to send .wav file. Status code: ${response.statusCode}");
      }
    } else {
      uri = Uri.parse("https://gameapi.svar.in/process_wav");
      var request = http.MultipartRequest('POST', uri)
        ..fields['phoneme'] = phoneme
        ..files.add(await http.MultipartFile.fromPath('wav_file', wavFile));

      var response = await request.send();
      if (response.statusCode == 200) {
        String body = await response.stream.bytesToString();
        // print(body);
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
  }

  onTapMicrophonebutton(
      BuildContext context, LingLearningProvider provider, String? txt) async {
    try {
      provider.toggleRecording(context).then((value) async {
        if (!value) {
          setState(() {
            loading = true;
          });
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = tempDir.path;
          debugPrint('audio path is ');
          if (provider.selectedCharacter == '') {
            debugPrint("something is going wrong here ");
          }
          String path = '$tempPath/audio.wav';
          if (widget.testSpeech) {
            await sendWavFile(path, txt!);
          } else {
            await sendWavFile(
                path,
                PhonmesListModel()
                    .hindiToEnglishPhonemeMap[provider.selectedCharacter]!);
          }
        }
      });
    } catch (e) {
      print("error is caught!");
      print(e.toString());
    }
  }
}

Widget pronunciationResultWidget(
    List<Map<String, String>> result, BuildContext context, String txt) {
  double width_screen = MediaQuery.of(context).size.width;
  return Container(
    margin: EdgeInsets.fromLTRB(width_screen * 0.4, 16.0, 16.0, 16.0),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 36, 52, 36),
      borderRadius: BorderRadius.circular(16.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8.0,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            // color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: Column(
            children: [
              // Word Heading
              Container(
                padding: EdgeInsets.all(10.0), // Adjust padding as needed
                decoration: BoxDecoration(
                  // color: Colors.blue, // Background color of the circle
                  shape: BoxShape.circle, // Makes the container circular
                ),
                child: Text(
                  txt, // Replace dynamically as needed
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
              )
            ],
          ),
        ),
        // Body with phoneme results
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 4.0, 16.0, 4.0),
            child: ListView.builder(
              itemCount: result.length,
              itemBuilder: (context, index) {
                // Accessing the first entry of each map in the list
                String key = result[index].entries.first.key;
                String value = result[index].entries.first.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text(
                        key.toUpperCase(),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(221, 234, 235, 233),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: const Color.fromARGB(255, 244, 239, 239),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle the next button click
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 5.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "NEXT",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildDifficultyLevel(String label, bool isSelected) {
  return Text(
    label,
    style: TextStyle(
      fontSize: 14.0,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      color: isSelected ? Colors.orange : Colors.red,
    ),
  );
}

String selectRandomWord(dynamic hindiWords) {
  Random random = Random();
  return hindiWords[random.nextInt(hindiWords.length)];
}
