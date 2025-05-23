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
    try {
      _wasPlayingBeforeBackground = audioPlayer.state == PlayerState.playing;
      if (_wasPlayingBeforeBackground) {
        await audioPlayer.pause();
      }
    } catch (e) {
      print('Error handling background state: $e');
    }
  }

  Future<void> _handleForegroundState() async {
    try {
      if (_wasPlayingBeforeBackground) {
        await audioPlayer.resume();
      }
    } catch (e) {
      print('Error handling foreground state: $e');
    }
  }

  // Method to play music
  Future<void> playMusic(String audio, String mime, bool repeat) async {
    try {
      // Stop any currently playing audio before playing a new one
      await stopMusic();

      // Set release mode to loop if needed
      if (repeat) {
        audioPlayer.setReleaseMode(ReleaseMode.loop);
      }

      // Play the audio - AssetSource automatically adds 'assets/' prefix
      await audioPlayer.play(
        AssetSource('audio/bgm/$audio'), // Removed 'assets/' prefix
        volume: 0.5,
      );
    } catch (e) {
      print('Error playing audio $audio: $e');
      // Optionally, you can try to continue without crashing the app
    }
  }

  // Method to stop music
  Future<void> stopMusic() async {
    try {
      if (audioPlayer.state == PlayerState.playing) {
        await audioPlayer.stop();
      }
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  // Method to set volume
  Future<void> setVolume(double volume) async {
    try {
      await audioPlayer.setVolume(volume);
    } catch (e) {
      print('Error setting volume: $e');
    }
  }

  // Cleanup method - should be called when app is disposed
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioPlayer.dispose();
  }
}
