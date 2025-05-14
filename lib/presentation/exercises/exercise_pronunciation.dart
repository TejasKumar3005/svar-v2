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
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();
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

  // Remove the fixed session count and use a total attempt counter instead.
  int totalAttempts = 0;

  // Rive variables
  rive.StateMachineController? riveController;
  rive.SMITrigger? _nextTrigger;
  rive.RiveAnimationController? controller;

  // Correct attempts count; once 5 correct pronunciations are received, we finish.
  int correctAttempts = 0;
  static const int REQUIRED_CORRECT_ATTEMPTS = 5;

  String? lastRecordingPath;
  bool isPlayingRecording = false;
  final AudioPlayer _recordingPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeWithConnectivityCheck();
  }

  Future<void> _initializeWithConnectivityCheck() async {
    bool isConnected = await checkConnectivity();
    if (!isConnected) {
      showErrorSnackBar(
          'No internet connection. Please check your connection and try again.');
      return;
    }

    _setupVadHandler(); // Setup VAD (it won't start automatically)
    initializeApp();

    // Only play TTS at start
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        speakHindiWithoutRecording(widget.character);
      }
    });
  }

  // Modify speakHindiWithoutRecording method
  Future<void> speakHindiWithoutRecording(String text) async {
    print("Starting TTS for text: $text");
    if (text.isEmpty) return;

    // Stop VAD if it's listening
    if (_isVadListening) {
      print("Stopping VAD for TTS");
      _vadHandler.stopListening();
      setState(() {
        _isVadListening = false;
      });
    }

    try {
      setState(() => isSpeaking = true);
      await flutterTts.speak(text);
      await Future.delayed(Duration(milliseconds: 2500));
    } catch (e) {
      print("Error speaking: $e");
    } finally {
      setState(() => isSpeaking = false);
      // Don't automatically restart VAD - let user control it
    }
  }

  Future<void> playLastRecording() async {
    if (lastRecordingPath == null) return;

    // Stop other audio sources
    await flutterTts.stop();
    await _audioPlayer.stop();

    if (_isVadListening) {
      _vadHandler.stopListening();
      setState(() => _isVadListening = false);
    }

    if (isPlayingRecording) {
      // Stop playback
      await _recordingPlayer.stop();
      setState(() => isPlayingRecording = false);
    } else {
      // Start playback
      setState(() => isPlayingRecording = true);

      try {
        if (kIsWeb) {
          // Handle web playback
          await _recordingPlayer.play(DeviceFileSource(lastRecordingPath!));
        } else {
          // Handle mobile playback
          await _recordingPlayer.play(DeviceFileSource(lastRecordingPath!));
        }

        // Listen for playback completion
        _recordingPlayer.onPlayerComplete.listen((_) {
          setState(() => isPlayingRecording = false);
        });
      } catch (e) {
        print("Error playing recording: $e");
        setState(() => isPlayingRecording = false);
        showErrorSnackBar("Error playing recording");
      }
    }
  }

@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final isSmallScreen = size.width < 600;

  // Post frame callback for overlay management
  WidgetsBinding.instance.addPostFrameCallback((_) {
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
          // Background elements
          DisciAppBar(context), // App bar stays at the top
          
          // Rive animation container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: SizedBox(
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width,
                child: rive.RiveAnimation.asset(
                  'assets/rive/5_stepping_stone.riv',
                  onInit: _onRiveInit,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Main character display with improved positioning
          if (result.isEmpty)
            Positioned(
                left: 0,
              right: 0,
              top: size.height * 0.2, // Adjusted to create space above
               // Center the character horizontally and vertically
              child: GestureDetector(
                onTap: () async {
                  await speakHindi(widget.character);
                },
                child: Container(
                  width: isSmallScreen ? size.width * 0.3 : size.width * 0.2,
                  height: isSmallScreen ? size.width * 0.3 : size.width * 0.2,
                  margin: EdgeInsets.only(bottom: size.height * 0.2), // Move up to create space below
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      widget.character,
                      style: TextStyle(
                        height: 1,
                        fontSize: isSmallScreen ? 60 : 80,
                        fontFamily: "Comic Sans MS",
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Main UI control layout centered beneath the character
          if (result.isEmpty)
            Positioned(
              bottom: size.height * 0.4, // Positioned above the stepping stones
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Listen Again Button
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          print("TTS button pressed");
                          if (_isVadListening) {
                            print("Stopping VAD for TTS");
                            _vadHandler.stopListening();
                            _isVadListening = false;
                          }
                          await speakHindiWithoutRecording(widget.character);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24), // Slightly larger
                          backgroundColor: Colors.blue[600],
                          elevation: 4,
                        ),
                        child: const Icon(Icons.volume_up,
                            color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Listen Again",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  
                  // Spacing between buttons
                  SizedBox(width: size.width * 0.15),
                  
                  // Record Button
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          print("VAD button pressed");
                          if (isSpeaking) {
                            print("Cannot start recording while TTS is speaking");
                            showErrorSnackBar("Please wait for the audio to finish playing");
                            return;
                          }

                          setState(() {
                            if (_isVadListening) {
                              print("Stopping VAD");
                              _vadHandler.stopListening();
                              _isVadListening = false;
                            } else {
                              print("Starting VAD");
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
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24), // Slightly larger
                          backgroundColor: _isVadListening
                              ? Colors.red[600]
                              : Colors.green[600],
                          elevation: 4,
                        ),
                        child: Icon(
                          _isVadListening ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isVadListening
                              ? Colors.red[50]
                              : Colors.green[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isVadListening
                                ? Colors.red[200]!
                                : Colors.green[200]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _isVadListening
                              ? "Listening..."
                              : "Ready to Record",
                          style: TextStyle(
                            color: _isVadListening
                                ? Colors.red[700]
                                : Colors.green[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Play Last Recording button (only shown when available)
          if (result.isEmpty && lastRecordingPath != null)
            Positioned(
              top: size.height * 0.15, // Positioned near the top
              right: size.width * 0.05, // Aligned to the right
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await playLastRecording();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Colors.purple[700],
                        elevation: 2,
                      ),
                      child: Icon(
                        isPlayingRecording ? Icons.stop : Icons.play_arrow,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Play Recording",
                      style: TextStyle(
                        color: Colors.purple[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          if (result.isNotEmpty)
            pronunciationResultWidget(result, context, widget.character),
            
          // Recording indicator
          if (isRecordingSegment)
            Positioned(
              top: size.height * 0.15, // Positioned at the top
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        "Recording attempt ${totalAttempts + 1}",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
      debugPrint('Speech ended');
      setState(() {
        isRecordingSegment = false;
      });

      // Stop listening before processing
      _vadHandler.stopListening();
      _isVadListening = false;

      try {
        // Process the current recording.
        bool isCorrect = await processCurrentRecording(samples);
        // Increment total attempts regardless of result.
        totalAttempts++;

        // If we haven't reached the required number of correct attempts, resume listening.
        if (correctAttempts < REQUIRED_CORRECT_ATTEMPTS) {
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
        }
      } catch (e) {
        print("Error in speech end handler: $e");
        showErrorSnackBar("Error processing recording: $e");

        if (correctAttempts < REQUIRED_CORRECT_ATTEMPTS) {
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
        }
      }
    });

    // On Speech Start
    _vadHandler.onSpeechStart.listen((_) {
      print('Speech detected.');
      setState(() {
        isRecordingSegment = true;
        receivedEvents.add('Speech detected - Attempt ${totalAttempts + 1}');
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
    if (!hasPermission) {
      showErrorSnackBar("Microphone permission required");
    }
    // Removed startRecording() call from here.
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

  Future<bool> processCurrentRecording(List<double> samples) async {
    print("Processing current recording");
    setState(() => loading = true);

    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath =
          '${tempDir.path}/recorded_audio_${intermediateResults.length}.wav';
      await createWavFile(samples, tempPath);

      setState(() {
        lastRecordingPath = tempPath;
      });

      // Get the exercise data to access the correct phoneme
      var obj = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
      int startExerciseIndex = obj[3] as int;
      var data_pro = Provider.of<ExerciseProvider>(context, listen: false);
      Map<String, dynamic> data = data_pro.todaysExercises[startExerciseIndex];

      // Extract the correct phoneme from data
      String correctPhoneme = data["phoneme"] ?? "";

      // Extract just the first Hindi word if there are multiple parts
      String targetWord = correctPhoneme.split(" ")[0];

      dynamic apiResult = await sendWavFile(tempPath, targetWord);
      print("API Response: $apiResult");

      if (apiResult != null) {
        intermediateResults.add(apiResult is List ? apiResult : [apiResult]);

        List<dynamic> results = apiResult is List ? apiResult : [apiResult];
      var item = results[0];
          if (item is Map) {
            String resultText = item.values.first.toString().toLowerCase();
            // Check if the pronunciation matches the correct phoneme
            bool isCorrectPronunciation =
                resultText.contains('correctly') && correctPhoneme.isNotEmpty;

            if (isCorrectPronunciation) {
              correctAttempts++;
              _triggerNextAnimation();

              if (correctAttempts >= REQUIRED_CORRECT_ATTEMPTS) {
                setState(() {
                  isRecordingComplete = true;
                  loading = false;
                });
                processResults(intermediateResults);
                return true;
              }
              return true;
            }
          }
        

        // Play wrong answer sound if pronunciation is incorrect
        await _audioPlayer.play(AssetSource('assets/audio/wrong_answer.mp3'));
        await Future.delayed(Duration(milliseconds: 1000));
      }
      return false;
    } catch (e) {
      print("Error in processCurrentRecording: $e");
      showErrorSnackBar("Error processing recording: $e");
      return false;
    } finally {
      setState(() => loading = false);
    }
  }

  void processResults(List<dynamic> allResults) {
    Map<String, List<String>> combinedResults = {};

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

    List<Map<String, String>> finalResults = [];
    combinedResults.forEach((key, values) {
      int correctCount =
          values.where((v) => v.toLowerCase().contains("correct")).length;
      finalResults
          .add({key: "$correctCount/${values.length} attempts correct"});
    });

    setState(() {
      result = finalResults;
      loading = false;
    });
  }

  Future<void> createWavFile(List<double> samples, String path) async {
    final wavData = float32ToWav(samples);
    final file = File(path);
    await file.writeAsBytes(wavData);
  }

  static Uint8List float32ToWav(List<double> float32Array) {
    const int sampleRate = 16000;
    const int byteRate = sampleRate * 2;
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * 0.6,
        height: screenHeight * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.record_voice_over,
                      color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    "Pronunciation Results",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Results List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                itemCount: intermediateResults.length,
                itemBuilder: (context, attemptIndex) {
                  var attemptResult = intermediateResults[attemptIndex];
                  bool isCorrect = false;
                  String feedback = "";

                  if (attemptResult is List && attemptResult.isNotEmpty) {
                    var firstResult = attemptResult[0];
                    if (firstResult is Map) {
                      feedback = firstResult.values.first.toString();
                      isCorrect = feedback.toLowerCase().contains('correctly');
                    }
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isCorrect ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color:
                            isCorrect ? Colors.green[200]! : Colors.red[200]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCorrect
                                  ? Colors.green[400]!
                                  : Colors.red[400]!,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "${attemptIndex + 1}",
                              style: TextStyle(
                                color: isCorrect
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$txt $feedback",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: isCorrect
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (isCorrect)
                                Text(
                                  "Great job!",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.green[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Icon(
                          isCorrect ? Icons.check_circle : Icons.error,
                          color:
                              isCorrect ? Colors.green[400] : Colors.red[400],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (correctAttempts >= REQUIRED_CORRECT_ATTEMPTS) {
                    data_pro.incrementLevel(startExerciseIndex);
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("NEXT"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
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
    _recordingPlayer.dispose();
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

  Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('gameapi.svar.in');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
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
      request.files.add(await http.MultipartFile.fromPath('wav_file', wavFile));
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
