
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';

class PlayAudio {
  // Singleton pattern implementation
  static final PlayAudio _instance = PlayAudio._internal();

  factory PlayAudio() {
    return _instance;
  }

  PlayAudio._internal() {
    AudioCache.instance = AudioCache(prefix: '');
    audioPlayer = AudioPlayer();
  }

  late AudioPlayer audioPlayer;

  // Method to play music
  Future<void> playMusic(String url, String mime, bool repeat) async {
    // Stop any currently playing audio before playing a new one
    await stopMusic();

    // Set release mode to loop if needed
    if (repeat) {
      audioPlayer.setReleaseMode(ReleaseMode.loop);
    }

    // Play the audio
    await audioPlayer.play(
      UrlSource(url, mimeType: mime),
    );
  }
  Future<void> playMusicFromFile(File file, String mime, bool repeat) async {
    // Stop any currently playing audio before playing a new one
    await stopMusic();
 
    // Check if the file exists
    
    // Set release mode to loop if needed
    if (repeat) {
      audioPlayer.setReleaseMode(ReleaseMode.loop);
    }

    // Play the audio
    await audioPlayer.play(
    BytesSource(file.readAsBytesSync(), mimeType: mime),
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
  void dispose() {
    try {
      audioPlayer.stop();
    audioPlayer.dispose();
    } catch (e) {
      print('Error disposing PlayAudio: $e');
    }
  }

  // Method to check if audio is currently playing
  bool get isPlaying => audioPlayer.state == PlayerState.playing;

  // Method to pause music
  Future<void> pauseMusic() async {
    try {
      if (audioPlayer.state == PlayerState.playing) {
        await audioPlayer.pause();
      }
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  // Method to resume music
  Future<void> resumeMusic() async {
    try {
      if (audioPlayer.state == PlayerState.paused) {
        await audioPlayer.resume();
      }
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }
}