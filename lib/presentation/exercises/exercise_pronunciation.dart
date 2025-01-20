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
import 'package:rive/rive.dart' as rive;
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/utils/image_constant.dart';
import 'package:svar_new/routes/app_routes.dart';
// import 'dart:html' as html;

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

class ExercisePronunciationState extends State<ExercisePronunciation> {
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
  bool isRecordingEnabled = true;
  bool _isVadListening = false;

  // Session tracking variables
  int currentSessionCount = 0;
  static const int TOTAL_SESSIONS = 5;
  List<List<double>> audioSessions = [];

  // Rive variables
  rive.StateMachineController? riveController;
  rive.SMITrigger? _nextTrigger;
  rive.RiveAnimationController? controller;

  @override
  void initState() {
    super.initState();
    _setupVadHandler();
    initializeApp();

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        speakHindiWithoutRecording(widget.character);
      }
    });
  }

  // Modify speakHindiWithoutRecording method
  Future<void> speakHindiWithoutRecording(String text) async {
    if (text.isEmpty) return;
    
    // Temporarily pause VAD
    final wasListening = _isVadListening;
    if (wasListening) {
      _vadHandler.stopListening();
      _isVadListening = false;
    }

    try {
      setState(() => isSpeaking = true);
      await flutterTts.speak(text);
      await Future.delayed(Duration(milliseconds: 1500)); // Wait for speech to complete
    } catch (e) {
      debugPrint("Error speaking: $e");
    } finally {
      setState(() => isSpeaking = false);
      // Resume VAD if it was listening before
      if (wasListening && mounted) {
        _vadHandler.startListening();
        _isVadListening = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

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
          width: size.width,
          height: size.height,
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
              // Rive animation - larger and positioned at bottom left
              Positioned(
                left: 0,
                bottom: size.height * 0,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: rive.RiveAnimation.asset(
                    'assets/rive/5_stepping_stone.riv',
                    onInit: _onRiveInit,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Hindi character - centered and larger
              if (result.isEmpty)
                Positioned(
                  left: size.width * 0.4,
                  top: size.height * 0.35,
                  child: GestureDetector(
                    onTap: () async {
                      await speakHindi(widget.character);
                    },
                    child: Container(
                      width:
                          isSmallScreen ? size.width * 0.3 : size.width * 0.2,
                      height:
                          isSmallScreen ? size.width * 0.3 : size.width * 0.2,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          widget.character,
                          style: TextStyle(
                            height: 1,
                            fontSize: isSmallScreen ? 60 : 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: size.width * 0.02,
                bottom: size.height * 0.08,
                child: SizedBox(
                  height: isSmallScreen ? 50 : 70,
                  width: isSmallScreen ? 50 : 70,
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
                  right: size.width * 0.2,
                  bottom: size.height * 0.15,
                  child: Container(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mic,
                          color: Colors.red,
                          size: isSmallScreen ? 20 : 24,
                        ),
                        SizedBox(width: isSmallScreen ? 6 : 8),
                        Text(
                          "Recording ${currentSessionCount + 1}/5",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
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

  void _onRiveInit(rive.Artboard artboard) {
    final controller =
        rive.StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
      riveController = controller;
      _nextTrigger = controller.findInput<bool>('next') as rive.SMITrigger;
    }
  }

  void _triggerNextAnimation() {
    if (_nextTrigger != null) {
      _nextTrigger!.fire();
    } else {
      debugPrint('Next trigger not initialized');
    }
  }

  void _setupVadHandler() {
    _vadHandler.onSpeechStart.listen((_) {
      debugPrint('Speech detected.');
      setState(() {
        isRecordingSegment = true;
        receivedEvents
            .add('Speech detected - Session ${currentSessionCount + 1}');
      });
    });

    _vadHandler.onSpeechEnd.listen((List<double> samples) async {
      if (!isRecordingEnabled) return;

      debugPrint('Speech ended for session ${currentSessionCount + 1}');
      setState(() {
        isRecordingSegment = false;
      });

      audioSessions.add(List<double>.from(samples));
      currentSessionCount++;
      _triggerNextAnimation();

      if (currentSessionCount >= TOTAL_SESSIONS) {
        setState(() {
          loading = true;
          isRecordingEnabled = false; // Stop further recordings
        });
        await stopRecording(); // Stop the recorder
        await processAllRecordings();
      }
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
        loading = false;
        isRecordingSegment = false;
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
          const SnackBar(content: Text("Microphone permission required")));
    }
  }

  Future<void> initVAD() async {
    _micRecorder = FlutterSoundRecorder();
    if (!kIsWeb) {
      await _micRecorder.openRecorder();
    }
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
      debugPrint("TTS Error: $message");
    });
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      
    ].request();

    return statuses[Permission.microphone]!.isGranted ;
    
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
      _isVadListening = true;
      _vadHandler.startListening(
        frameSamples: 1536,
        preSpeechPadFrames: kIsWeb ? 12 : 6,
        redemptionFrames: kIsWeb ? 10 : 5,
        minSpeechFrames: 3,
        positiveSpeechThreshold: 0.8,
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

  Future<void> processAllRecordings() async {
    try {
      List<String> wavPaths = [];
      final tempDir = await getTemporaryDirectory();

      // Create WAV files for all sessions
      for (int i = 0; i < audioSessions.length; i++) {
        final tempPath = '${tempDir.path}/recorded_audio_$i.wav';
        await createWavFile(audioSessions[i], tempPath);
        wavPaths.add(tempPath);
      }

      // Process all recordings
      List<dynamic> results = await Future.wait(
          wavPaths.map((path) => sendWavFile(path, widget.character)));

      // Combine results
      processResults(results);
    } catch (e) {
      debugPrint("Error processing recordings: $e");
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error processing recordings: $e")));
    }
  }

  Future<void> createWavFile(List<double> samples, String path) async {
    final wavFile = await File(path).create();
    final wavWriter = ByteData(44 + (samples.length * 2));

    // Write WAV header
    wavWriter.setUint32(0, 0x46464952);
    wavWriter.setUint32(4, 36 + (samples.length * 2), Endian.little);
    wavWriter.setUint32(8, 0x45564157);
    wavWriter.setUint32(12, 0x20746D66);
    wavWriter.setUint32(16, 16, Endian.little);
    wavWriter.setUint16(20, 1, Endian.little);
    wavWriter.setUint16(22, 1, Endian.little);
    wavWriter.setUint32(24, 16000, Endian.little);
    wavWriter.setUint32(28, 32000, Endian.little);
    wavWriter.setUint16(32, 2, Endian.little);
    wavWriter.setUint16(34, 16, Endian.little);
    wavWriter.setUint32(36, 0x61746164);
    wavWriter.setUint32(40, samples.length * 2, Endian.little);

    // Write samples
    for (var i = 0; i < samples.length; i++) {
      final intSample = (samples[i] * 32767).round().clamp(-32768, 32767);
      wavWriter.setInt16(44 + (i * 2), intSample, Endian.little);
    }

    await wavFile.writeAsBytes(wavWriter.buffer.asUint8List());
  }

  Future<dynamic> sendWavFile(String wavFile, String word) async {
    var uri = Uri.parse("https://gameapi.svar.in/process_aduio_sent");

    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.fields['text'] = word;

    if (kIsWeb) {
      List<int> wavBytes = await File(wavFile).readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('wav_file', wavBytes,
          filename: 'audio.wav'));
    } else {
      request.files.add(await http.MultipartFile.fromPath('wav_file', wavFile));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      return json.decode(body)['result'];
    } else {
      throw Exception(
          "Failed to send audio file. Status code: ${response.statusCode}");
    }
  }

  void processResults(List<dynamic> results) {
    Map<String, List<String>> combinedResults = {};

    // Combine all results
    for (var result in results) {
      for (var item in result) {
        String key = item.keys.first;
        String value = item.values.first;
        combinedResults.putIfAbsent(key, () => []).add(value);
      }
    }

    // Calculate final results
    List<Map<String, String>> finalResults = [];
    combinedResults.forEach((key, values) {
      String finalValue = calculateFinalValue(values);
      finalResults.add({key: finalValue});
    });

    setState(() {
      result = finalResults;
      loading = false;
    });

    // Update exercise data
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    data_pro.incrementLevel();

    UserData(uid: FirebaseAuth.instance.currentUser!.uid).updateExerciseData(
      eid: widget.eid,
      date: widget.date,
      performance: {
        "result": result,
        "word": widget.character,
      },
    );
  }

  String calculateFinalValue(List<String> values) {
    int correctCount = values.where((v) => v.contains("correct")).length;
    double percentage = correctCount / values.length;

    if (percentage >= 0.8)
      return "Excellent pronunciation!";
    else if (percentage >= 0.6)
      return "Good pronunciation";
    else if (percentage >= 0.4)
      return "Fair pronunciation";
    else
      return "Needs improvement";
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
      debugPrint("Error speaking: $e");
      setState(() => isSpeaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in text to speech: $e')),
      );
    }
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
                          color: value.toLowerCase().contains("excellent") ||
                                  value.toLowerCase().contains("good")
                              ? Colors.amber[600]
                              : Colors.red,
                          size: 30,
                        ),
                        const SizedBox(width: 15),
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
                foregroundColor: Colors.white,
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

  OverlayEntry createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => const Positioned(
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
    if (_isVadListening) {
      _vadHandler.stopListening();
    }
    stopRecording();
    _vadHandler.dispose();
    flutterTts.stop();
    riveController?.dispose();
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
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
