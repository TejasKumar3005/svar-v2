// rive_preloader.dart
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RivePreloader {
  static final RivePreloader _instance = RivePreloader._internal();
  factory RivePreloader() => _instance;

  RivePreloader._internal();

  final Map<String, RiveFile?> _riveFiles = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // *** THIS IS THE CRUCIAL LINE ***
    await RiveFile.initialize(); // Initialize Rive FIRST

    print("Rive initialized"); // Print statement to confirm initialization

    print("rive file being preloaded");
    await preloadRiveFile('assets/rive/levels.riv');
    _isInitialized = true;
  }

  Future<void> preloadRiveFile(String assetPath) async {
    if (_riveFiles.containsKey(assetPath)) return;

    try {
      final data = await rootBundle.load(assetPath);
      final file = RiveFile.import(data);
      _riveFiles[assetPath] = file;
      print("rive file being preloaded successfully");
      print('Rive file "$assetPath" preloaded successfully.');
    } catch (e) {
      print("rive file being preloaded with error");
      print('Error preloading Rive file "$assetPath": $e');
      _riveFiles[assetPath] = null;
    }
  }

  RiveFile? getRiveFile(String assetPath) => _riveFiles[assetPath];
}
