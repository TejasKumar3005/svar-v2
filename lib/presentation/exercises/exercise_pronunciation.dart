import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;
import 'package:svar_new/core/utils/image_constant.dart';
import 'package:svar_new/database/userController.dart';
import 'package:svar_new/presentation/discrimination/appbar.dart';
import 'package:svar_new/presentation/exercises/exercise_provider.dart';
import 'package:vad/vad.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'dart:math';

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

class ExercisePronunciationState extends State<ExercisePronunciation>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
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

  // Flag to track if VAD should restart after playback
  bool _shouldRestartVadAfterPlayback = false;

  // Cache screen size to avoid rebuilds
  Size? _cachedScreenSize;

  // App lifecycle state tracking
  AppLifecycleState? _lastLifecycleState;
  bool _wasVadListeningBeforePause = false;
  bool _wasSpeakingBeforePause = false;
  bool _wasPlayingRecordingBeforePause = false;

  // Parent mode state
  bool parent_mode = false;
  late String displayCharacter;
  late String originalCharacter;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    originalCharacter = widget.character;
    _setDisplayCharacter();
    _initializeWithConnectivityCheck();
  }

  void _setDisplayCharacter() {
    if (parent_mode) {
      final random = Random();
      displayCharacter =
          samplePronunciations[random.nextInt(samplePronunciations.length)];
    } else {
      displayCharacter = originalCharacter;
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Update cached screen size when screen metrics change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final newSize = MediaQuery.of(context).size;
        if (_cachedScreenSize != newSize) {
          setState(() {
            _cachedScreenSize = newSize;
          });
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('App lifecycle state changed to: $state');

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _handleAppPause();
        break;
      case AppLifecycleState.resumed:
        _handleAppResume();
        break;
      case AppLifecycleState.detached:
        _handleAppDetached();
        break;
      case AppLifecycleState.hidden:
        _handleAppPause();
        break;
    }
    _lastLifecycleState = state;
  }

  void _handleAppPause() {
    print('Handling app pause - preserving state');

    // Save current states
    _wasVadListeningBeforePause = _isVadListening;
    _wasSpeakingBeforePause = isSpeaking;
    _wasPlayingRecordingBeforePause = isPlayingRecording;

    // Stop all audio activities to free resources
    if (_isVadListening) {
      print('Stopping VAD due to app pause');
      _safeStopVadListening();
    }

    if (isSpeaking) {
      print('Stopping TTS due to app pause');
      flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    }

    if (isPlayingRecording) {
      print('Stopping recording playback due to app pause');
      _recordingPlayer.stop();
      setState(() {
        isPlayingRecording = false;
      });
    }

    // Stop other audio players
    _audioPlayer.stop();
  }

  void _handleAppResume() {
    print('Handling app resume - restoring state');

    // Small delay to ensure app is fully resumed
    Future.delayed(Duration(milliseconds: 500), () {
      if (!mounted) return;

      // Only restore VAD if we haven't completed the exercise and weren't in results
      if (_wasVadListeningBeforePause &&
          correctAttempts < REQUIRED_CORRECT_ATTEMPTS &&
          result.isEmpty &&
          !isSpeaking &&
          !isPlayingRecording) {
        print('Restoring VAD listening state');
        _safeStartVadListening();
      }

      // Reset pause state flags
      _wasVadListeningBeforePause = false;
      _wasSpeakingBeforePause = false;
      _wasPlayingRecordingBeforePause = false;
    });
  }

  void _handleAppDetached() {
    print('App detached - cleaning up resources');
    _handleAppPause();
  }

  /// Safely starts VAD listening with proper error handling and state checks
  bool _safeStartVadListening() {
    if (!mounted ||
        _isVadListening ||
        isSpeaking ||
        isPlayingRecording ||
        correctAttempts >= REQUIRED_CORRECT_ATTEMPTS ||
        result.isNotEmpty) {
      print(
          'Cannot start VAD: mounted=$mounted, vadListening=$_isVadListening, speaking=$isSpeaking, playing=$isPlayingRecording, correctAttempts=$correctAttempts, hasResults=${result.isNotEmpty}');
      return false;
    }

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
      setState(() => _isVadListening = true);
      print('VAD listening started successfully');
      return true;
    } catch (e) {
      print('Error starting VAD listening: $e');
      setState(() => _isVadListening = false);
      return false;
    }
  }

  /// Safely stops VAD listening with proper error handling
  void _safeStopVadListening() {
    if (!_isVadListening) return;

    try {
      _vadHandler.stopListening();
      setState(() {
        _isVadListening = false;
        isRecordingSegment = false;
      });
      print('VAD listening stopped successfully');
    } catch (e) {
      print('Error stopping VAD listening: $e');
      setState(() {
        _isVadListening = false;
        isRecordingSegment = false;
      });
    }
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
        speakHindiWithoutRecording(displayCharacter);
      }
    });
  }

  // Modify speakHindiWithoutRecording method
  Future<void> speakHindiWithoutRecording(String text) async {
    print("Starting TTS for text: $text");
    if (text.isEmpty) return;

    // Store VAD state and stop if it's listening
    bool wasVadListening = _isVadListening;
    if (_isVadListening) {
      print("Stopping VAD for TTS");
      _safeStopVadListening();
    }

    try {
      setState(() => isSpeaking = true);
      await flutterTts.speak(text);
      await Future.delayed(Duration(milliseconds: 2500));
    } catch (e) {
      print("Error speaking: $e");
    } finally {
      setState(() => isSpeaking = false);

      // Restart VAD if it was previously listening
      if (wasVadListening &&
          correctAttempts < REQUIRED_CORRECT_ATTEMPTS &&
          result.isEmpty) {
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted && result.isEmpty) {
            _safeStartVadListening();
          }
        });
      }
    }
  }

  Future<void> playLastRecording() async {
    if (lastRecordingPath == null) return;

    // Stop other audio sources
    await flutterTts.stop();
    await _audioPlayer.stop();

    // Store VAD state and stop if listening
    if (_isVadListening) {
      _shouldRestartVadAfterPlayback = true;
      _safeStopVadListening();
    }

    if (isPlayingRecording) {
      // Stop playback
      await _recordingPlayer.stop();
      setState(() => isPlayingRecording = false);

      // Restart VAD if it should be restarted
      _restartVadIfNeeded();
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
          if (mounted) {
            setState(() => isPlayingRecording = false);
            // Restart VAD if it should be restarted
            _restartVadIfNeeded();
          }
        });
      } catch (e) {
        print("Error playing recording: $e");
        setState(() => isPlayingRecording = false);
        showErrorSnackBar("Error playing recording");
        // Restart VAD if it should be restarted
        _restartVadIfNeeded();
      }
    }
  }

  void _restartVadIfNeeded() {
    if (_shouldRestartVadAfterPlayback &&
        correctAttempts < REQUIRED_CORRECT_ATTEMPTS &&
        result.isEmpty) {
      _shouldRestartVadAfterPlayback = false;

      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted && result.isEmpty) {
          _safeStartVadListening();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Call super.build for AutomaticKeepAliveClientMixin

    // Cache screen size to avoid unnecessary rebuilds
    _cachedScreenSize ??= MediaQuery.of(context).size;
    final size = _cachedScreenSize!;
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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: DisciAppBar(
                context,
                show_switch: true,
                parent_mode: parent_mode,
                onParentModeChanged: (value) {
                  setState(() {
                    parent_mode = value;
                    _setDisplayCharacter();
                    // Reset state if needed
                    result = [];
                    intermediateResults = [];
                    correctAttempts = 0;
                    totalAttempts = 0;
                    isRecordingComplete = false;
                  });
                },
              ),
            ), // App bar stays at the top

            // Rive animation container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: SizedBox(
                  height: size.height * 0.4,
                  width: size.width,
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
                    await speakHindi(displayCharacter);
                  },
                  child: Container(
                    width: isSmallScreen ? size.width * 0.3 : size.width * 0.2,
                    height: isSmallScreen ? size.width * 0.3 : size.width * 0.2,
                    margin: EdgeInsets.only(
                        bottom:
                            size.height * 0.2), // Move up to create space below
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        displayCharacter,
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
                bottom:
                    size.height * 0.4, // Positioned above the stepping stones
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
                            await speakHindiWithoutRecording(displayCharacter);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding:
                                const EdgeInsets.all(24), // Slightly larger
                            backgroundColor: Colors.blue[600],
                            elevation: 4,
                          ),
                          child: const Icon(Icons.volume_up,
                              color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Listen Again",
                          style: GoogleFonts.inter(
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
                              print(
                                  "Cannot start recording while TTS is speaking");
                              showErrorSnackBar(
                                  "Please wait for the audio to finish playing");
                              return;
                            }

                            if (isPlayingRecording) {
                              print(
                                  "Cannot start recording while playback is active");
                              showErrorSnackBar(
                                  "Please wait for playback to finish");
                              return;
                            }

                            if (_isVadListening) {
                              print("Stopping VAD");
                              _safeStopVadListening();
                            } else {
                              print("Starting VAD");
                              _safeStartVadListening();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding:
                                const EdgeInsets.all(24), // Slightly larger
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            style: GoogleFonts.inter(
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
                        style: GoogleFonts.inter(
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
                          style: GoogleFonts.inter(
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

      if (!mounted) {
        print('Widget not mounted, skipping speech end processing');
        return;
      }

      setState(() {
        isRecordingSegment = false;
      });

      // Stop listening before processing
      _safeStopVadListening();

      try {
        // Process the current recording.
        bool isCorrect = await processCurrentRecording(samples);
        // Increment total attempts regardless of result.
        totalAttempts++;

        // If we haven't reached the required number of correct attempts and widget is still mounted, resume listening.
        if (mounted &&
            correctAttempts < REQUIRED_CORRECT_ATTEMPTS &&
            result.isEmpty) {
          _safeStartVadListening();
        }
      } catch (e) {
        print("Error in speech end handler: $e");
        if (mounted) {
          showErrorSnackBar("Error processing recording: $e");

          if (correctAttempts < REQUIRED_CORRECT_ATTEMPTS && result.isEmpty) {
            _safeStartVadListening();
          }
        }
      }
    });

    // On Speech Start
    _vadHandler.onSpeechStart.listen((_) {
      print('Speech detected.');
      if (mounted) {
        setState(() {
          isRecordingSegment = true;
          receivedEvents.add('Speech detected - Attempt ${totalAttempts + 1}');
        });
      }
    });

    // On speech misfire
    _vadHandler.onVADMisfire.listen((_) {
      print('VAD misfire detected.');
      if (mounted) {
        setState(() {
          receivedEvents.add('VAD misfire detected.');
        });
      }
    });

    // On Error
    _vadHandler.onError.listen((String message) {
      print('VAD Error: $message');
      if (mounted) {
        setState(() {
          loading = false;
          isRecordingSegment = false;
          _isVadListening = false;
          receivedEvents.add('Error: $message');
        });
        showErrorSnackBar("Recording error: $message");
      }
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

      dynamic fullResponse = await sendWavFile(tempPath, widget.character);
      dynamic apiResult = fullResponse["result"];
      print("API Response: $fullResponse");
      // find target word in apiResult
      apiResult = apiResult is List
          ? apiResult.firstWhere(
              (item) => item is Map && item.containsKey(targetWord),
              orElse: () => null)
          : null;

      print("Filtered API Response: $apiResult");
      if (apiResult != null) {
        if (apiResult is List && apiResult.isNotEmpty) {
          apiResult[0]["url"] = fullResponse["url"];
        }
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
          } else {
            await _audioPlayer
                .play(AssetSource('assets/audio/wrong_answer.mp3'));
            await Future.delayed(Duration(milliseconds: 1000));
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
                  Text(
                    "Pronunciation Results",
                    style: GoogleFonts.inter(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Results List\\
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
                              style: GoogleFonts.inter(
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
                                style: GoogleFonts.inter(
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
                                  style: GoogleFonts.inter(
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
                  UserData(uid: FirebaseAuth.instance.currentUser!.uid)
                      .updateExerciseData(
                          euid: data_pro.todaysExercises[startExerciseIndex]
                              ["uid"],
                          date: data_pro.todaysExercises[startExerciseIndex]
                              ["date"],
                          isCompleted: false,
                          performance: {
                        "result":
                            intermediateResults.expand((list) => list).toList(),
                        "time": DateTime.now().toIso8601String(),
                        "correctAttempts": correctAttempts,
                        "totalAttempts": totalAttempts,
                      });
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
    print('Disposing ExercisePronunciationState');

    // Remove observers first
    WidgetsBinding.instance.removeObserver(this);

    // Stop all audio activities
    try {
      if (_isVadListening) {
        _vadHandler.stopListening();
        _isVadListening = false;
      }
      _vadHandler.dispose();
    } catch (e) {
      print('Error disposing VAD handler: $e');
    }

    try {
      flutterTts.stop();
    } catch (e) {
      print('Error stopping TTS: $e');
    }

    try {
      _audioPlayer.dispose();
    } catch (e) {
      print('Error disposing audio player: $e');
    }

    try {
      _recordingPlayer.dispose();
    } catch (e) {
      print('Error disposing recording player: $e');
    }

    try {
      riveController?.dispose();
    } catch (e) {
      print('Error disposing rive controller: $e');
    }

    // Clean up overlay
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      print('Error removing overlay: $e');
    }

    // Reset flags
    _shouldRestartVadAfterPlayback = false;
    _wasVadListeningBeforePause = false;
    _wasSpeakingBeforePause = false;
    _wasPlayingRecordingBeforePause = false;

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
      return jsonResponse;
    } else {
      print("API error response: $body");
      throw Exception("API Error ${response.statusCode}: $body");
    }
  } catch (e) {
    print("Error in sendWavFile: $e");
    rethrow;
  }
}
