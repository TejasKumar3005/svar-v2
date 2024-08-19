import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class LingLearningProvider extends ChangeNotifier {
  String _selectedCharacter = '';
  String selectedTip = '';

  String get selectedCharacter => _selectedCharacter;

  void setSelectedCharacter(String character) {
    _selectedCharacter = character;
    notifyListeners(); // Notify listeners to update the UI.
  }
  void setTip(String tip) {
    selectedTip = tip;
    notifyListeners(); // Notify listeners to update the UI.
  }	

  FlutterSoundRecorder? _audioRecorder;
  bool isRecording = false;

  LingLearningProvider() {
    _audioRecorder = FlutterSoundRecorder();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    print("audio recorder initiliased");
    await _audioRecorder!.openAudioSession();
  }

  Future<bool> toggleRecording(BuildContext context) async {
    if (isRecording) {
      await _audioRecorder!.stopRecorder();
    isRecording = false;
    notifyListeners();

      return false;
    } else {
      await startRecording();

      return true;
    }
  }

  Future<void> startRecording() async {
      
     if (kIsWeb) {
      // Handle web case
      print("Recording is not supported on web.");
      return;
    }
  

    Directory tempDir = await getTemporaryDirectory();
    print(tempDir);
    String path = '${tempDir.path}/audio.wav';

    await _audioRecorder!.startRecorder(
      toFile: path	,
      codec: Codec.pcm16WAV,
    );
    isRecording = true;
    notifyListeners();

  }

  Future<void> stopRecording() async {
    await _audioRecorder!.stopRecorder();
    isRecording = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    super.dispose();
  }
}
