import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Enhanced state preservation mixin for maintaining state during app lifecycle changes
mixin StatePreservationMixin<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  // Audio state preservation
  bool _wasAudioPlayingBeforePause = false;
  bool _wasTTSSpeakingBeforePause = false;
  bool _wasRecordingBeforePause = false;

  // Generic state storage
  final Map<String, dynamic> _preservedState = {};

  // Timers and subscriptions to pause/resume
  final List<Timer> _pausedTimers = [];
  final List<StreamSubscription> _pausedSubscriptions = [];

  // Audio players to manage
  final List<AudioPlayer> _audioPlayers = [];
  FlutterTts? _flutterTts;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _preservedState.clear();
    _pausedTimers.clear();
    _pausedSubscriptions.clear();
    _audioPlayers.clear();
    super.dispose();
  }

  /// Register an audio player for state preservation
  void registerAudioPlayer(AudioPlayer player) {
    if (!_audioPlayers.contains(player)) {
      _audioPlayers.add(player);
    }
  }

  /// Register FlutterTts for state preservation
  void registerFlutterTts(FlutterTts tts) {
    _flutterTts = tts;
  }

  /// Save a state value with a key
  void preserveState(String key, dynamic value) {
    _preservedState[key] = value;
  }

  /// Retrieve a preserved state value
  T? getPreservedState<T>(String key) {
    return _preservedState[key] as T?;
  }

  /// Clear a preserved state value
  void clearPreservedState(String key) {
    _preservedState.remove(key);
  }

  /// Check if a state value exists
  bool hasPreservedState(String key) {
    return _preservedState.containsKey(key);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

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
  }

  /// Handle app pause - save state and pause resources
  void _handleAppPause() {
    print('StatePreservationMixin: Handling app pause');

    // Save audio states
    _saveAudioStates();

    // Pause audio resources
    _pauseAudioResources();

    // Call custom pause handler
    onAppPause();
  }

  /// Handle app resume - restore state and resume resources
  void _handleAppResume() {
    print('StatePreservationMixin: Handling app resume');

    // Small delay to ensure app is fully resumed
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        // Restore audio resources
        _resumeAudioResources();

        // Call custom resume handler
        onAppResume();
      }
    });
  }

  /// Handle app detached
  void _handleAppDetached() {
    print('StatePreservationMixin: Handling app detached');
    _handleAppPause();
    onAppDetached();
  }

  /// Save current audio states
  void _saveAudioStates() {
    try {
      // Check audio players
      _wasAudioPlayingBeforePause =
          _audioPlayers.any((player) => player.state == PlayerState.playing);

      // Check TTS state (if available)
      _wasTTSSpeakingBeforePause =
          getPreservedState<bool>('isSpeaking') ?? false;

      // Check recording state (if available)
      _wasRecordingBeforePause =
          getPreservedState<bool>('isRecording') ?? false;

      print(
          'Audio states saved: playing=$_wasAudioPlayingBeforePause, speaking=$_wasTTSSpeakingBeforePause, recording=$_wasRecordingBeforePause');
    } catch (e) {
      print('Error saving audio states: $e');
    }
  }

  /// Pause audio resources
  void _pauseAudioResources() {
    try {
      // Pause all audio players
      for (final player in _audioPlayers) {
        if (player.state == PlayerState.playing) {
          player.pause();
        }
      }

      // Stop TTS if speaking
      if (_wasTTSSpeakingBeforePause && _flutterTts != null) {
        _flutterTts!.stop();
      }

      print('Audio resources paused');
    } catch (e) {
      print('Error pausing audio resources: $e');
    }
  }

  /// Resume audio resources
  void _resumeAudioResources() {
    try {
      // Resume audio players if they were playing
      if (_wasAudioPlayingBeforePause) {
        for (final player in _audioPlayers) {
          if (player.state == PlayerState.paused) {
            player.resume();
          }
        }
      }

      // Note: TTS and recording usually need manual restart based on app logic

      print('Audio resources resumed');
    } catch (e) {
      print('Error resuming audio resources: $e');
    }
  }

  /// Override this method to handle custom app pause logic
  void onAppPause() {
    // Override in implementing classes
  }

  /// Override this method to handle custom app resume logic
  void onAppResume() {
    // Override in implementing classes
  }

  /// Override this method to handle custom app detached logic
  void onAppDetached() {
    // Override in implementing classes
  }

  /// Safely execute a function with error handling
  void safeExecute(VoidCallback function, [String? description]) {
    try {
      function();
    } catch (e) {
      print('Error in ${description ?? 'safeExecute'}: $e');
    }
  }

  /// Safely execute an async function with error handling
  Future<void> safeExecuteAsync(Future<void> Function() function,
      [String? description]) async {
    try {
      await function();
    } catch (e) {
      print('Error in ${description ?? 'safeExecuteAsync'}: $e');
    }
  }

  /// Check if the widget is still mounted before executing
  void executeIfMounted(VoidCallback function) {
    if (mounted) {
      safeExecute(function, 'executeIfMounted');
    }
  }

  /// Execute async function if widget is still mounted
  Future<void> executeIfMountedAsync(Future<void> Function() function) async {
    if (mounted) {
      await safeExecuteAsync(function, 'executeIfMountedAsync');
    }
  }

  /// Create a debounced function to prevent rapid successive calls
  VoidCallback debounce(VoidCallback function, Duration delay) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, function);
    };
  }

  /// Create a throttled function to limit call frequency
  VoidCallback throttle(VoidCallback function, Duration duration) {
    bool canExecute = true;
    return () {
      if (canExecute) {
        canExecute = false;
        function();
        Timer(duration, () => canExecute = true);
      }
    };
  }
}

/// Specialized mixin for audio-heavy widgets
mixin AudioStatePreservationMixin<T extends StatefulWidget>
    on StatePreservationMixin<T> {
  @override
  void onAppPause() {
    super.onAppPause();
    // Additional audio-specific pause logic
    preserveState('audioWasPaused', true);
  }

  @override
  void onAppResume() {
    super.onAppResume();
    // Additional audio-specific resume logic
    if (hasPreservedState('audioWasPaused')) {
      clearPreservedState('audioWasPaused');
      // Implement audio-specific resume logic here
    }
  }

  /// Safely start audio playback with state preservation
  Future<void> safeStartAudio(AudioPlayer player, String source) async {
    await safeExecuteAsync(() async {
      registerAudioPlayer(player);
      await player.play(UrlSource(source));
      preserveState('isAudioPlaying', true);
    }, 'safeStartAudio');
  }

  /// Safely stop audio playback
  Future<void> safeStopAudio(AudioPlayer player) async {
    await safeExecuteAsync(() async {
      await player.stop();
      preserveState('isAudioPlaying', false);
    }, 'safeStopAudio');
  }

  /// Safely start TTS with state preservation
  Future<void> safeStartTTS(FlutterTts tts, String text) async {
    await safeExecuteAsync(() async {
      registerFlutterTts(tts);
      await tts.speak(text);
      preserveState('isSpeaking', true);
    }, 'safeStartTTS');
  }

  /// Safely stop TTS
  Future<void> safeStopTTS(FlutterTts tts) async {
    await safeExecuteAsync(() async {
      await tts.stop();
      preserveState('isSpeaking', false);
    }, 'safeStopTTS');
  }
}
