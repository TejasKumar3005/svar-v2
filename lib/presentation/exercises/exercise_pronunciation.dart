import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:svar_new/core/utils/image_constant.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:svar_new/routes/app_routes.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:vad/vad.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'dart:html' as html;

class ExercisePronunciation extends StatefulWidget {
  final String character;

  const ExercisePronunciation({Key? key, required this.character})
      : super(key: key);

  @override
  ExercisePronunciationState createState() => ExercisePronunciationState();

  static Widget builder(BuildContext context) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    int startExerciseIndex = obj[3] as int;
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
    return ExercisePronunciation(character: data["word"]);
  }
}

class ExercisePronunciationState extends State<ExercisePronunciation> {
  final _vadHandler = VadHandler.create(isDebug: true);
  bool isRecordingSegment = false;
  final List<String> receivedEvents = [];
  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  bool loading = false;

  OverlayEntry? _overlayEntry;
  bool isRecordingComplete = false;
  List<dynamic> result = [];
  List<dynamic> intermediateResults = [];
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
      await Future.delayed(
          Duration(milliseconds: 1500)); // Wait for speech to complete
    } catch (e) {
      print("Error speaking: $e");
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

    // And modify your post frame callback:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if the widget is still mounted before manipulating overlay
      if (!mounted) return;

      if (loading && _overlayEntry == null) {
        _overlayEntry = createOverlayEntry(context);
        Overlay.of(context).insert(_overlayEntry!);
      } else if (!loading && _overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    });

    return Scaffold(
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
              children: [],
            ),
            DisciAppBar(context),
            IgnorePointer(
              child: Positioned(
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
                    width: isSmallScreen ? size.width * 0.3 : size.width * 0.2,
                    height: isSmallScreen ? size.width * 0.3 : size.width * 0.2,
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
    );
  }

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Oh Snap!',
        message: message,
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
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
      print('Next trigger not initialized');
    }
  }

  void _setupVadHandler() {
    _vadHandler.onSpeechEnd.listen((List<double> samples) async {
      if (currentSessionCount >= TOTAL_SESSIONS) return;

      debugPrint('Speech ended for session ${currentSessionCount + 1}');
      setState(() {
        isRecordingSegment = false;
      });

      // Stop listening before processing
      _vadHandler.stopListening();
      _isVadListening = false;

      try {
        await processCurrentRecording(samples);
        currentSessionCount++;

        // Trigger animation first
        _triggerNextAnimation();

        // Wait a moment for animation
        await Future.delayed(Duration(milliseconds: 500));

        if (currentSessionCount >= TOTAL_SESSIONS) {
          setState(() {
            isRecordingComplete = true;
            loading = false;
          });
          if (intermediateResults.isNotEmpty) {
            processResults(intermediateResults);
          } else {
            throw Exception("No valid recordings processed");
          }
        } else {
          // Resume listening only if we haven't completed all sessions
          _vadHandler.startListening();
          _isVadListening = true;
        }
      } catch (e) {
        print("Error in speech end handler: $e");
        showErrorSnackBar("Error processing recording: $e");

        // Resume listening on error if we haven't completed all sessions
        if (currentSessionCount < TOTAL_SESSIONS) {
          _vadHandler.startListening();
          _isVadListening = true;
        }
      }
    });

    // On Speech Start
    _vadHandler.onSpeechStart.listen((_) {
      print('Speech detected.');
      setState(() {
        isRecordingSegment = true;
        receivedEvents
            .add('Speech detected - Session ${currentSessionCount + 1}');
      });
    });

    // On speech misfire
    _vadHandler.onVADMisfire.listen((_) {
      print('VAD misfire detected.');
      setState(() {
        receivedEvents.add('VAD misfire detected.');
      });
    });

    // On Error
    _vadHandler.onError.listen((String message) {
      print('Error: $message');
      setState(() {
        loading = false;
        isRecordingSegment = false;
        receivedEvents.add('Error: $message');
      });
    });
  }

  Future<void> initializeApp() async {
    await initTTS();
    bool hasPermission = await requestPermissions();
    if (hasPermission) {
      await startRecording();
    } else {
      showErrorSnackBar("Microphone permission required");
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
      print("TTS Error: $message");
    });
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
    ].request();

    return statuses[Permission.microphone]!.isGranted;
  }

  Future<void> processCurrentRecording(List<double> samples) async {
    setState(() => loading = true);

    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath =
          '${tempDir.path}/recorded_audio_${currentSessionCount}.wav';

      await createWavFile(samples, tempPath);

      // Send to API and validate result
      dynamic apiResult = await sendWavFile(tempPath, widget.character);
      if (apiResult != null) {
        intermediateResults.add(apiResult);
        debugPrint('Processed recording ${currentSessionCount + 1}/5');
      } else {
        debugPrint(
            'Invalid result from API for recording ${currentSessionCount + 1}');
      }
    } catch (e) {
      debugPrint("Error processing recording ${currentSessionCount + 1}: $e");
      showErrorSnackBar(
          "Error processing recording ${currentSessionCount + 1}: $e");
      throw e; // Propagate error to handle in _setupVadHandler
    } finally {
      setState(() => loading = false);
    }
  }

  void processResults(List<dynamic> allResults) {
    Map<String, List<String>> combinedResults = {};

    // Process each result from API
    for (var apiResult in allResults) {
      if (apiResult is List) {
        for (var item in apiResult) {
          if (item is Map<String, dynamic>) {
            String key = item.keys.first;
            String value = item.values.first.toString();
            combinedResults.putIfAbsent(key, () => []).add(value);
          }
        }
      }
    }

    String calculateFinalValue(List<String> values) {
      int correctCount =
          values.where((v) => v.toLowerCase().contains("correct")).length;
      return "$correctCount/5 correct pronunciations"; // Show X out of 5
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
  }

  Future<void> startRecording() async {
    try {
      _vadHandler.startListening(
        frameSamples: 1536,
        preSpeechPadFrames: kIsWeb ? 12 : 6,
        redemptionFrames: kIsWeb ? 10 : 5,
        minSpeechFrames: 3,
        positiveSpeechThreshold: 0.7,
        negativeSpeechThreshold: 0.35,
        submitUserSpeechOnPause: true,
      );
      _isVadListening = true;
    } catch (e) {
      print("Error starting recording: $e");
      showErrorSnackBar("Error starting recording: $e");
    }
  }

// Modified sendWavFile function
  Future<dynamic> sendWavFile(String wavFile, String word) async {
    try {
      var uri = Uri.parse("https://gameapi.svar.in/process_aduio_sent");
      print("Sending API request to: ${uri.toString()}");
      print("Word parameter: '$word'");
      print("WAV file path: $wavFile");

      http.MultipartRequest request = http.MultipartRequest('POST', uri);
      request.fields['text'] = word;

      if (kIsWeb) {
        List<int> wavBytes = await File(wavFile).readAsBytes();
        print("Web audio bytes length: ${wavBytes.length}");
        request.files.add(http.MultipartFile.fromBytes('wav_file', wavBytes,
            filename: 'audio.wav'));
      } else {
        print("File exists: ${File(wavFile).existsSync()}");
        print("File size: ${File(wavFile).lengthSync()} bytes");
        request.files
            .add(await http.MultipartFile.fromPath('wav_file', wavFile));
      }

      var response = await request.send();
      print("Received response status: ${response.statusCode}");

      String body = await response.stream.bytesToString();
      print("Response body: $body");

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(body);
        print("API response result: ${jsonResponse['result']}");
        return jsonResponse['result'];
      } else {
        print("API error response: $body");
        throw Exception("API Error ${response.statusCode}: $body");
      }
    } catch (e) {
      print("Error in sendWavFile: $e");
      rethrow;
    }
  }

  Future<void> createWavFile(List<double> samples, String path) async {
    final wavData = float32ToWav(samples);
    final file = File(path);
    await file.writeAsBytes(wavData);
  }

  static Uint8List float32ToWav(List<double> float32Array) {
    const int sampleRate = 16000;
    const int byteRate = sampleRate * 2; // 16-bit = 2 bytes per sample
    final int totalAudioLen = float32Array.length * 2;
    final int totalDataLen = totalAudioLen + 36;

    final ByteData buffer = ByteData(44 + totalAudioLen);

    // Write WAV header
    _writeString(buffer, 0, 'RIFF');
    buffer.setInt32(4, totalDataLen, Endian.little);
    _writeString(buffer, 8, 'WAVE');
    _writeString(buffer, 12, 'fmt ');
    buffer.setInt32(16, 16, Endian.little);
    buffer.setInt16(20, 1, Endian.little);
    buffer.setInt16(22, 1, Endian.little);
    buffer.setInt32(24, sampleRate, Endian.little);
    buffer.setInt32(28, byteRate, Endian.little);
    buffer.setInt16(32, 2, Endian.little);
    buffer.setInt16(34, 16, Endian.little);
    _writeString(buffer, 36, 'data');
    buffer.setInt32(40, totalAudioLen, Endian.little);

    // Convert and write audio data
    int offset = 44;
    for (double sample in float32Array) {
      sample = sample.clamp(-1.0, 1.0);
      final int pcm = (sample < 0 ? sample * 0x8000 : sample * 0x7FFF).toInt();
      buffer.setInt16(offset, pcm, Endian.little);
      offset += 2;
    }

    return buffer.buffer.asUint8List();
  }

  static void _writeString(ByteData view, int offset, String string) {
    for (int i = 0; i < string.length; i++) {
      view.setUint8(offset + i, string.codeUnitAt(i));
    }
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
      print("Error speaking: $e");
      setState(() => isSpeaking = false);
      showErrorSnackBar("Error in text to speech: $e");
    }
  }

  Widget pronunciationResultWidget(
      List<dynamic> result, BuildContext context, String txt) {
    var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    int startExerciseIndex = obj[3] as int;
    var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
    Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];
    if (data["completedAt"] == null) {
      print("hello");
      UserData(uid: FirebaseAuth.instance.currentUser!.uid).updateExerciseData(
        euid: data["uid"],
        date: data["date"],
      );
    }
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
                          color: value.toLowerCase().split("correct").length -
                                      1 ==
                                  5
                              ? Colors.green[600] // 5 correct - green
                              : value.toLowerCase().split("correct").length -
                                          1 >=
                                      3
                                  ? Colors.amber[600] // 3 or 4 correct - yellow
                                  : Colors.red, // Less than 3 correct - red
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
                data_pro.incrementLevel(startExerciseIndex);

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
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          color: Colors.black.withOpacity(0.3), // Semi-transparent background
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SizedBox(
                height: 50, // Smaller size
                width: 50, // Smaller size
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isVadListening) {
      _vadHandler.stopListening();
    }
    _vadHandler.dispose();
    flutterTts.stop();
    riveController?.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }
}
