import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LingLearningDetailedTipBoxProvider extends ChangeNotifier {
  FlutterSoundRecorder? _audioRecorder;
  bool isRecording = true;

  LingLearningDetailedTipBoxProvider() {
    _audioRecorder = FlutterSoundRecorder();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _audioRecorder!.openAudioSession();
  }

  Future<bool> toggleRecording(BuildContext context) async {
    if (isRecording) {
      await stopRecording();
      return true;
    } else {
      await startRecording();
      return false;
    }
  }

  Future<void> startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/audio.wav';

    await _audioRecorder!.startRecorder(
      toFile: path,
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
