import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioSampleExtractor {
  static const MethodChannel _channel = MethodChannel('audio_sample_extractor');
  
  Future<String> downloadAudioFile(String url) async {
  final response = await http.get(Uri.parse(url));
  final tempDir = await getTemporaryDirectory();
  final tempFilePath = '${tempDir.path}/temp_audio_file.wav';  // Adjust the file extension based on your format

  final file = File(tempFilePath);
  await file.writeAsBytes(response.bodyBytes);
  return tempFilePath;
}
  // Function to get audio samples
  Future<List<double>> getNetorkAudioSamples(String url) async {
    try {
      final filePath = await downloadAudioFile(url);

      final List<dynamic> samples = await _channel.invokeMethod('getAudioSamples', {'filePath': filePath});
      return samples.cast<double>();
    } on PlatformException catch (e) {
      print("Failed to get audio samples: '${e.message}'.");
      return [];
    }
  }
  Future<List<double>> getAssetAudioSamples(String filePath) async {
    try {
      

      final List<dynamic> samples = await _channel.invokeMethod('getAudioSamples', {'filePath': filePath});
      return samples.cast<double>();
    } on PlatformException catch (e) {
      print("Failed to get audio samples: '${e.message}'.");
      return [];
    }
  }
}
