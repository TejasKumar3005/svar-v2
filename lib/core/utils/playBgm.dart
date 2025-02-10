import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayBgm with WidgetsBindingObserver {
  // Singleton pattern implementation
  static final PlayBgm _instance = PlayBgm._internal();

  factory PlayBgm() {
    return _instance;
  }

  PlayBgm._internal() {
    AudioCache.instance = AudioCache(prefix: '');
    audioPlayer = AudioPlayer();
    // Register as lifecycle observer
    WidgetsBinding.instance.addObserver(this);
  }

  late AudioPlayer audioPlayer;
  bool _wasPlayingBeforeBackground = false;

  // Lifecycle handling
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        // App going to background
        _handleBackgroundState();
        break;
      case AppLifecycleState.resumed:
        // App coming to foreground
        _handleForegroundState();
        break;
      default:
        break;
    }
  }

  Future<void> _handleBackgroundState() async {
    _wasPlayingBeforeBackground = audioPlayer.state == PlayerState.playing;
    if (_wasPlayingBeforeBackground) {
      await audioPlayer.pause();
    }
  }

  Future<void> _handleForegroundState() async {
    if (_wasPlayingBeforeBackground) {
      await audioPlayer.resume();
    }
  }

  // Method to play music
  Future<void> playMusic(String audio, String mime, bool repeat) async {
    // Stop any currently playing audio before playing a new one
    await stopMusic();

    // Set release mode to loop if needed
    if (repeat) {
      audioPlayer.setReleaseMode(ReleaseMode.loop);
    }

    // Play the audio
    await audioPlayer.play(
      AssetSource('assets/audio/bgm/$audio', mimeType: mime),
      volume: 0.5,
    );
  }

  // Method to stop music
  Future<void> stopMusic() async {
    if (audioPlayer.state == PlayerState.playing) {
      await audioPlayer.stop();
    }
  }

  // Method to set volume
  Future<void> setVolume(double volume) async {
    await audioPlayer.setVolume(volume);
  }

  // Cleanup method - should be called when app is disposed
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioPlayer.dispose();
  }
}
