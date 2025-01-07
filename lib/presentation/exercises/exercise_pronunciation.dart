import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rive/rive.dart' hide Image;
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
// import 'package:flutter_snowboy/flutter_snowboy.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';

class ExercisePronunciation extends StatefulWidget {
  final String character;
  final String eid;
  final String date;
  const ExercisePronunciation(
      {Key? key,
      required this.character,
      required this.eid,
      required this.date})
      : super(key: key);

  @override
  ExercisePronunciationState createState() => ExercisePronunciationState();

  static Widget builder(BuildContext context) {
    return ExercisePronunciation(character: "", eid: "", date: "");
  }
}

extension _TextExtension on Artboard {
  TextValueRun? textRun(String name) => component<TextValueRun>(name);
}

class ExercisePronunciationState extends State<ExercisePronunciation> {
  StreamController<Uint8List>? _recordingDataController;
  StreamSubscription? _recordingDataSubscription;
  late FlutterSoundRecorder _micRecorder;
  String? _errorMessage;
  late AudioPlayer _audioPlayer;
  var model;
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  StateMachineController? _controller;
  List<Map<String, String>>? wrd_map;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    initTTS();
    _micRecorder = FlutterSoundRecorder();
    _audioPlayer = AudioPlayer();
    super.initState();

  }

  Future<void> initTTS() async {
    // Configure TTS for Hindi
    await flutterTts.setLanguage("hi-IN");
    await flutterTts.setPitch(1.0); // Normal pitch
    await flutterTts
        .setSpeechRate(0.5); // Slower rate for better Hindi pronunciation
    await flutterTts.setVolume(1.0);

    // Optional: Set completion handler
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    // Optional: Set error handler
    flutterTts.setErrorHandler((message) {
      setState(() {
        isSpeaking = false;
      });
      print("TTS Error: $message");
    });
  }

  Future<void> speakHindi(String text) async {
    if (text.isEmpty) return;

    if (isSpeaking) {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
      return;
    }

    try {
      setState(() {
        isSpeaking = true;
      });
      await flutterTts.speak(text);
    } catch (e) {
      print("Error speaking: $e");
      setState(() {
        isSpeaking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in text to speech: $e')),
      );
    }
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

  List<Map<String, String>> result = [
  
  ];
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
                child: result.isEmpty
                    ? GestureDetector(
                        onTap: () async {
                          await speakHindi(widget.character);
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              widget.character,
                              style: TextStyle(
                                height: 1, // Helps with vertical alignment
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ),
              Positioned(
                left: 180,
                bottom: 120,
                child: result.isEmpty
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
                right: result.isEmpty ? 80 : null,
                left: result.isNotEmpty ? 80 : null,
                bottom: 0,
                child: Container(
                  height: 200,
                  width: 150,
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
              if (result.isNotEmpty)
                pronunciationResultWidget(result, context, widget.character),
            ],
          ),
        ),
      ),
    );
  }

  Widget pronunciationResultWidget(
      List<Map<String, String>> result, BuildContext context, String txt) {
    double width_screen = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.fromLTRB(width_screen * 0.4, 16.0, 16.0, 16.0),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30, // Adjust radius as needed
              child: Text(
                txt,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(
            color: Colors.white38,
            thickness: 1.0,
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 16.0, 8.0),
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  String key = result[index].entries.first.key;
                  String value = result[index].entries.first.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.emoji_emotions,
                          color: value.contains("correct")
                              ? Colors.amber[600]
                              : Colors.red,
                          size: 30,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            key.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          flex: 2,
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                var data_pro =
                    Provider.of<ExerciseProvider>(context, listen: false);
                data_pro.incrementLevel();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[900],
                foregroundColor: Colors.white, // Text Color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 12.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "NEXT",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
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

  Future<dynamic> sendWavFile(String wavFile, String word) async {
    var uri = Uri.parse("https://gameapi.svar.in/process_aduio_sent");

    var request = http.MultipartRequest('POST', uri)
      ..fields['text'] = word
      ..files.add(await http.MultipartFile.fromPath('wav_file', wavFile));

    var response = await request.send();

    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      print(body);
      Map<String, dynamic> data = json.decode(body);

      setState(() {
        result = data["result"];
        wrd_map = data["result"];
        loading = false;
      });
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      data_pro.incrementLevel();
      UserData(uid: FirebaseAuth.instance.currentUser!.uid).updateExerciseData(
        eid: widget.eid,
        date: widget.date,
        performance: {
          "result": result,
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

 List<List<Map<String, String>>> allResults = [];
  List<int> currentAudioBuffer = [];
  bool isRecordingSegment = false;
  int silenceCounter = 0;
  int attemptCount = 0;
  
  // Threshold settings
  static const int AMPLITUDE_THRESHOLD = 2000;
  static const int SILENCE_THRESHOLD = 50;
  static const int MIN_SEGMENT_LENGTH = 8000;

  void processAudioData(Uint8List audioData) {
    LingLearningProvider provider = context.read<LingLearningProvider>();
    if (!provider.isRecording) return ;

    // Convert bytes to 16-bit PCM samples
    for (int i = 0; i < audioData.length; i += 2) {
      int sample = audioData[i] | (audioData[i + 1] << 8);
      int amplitude = sample.abs();

      if (amplitude > AMPLITUDE_THRESHOLD) {
        if (!isRecordingSegment) {
          startNewSegment();
        }
        silenceCounter = 0;
      } else {
        if (isRecordingSegment) {
          silenceCounter++;
          if (silenceCounter > SILENCE_THRESHOLD) {
            completeSegment();
          }
        }
      }

      if (isRecordingSegment) {
        currentAudioBuffer.addAll([audioData[i], audioData[i + 1]]);
      }
    }
  }

  void startNewSegment() {
    isRecordingSegment = true;
    currentAudioBuffer.clear();
    silenceCounter = 0;
  }

  Future<void> completeSegment() async {
    LingLearningProvider provider = context.read<LingLearningProvider>();
    if (currentAudioBuffer.length < MIN_SEGMENT_LENGTH) {
      isRecordingSegment = false;
      currentAudioBuffer.clear();
      return;
    }

    isRecordingSegment = false;
    
    // Save buffer to temporary file
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String path = '$tempPath/audio_segment.wav';
    
    // Create WAV file with headers
    List<int> wavHeader = createWavHeader(currentAudioBuffer.length);
    await File(path).writeAsBytes(wavHeader + currentAudioBuffer);
    
    try {
      dynamic result = await sendWavFile(path, widget.character);
      if (result != null) {
        allResults.add(result);
        setState(() {
          attemptCount++;
        });

        if (attemptCount >= 5) {
          processAllResults();
          // Stop recording after 5 attempts
          onTapMicrophonebutton(context, provider);
        }
      }
    } catch (e) {
      print("Error processing audio: $e");
    }

    currentAudioBuffer.clear();
  }

  List<int> createWavHeader(int dataLength) {
    List<int> header = List<int>.filled(44, 0);
    
    // RIFF header
    header.setRange(0, 4, 'RIFF'.codeUnits);
    setInt32LE(header, 4, 36 + dataLength);
    header.setRange(8, 12, 'WAVE'.codeUnits);
    
    // fmt chunk
    header.setRange(12, 16, 'fmt '.codeUnits);
    setInt32LE(header, 16, 16);
    setInt16LE(header, 20, 1);
    setInt16LE(header, 22, 1);
    setInt32LE(header, 24, 16000);
    setInt32LE(header, 28, 32000);
    setInt16LE(header, 32, 2);
    setInt16LE(header, 34, 16);
    
    // data chunk
    header.setRange(36, 40, 'data'.codeUnits);
    setInt32LE(header, 40, dataLength);
    
    return header;
  }

  void setInt16LE(List<int> buffer, int offset, int value) {
    buffer[offset] = value & 0xFF;
    buffer[offset + 1] = (value >> 8) & 0xFF;
  }

  void setInt32LE(List<int> buffer, int offset, int value) {
    buffer[offset] = value & 0xFF;
    buffer[offset + 1] = (value >> 8) & 0xFF;
    buffer[offset + 2] = (value >> 16) & 0xFF;
    buffer[offset + 3] = (value >> 24) & 0xFF;
  }

  void processAllResults() {
    // Calculate average scores
    Map<String, List<double>> scoreAggregates = {};
    
    for (var resultSet in allResults) {
      for (var result in resultSet) {
        String key = result.keys.first;
        String value = result.values.first;
        double score = extractScore(value);
        
        if (!scoreAggregates.containsKey(key)) {
          scoreAggregates[key] = [];
        }
        scoreAggregates[key]!.add(score);
      }
    }

    List<Map<String, String>> finalResults = [];
    scoreAggregates.forEach((key, scores) {
      double average = scores.reduce((a, b) => a + b) / scores.length;
      String resultText = createResultText(average);
      finalResults.add({key: resultText});
    });

    setState(() {
      result = finalResults;
    });

    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    data_pro.incrementLevel();
    UserData(uid: FirebaseAuth.instance.currentUser!.uid).updateExerciseData(
      eid: widget.eid,
      date: widget.date,
      performance: {
        "result": finalResults,
        "word": widget.character,
      },
    );
    
    // Reset for next session
    attemptCount = 0;
    allResults.clear();
  }

  double extractScore(String value) {
    // Extract numerical score from result string based on your format
    // Example implementation:
    if (value.contains("correct")) {
      return 100.0;
    }
    return 0.0;
  }

  String createResultText(double score) {
    if (score > 80) {
      return "Pronunciation is correct";
    }
    return "Need more practice";
  }

onTapMicrophonebutton(
    BuildContext context,
    LingLearningProvider provider,
  ) async {
    try {
      if (!provider.isRecording) {
        bool permission = await requestPermissions();
        if (!permission) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Microphone permission required")),
          );
          return;
        }

        await _micRecorder.openRecorder();
        
        // Create stream controller with dynamic type
        _recordingDataController = StreamController<Uint8List>();

        await _micRecorder.startRecorder(
          toStream: _recordingDataController!.sink,  // Use dynamic sink directly
          codec: Codec.pcm16,
          numChannels: 1,
          sampleRate: 16000,
        );

        // Updated stream handling
        _recordingDataSubscription = _recordingDataController?.stream.listen((data) {
          // Handle the raw audio data directly
           processAudioData(data);
         
        });

        setState(() {
          provider.isRecording = true;
        });
      } else {
        await _micRecorder.stopRecorder();
        await _micRecorder.closeRecorder();
        await _recordingDataSubscription?.cancel();
        await _recordingDataController?.close();

        setState(() {
          provider.isRecording = false;
          isRecordingSegment = false;
          currentAudioBuffer.clear();
        });
      }
    } catch (e) {
      print("Error toggling recording: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error with recording: $e")),
      );
    }
  }

}
