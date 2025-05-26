import 'dart:io'; // For File
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:svar_new/data/models/levelManagementModel/visual.dart';

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

  static Future<void> cacheFilesInIsolate(List<dynamic> exercises) async {
    List<String> urls = [];
    urls= urlsFromExercises(exercises);
    preloadFiles(urls);

  }

  // Access cached file or download and cache it if not found
  Future<File?> getCachedFile(String fileUrl) async {
    try {
      // Try to get the file from cache
      print("getting from cache"+fileUrl);
      final cachedFile = await DefaultCacheManager().getFileFromCache(fileUrl);
      if (cachedFile != null ) {
        print("cached file");
        return cachedFile.file; // Return the cached file
      } else {
        // If not in cache, download and cache it

        print("not cached");
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

  static List<String> urlsFromExercises(List<dynamic> exercises)  {
    List<String> urls = [];
    for (var exercise in exercises) {
      var type = exercise["type"];
      if (type == "video") {
        if (exercise["video"] != null) urls.add(exercise["video"]);
        if (exercise["video_url"] != null) urls.add(exercise["video_url"]);
      } else if (type == "ImageToAudio") {
        ImageToAudio imageToAudio = ImageToAudio.fromJson(exercise);
        urls.add(imageToAudio.image_url);
        urls.addAll(imageToAudio.audio_list);
      } else if (type == "WordToFig") {
        WordToFiG wordToFiG = WordToFiG.fromJson(exercise);
        urls.add(wordToFiG.image_url);
        urls.addAll(wordToFiG.image_url_list);
      } else if (type == "FigToWord") {
        FigToWord figToWord = FigToWord.fromJson(exercise);
        urls.add(figToWord.image_url);
      } else if (type == "AudioToImage") {
        AudioToImage audioToImage = AudioToImage.fromJson(exercise);
        urls.addAll(audioToImage.audio_url);
        urls.addAll(audioToImage.image_list);
      } else if (type == "AudioToAudio") {
        AudioToAudio audioToAudio = AudioToAudio.fromJson(exercise);
        urls.addAll(audioToAudio.audio_list);
      } else if (type == "Muted&Unmuted") {
        MutedUnmuted mutedUnmuted = MutedUnmuted.fromJson(exercise);
        urls.addAll(mutedUnmuted.video_url);
      } else if (type == "HalfMuted") {
        HalfMuted halfMuted = HalfMuted.fromJson(exercise);
        urls.addAll(halfMuted.video_url);
      } else if (type == "DiffSounds") {
        DiffSounds diffSounds = DiffSounds.fromJson(exercise);
        urls.addAll(diffSounds.video_url);
      } else if (type == "OddOne") {
        OddOne oddOne = OddOne.fromJson(exercise);
        urls.addAll(oddOne.video_url);
      } else if (type == "DiffHalf") {
        DiffHalf diffHalf = DiffHalf.fromJson(exercise);
        urls.addAll(diffHalf.video_url);
      } else {}
    }
  
    print("returning urls $urls");
    return urls;
  }
}
