import 'dart:io'; // For File
import 'dart:isolate';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:svar_new/data/models/levelManagementModel/visual.dart';

import 'package:svar_new/data/models/userModel.dart';
import 'package:svar_new/database/userController.dart';

class CachingManager {
  static void preloadFiles(List<String> urls) async {
    for (String url in urls) {
      try {
        print("Preloading $url");	
        await DefaultCacheManager().downloadFile(url);
      } catch (e) {
        print("Error preloading $url: $e");
      }
    }
  }

static Future<void> cacheFilesInIsolate(LevelMap levelMap) async {
    // Create a receive port to get messages back from the isolate
    final receivePort = ReceivePort();

    // Spawn the isolate and pass the file cache handler along with the receive port's send port
    await Isolate.spawn(cacheLevel, [levelMap, receivePort.sendPort]);

    // Wait for completion message from the isolate
    await receivePort.first;
  }
  // Access cached file or download and cache it if not found
  Future<File?> getCachedFile(String fileUrl) async {
    try {
      // Try to get the file from cache
      final cachedFile = await DefaultCacheManager().getFileFromCache(fileUrl);
      if (cachedFile != null && cachedFile.file != null) {
        return cachedFile.file; // Return the cached file
      } else {
        // If not in cache, download and cache it
        final downloadedFile =
            await DefaultCacheManager().downloadFile(fileUrl);
        return downloadedFile.file;
      }
    } catch (e) {
      print("Error accessing cached file: $e");
      return null;
    }
  }

  // Clear the cache if needed
  Future<void> clearCache() async {
    try {
      await DefaultCacheManager().emptyCache();
      print("Cache cleared successfully.");
    } catch (e) {
      print("Error clearing cache: $e");
    }
  }

  static void cacheLevel(List<dynamic> arguments) async {
    try {
      List<String> levels = [
        "Detection",
        "Discrimination",
        "Identification",
        "Level"
      ];
      LevelMap levelMap = arguments[0];
      SendPort sendPort = arguments[1];
      for (String levelName in levels) {
        print("Caching level: $levelName-${levelMap.toJson()[levelName]}");
        int level = levelMap.toJson()[levelName];
        dynamic levelData = await UserData().fetchData(levelName, level);
        if (levelData != null) {
          String type = levelData["type"];
          if(type=="video"){
             preloadFiles([levelData["video_url"]]);
          }
          else if (type == "ImageToAudio") {
            ImageToAudio imageToAudio = ImageToAudio.fromJson(levelData);
            List<String> urls = [];
            urls.add(imageToAudio.image_url);
            urls.addAll(imageToAudio.audio_list);
             preloadFiles(urls);
          } else if (type == "WordToFig") {
            WordToFiG wordToFiG = WordToFiG.fromJson(levelData);
            List<String> urls = [];
            urls.add(wordToFiG.image_url);
            urls.addAll(wordToFiG.image_url_list);
             preloadFiles(urls);
          } else if (type == "FigToWord") {
            FigToWord figToWord = FigToWord.fromJson(levelData);
            List<String> urls = [];
            urls.add(figToWord.image_url);
             preloadFiles(urls);
          } else if (type == "AudioToImage") {
            AudioToImage audioToImage = AudioToImage.fromJson(levelData);
            List<String> urls = [];
            urls.add(audioToImage.audio_url);
            urls.addAll(audioToImage.image_list);
             preloadFiles(urls);
          } else if (type == "AudioToAudio") {
            AudioToAudio audioToAudio= AudioToAudio.fromJson(levelData);
            List<String> urls = [];
            urls.addAll(audioToAudio.audio_list);
             preloadFiles(urls);
          } else if (type == "Muted&Unmuted") {
          MutedUnmuted mutedUnmuted=  MutedUnmuted.fromJson(levelData);
            List<String> urls = [];
            urls.addAll(mutedUnmuted.video_url);
             preloadFiles(urls);
          } else if (type == "HalfMuted") {
          HalfMuted halfMuted=  HalfMuted.fromJson(levelData);
            List<String> urls = [];
            urls.add(halfMuted.video_url);
             preloadFiles(urls);
          } else if (type == "DiffSounds") {
            DiffSounds diffSounds= DiffSounds.fromJson(levelData);
            List<String> urls = [];
            urls.addAll(diffSounds.video_url);
             preloadFiles(urls);

          } else if (type == "OddOne") {
          OddOne oddOne=  OddOne.fromJson(levelData);
            List<String> urls = [];
          
            urls.addAll(oddOne.video_url);

             preloadFiles(urls);
          } else if (type == "DiffHalf") {
          DiffHalf diffHalf=  DiffHalf.fromJson(levelData);
            List<String> urls = [];
            urls.addAll(diffHalf.video_url);
             preloadFiles(urls);
          } else {}
        }
      }
    } catch (e) {
      print("Error caching level: $e");
    }
  }
}
