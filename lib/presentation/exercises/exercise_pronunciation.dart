import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:vad/vad.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:svar_new/core/utils/playBgm.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/widgets/loading.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/utils/image_constant.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers; 
import 'package:svar_new/routes/app_routes.dart'; 
// if (kIsWeb) {
//   import 'dart:html' as html;
// }
class ExercisePronunciation extends StatefulWidget {
  final String character;
  final String eid;
  final String date;
  
  const ExercisePronunciation({
    Key? key,
    required this.character,
    required this.eid,
    required this.date
  }) : super(key: key);

  @override
  ExercisePronunciationState createState() => ExercisePronunciationState();

  static Widget builder(BuildContext context) {
    return ExercisePronunciation(character: "", eid: "", date: "");
  }
}

class ExercisePronunciationState extends State<ExercisePronunciation> {
  // Platform-specific variables
  final _vadHandler = VadHandler.create(isDebug: true);
  late FlutterSoundRecorder _micRecorder;
  StreamController<Uint8List>? _recordingDataController;
  StreamSubscription? _recordingDataSubscription;
  List<double> currentAudioBuffer = [];
  bool isRecordingSegment = false;
  final List<String> receivedEvents = [];
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  bool loading = false;
  List<Map<String, String>> result = [];
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _setupVadHandler();
    initializeApp();
  }

    void _setupVadHandler() {
    _vadHandler.onSpeechStart.listen((_) {
      debugPrint('Speech detected.');
      setState(() {
        receivedEvents.add('Speech detected.');
      });
    });

    _vadHandler.onSpeechEnd.listen((List<double> samples) {
      debugPrint('Speech ended, first 10 samples: ${samples.take(10).toList()}');
      setState(() {
        receivedEvents.add('Speech ended, first 10 samples: ${samples.take(10).toList()}');
      });
    });

    _vadHandler.onVADMisfire.listen((_) {
      debugPrint('VAD misfire detected.');
      setState(() {
        receivedEvents.add('VAD misfire detected.');
      });
    });

    _vadHandler.onError.listen((String message) {
      debugPrint('Error: $message');
      setState(() {
        receivedEvents.add('Error: $message');
      });
    });
  }

  Future<void> initializeApp() async {
    await initTTS();
    await initVAD();
    
    bool hasPermission = await requestPermissions();
    if (hasPermission) {
      await startRecording();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission required"))
      );
    }
  }
  



Future<void> initVAD() async {
  // Initialize VAD with platform-specific settings
  
  
  _setupVADHandlers();
  
  // Initialize recorder
  _micRecorder = FlutterSoundRecorder();
  if (!kIsWeb) {
    await _micRecorder.openRecorder();
  }
}

void _setupVADHandlers() {
  _vadHandler.onSpeechStart.listen((_) {
    setState(() {
      isRecordingSegment = true;
    });
    debugPrint('Speech detected');
  });

  _vadHandler.onSpeechEnd.listen((List<double> samples) async {
    setState(() {
      isRecordingSegment = false;
      loading = true;
    });
    
    // Convert samples to WAV file
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/recorded_audio.wav';
    
    // Create WAV file from samples
    final wavFile = await File(tempPath).create();
    final wavWriter = ByteData(44 + (samples.length * 2));
    
    // Write WAV header
    wavWriter.setUint32(0, 0x46464952); // "RIFF"
    wavWriter.setUint32(4, 36 + (samples.length * 2), Endian.little);
    wavWriter.setUint32(8, 0x45564157); // "WAVE"
    wavWriter.setUint32(12, 0x20746D66); // "fmt "
    wavWriter.setUint32(16, 16, Endian.little);
    wavWriter.setUint16(20, 1, Endian.little);
    wavWriter.setUint16(22, 1, Endian.little);
    wavWriter.setUint32(24, 16000, Endian.little);
    wavWriter.setUint32(28, 32000, Endian.little);
    wavWriter.setUint16(32, 2, Endian.little);
    wavWriter.setUint16(34, 16, Endian.little);
    wavWriter.setUint32(36, 0x61746164); // "data"
    wavWriter.setUint32(40, samples.length * 2, Endian.little);
    
    // Convert and write samples
    for (var i = 0; i < samples.length; i++) {
      final intSample = (samples[i] * 32767).round().clamp(-32768, 32767);
      wavWriter.setInt16(44 + (i * 2), intSample, Endian.little);
    }
    
    await wavFile.writeAsBytes(wavWriter.buffer.asUint8List());
    
    try {
      await sendWavFile(tempPath, widget.character);
    } catch (e) {
      debugPrint("Error sending wav file: $e");
      setState(() {
        loading = false;
      });
    }
  });

  _vadHandler.onVADMisfire.listen((_) {
    debugPrint('VAD misfire detected');
  });

  _vadHandler.onError.listen((String message) {
    debugPrint('VAD Error: $message');
    setState(() {
      loading = false;
      isRecordingSegment = false;
    });
  });
}

  Future<void> initTTS() async {
    if (kIsWeb) {
      await flutterTts.setLanguage("hi-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
    } else {
      await flutterTts.setLanguage("hi-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setVolume(1.0);
      
      if (Platform.isAndroid) {
        await flutterTts.setQueueMode(1);
      }
    }

    flutterTts.setCompletionHandler(() {
      setState(() => isSpeaking = false);
    });

    flutterTts.setErrorHandler((message) {
      setState(() => isSpeaking = false);
      print("TTS Error: $message");
    });
  }

  Future<bool> requestPermissions() async {
    // if (kIsWeb) {
      // try {
      //  final stream = await 
      //  stream.getTracks().forEach((track) => track.stop());
      //  return true;
      // } catch (e) {
      //   print('Error getting web permissions: $e');
      //   return false;
      // }
    // } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.storage,
      ].request();
      
      return statuses[Permission.microphone]!.isGranted && 
             statuses[Permission.storage]!.isGranted;
    // }
  }

  Future<void> startRecording() async {
  try {
    _recordingDataController = StreamController<Uint8List>();

    await _micRecorder.startRecorder(
      toStream: _recordingDataController!.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
    );

   
    
    _vadHandler.startListening(
      frameSamples: 1536,
      preSpeechPadFrames: kIsWeb ? 10 : 5,
      redemptionFrames: kIsWeb ? 8 : 4,
      minSpeechFrames: 3,
      positiveSpeechThreshold: 0.5,
      negativeSpeechThreshold: 0.35,
      submitUserSpeechOnPause: true,
    );

  } catch (e) {
    debugPrint("Error starting recording: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error starting recording: $e")),
    );
  }
}


  Future<void> speakHindi(String text) async {
    if (text.isEmpty) return;

    if (isSpeaking) {
      await flutterTts.stop();
      setState(() => isSpeaking = false);
      return;
    }

    try {
      setState(() => isSpeaking = true);
      await flutterTts.speak(text);
    } catch (e) {
      print("Error speaking: $e");
      setState(() => isSpeaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in text to speech: $e')),
      );
    }
  }

  Future<dynamic> sendWavFile(String wavFile, String word) async {
    var uri = Uri.parse("https://gameapi.svar.in/process_aduio_sent");
    
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.fields['text'] = word;

    if (kIsWeb) {
      List<int> wavBytes = await File(wavFile).readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'wav_file',
          wavBytes,
          filename: 'audio.wav'
        )
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath('wav_file', wavFile)
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      Map<String, dynamic> data = json.decode(body);

      setState(() {
        result = List<Map<String, String>>.from(
          data["result"].map((x) => Map<String, String>.from(x))
        );
        loading = false;
      });

      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      data_pro.incrementLevel();

      await UserData(uid: FirebaseAuth.instance.currentUser!.uid).updateExerciseData(
        eid: widget.eid,
        date: widget.date,
        performance: {
          "result": result,
          "word": word,
        },
      );

      return data['result'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong"))
      );
      throw Exception("Failed to send audio file. Status code: ${response.statusCode}");
    }
  }

  Widget pronunciationResultWidget(List<Map<String, String>> result, BuildContext context, String txt) {
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
              radius: 30,
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
                        SizedBox(width: 15),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
                data_pro.incrementLevel();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
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

  OverlayEntry createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Loading(),
      ),
    );
  }

  @override
  void dispose() {
    stopRecording();
    _vadHandler.dispose();
    flutterTts.stop();
    super.dispose();
  }

 Future<void> stopRecording() async {
  try {
    _vadHandler.stopListening();
    await _micRecorder.stopRecorder();
    if (!kIsWeb) {
      await _micRecorder.closeRecorder();
    }
    await _recordingDataSubscription?.cancel();
    await _recordingDataController?.close();
  } catch (e) {
    debugPrint("Error stopping recording: $e");
  }
}

  @override
  Widget build(BuildContext context) {
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
                              style: TextStyle(height: 1),
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
              if (isRecordingSegment)
                Positioned(
                  right: 150,
                  bottom: 100,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mic,
                          color: Colors.red,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Listening...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

