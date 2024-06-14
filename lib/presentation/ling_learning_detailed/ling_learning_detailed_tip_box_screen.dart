import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svar_new/presentation/ling_learning_detailed/ling_learning_detailed_tip_box_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

class LingLearningDetailedTipBoxScreen extends StatefulWidget {
  const LingLearningDetailedTipBoxScreen({Key? key}) : super(key: key);

  @override
  LingLearningDetailedTipBoxScreenState createState() =>
      LingLearningDetailedTipBoxScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LingLearningDetailedTipBoxProvider(),
      child: LingLearningDetailedTipBoxScreen(),
    );
  }
}

class LingLearningDetailedTipBoxScreenState extends State<LingLearningDetailedTipBoxScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  var model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = ModalRoute.of(context)!.settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LingLearningDetailedTipBoxProvider>(context);

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
                left: 100,
                bottom: 120,
                child: AvatarGlow(
                  endRadius: 90.0,
                  glowColor: Colors.blue,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  animate: provider.isRecording,
                  child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: Container(
                      height: 120,
                      width: 120,
                      child: CustomButton(
                        type: ButtonType.Mic,
                        onPressed: () {
                          print("Microphone button pressed");
                          print(provider.isRecording);
                          onTapMicrophonebutton(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 120,
                bottom: 60,
                child: Container(
                  height: 50,
                  width: 100,
                  child: CustomButton(
                    type: ButtonType.Next,
                    onPressed: () {
                      NavigatorService.pushNamed(
                        AppRoutes.lingLearningQuickTipScreen,
                      );
                    },
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
                    onPressed: () {},
                  ),
                ),
              ),
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
              Navigator.pop(context);
            },
          ),
          Spacer(),
          CustomButton(
            type: ButtonType.Replay,
            onPressed: () {
              NavigatorService.pushNamed(
                AppRoutes.welcomeScreenPotraitScreen,
              );
            },
          ),
          SizedBox(width: 5,),
          CustomButton(
            type: ButtonType.FullVolume,
            onPressed: () {},
          ),
        ],
      ),
    );
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
      throw Exception("Failed to send .wav file. Status code: ${response.statusCode}");
    }
  }

  onTapMicrophonebutton(BuildContext context) async {
    bool done = await context.read<LingLearningDetailedTipBoxProvider>().toggleRecording(context);
    if (done) {
      Directory tempDir = await getTemporaryDirectory();
      print("hereafewfwef");
      String tempPath = tempDir.path;
      String path = '$tempPath/audio.wav';
      var ans = await sendWavFile(path, model.typeTxt.value);
      print(ans);
      model.result = ans;
      Navigator.pushNamed(context, AppRoutes.lingLearningScreen, arguments: model);
    }
  }
}
