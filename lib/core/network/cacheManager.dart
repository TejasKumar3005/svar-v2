import 'dart:io'; // For File
import 'dart:isolate';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:svar_new/data/models/levelManagementModel/visual.dart';
import 'package:firebase_core/firebase_core.dart';
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
    List<String> urls=[];
    await urlsForCaching(levelMap).then((value){
      print("inside");
      urls=value;
    });
    print("these url for caching $urls");
    // Spawn the isolate and pass the file cache handler along with the receive port's send port
    // await Isolate.spawn(cacheLevel, urls);
    cacheLevel(urls);

    // Wait for completion message from the isolate
    await receivePort.first;
  }
  // Access cached file or download and cache it if not found
  Future<File?> getCachedFile(String fileUrl) async {
    try {
      // Try to get the file from cache
      print("getting from cache");
      final cachedFile = await DefaultCacheManager().getFileFromCache(fileUrl);
      if (cachedFile != null && cachedFile.file != null) {
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

  static void cacheLevel(List<String> urls) async {
  
      preloadFiles(urls);
    // } catch (e) {
    //   print("Error caching level: $e");
    // }
  }
 static Future< List<String>> urlsForCaching(LevelMap levelMap) async{
     List<String> levels = [
        "Detection",
        "Discrimination",
        "Identification",
        // "Level"
      ];
     List<String> urls=[];
      for (String levelName in levels) {
        print("Caching level: $levelName-${levelMap.toJson()[levelName]}");
        int level = levelMap.toJson()[levelName];
        dynamic levelData = await UserData().fetchData(levelName, level);
        if (levelData != null) {
          String type = levelData["type"];
          if(type=="video"){
             urls.add(levelData["video_url"]);
          }
          else if (type == "ImageToAudio") {
            ImageToAudio imageToAudio = ImageToAudio.fromJson(levelData);
          
            urls.add(imageToAudio.image_url);
            urls.addAll(imageToAudio.audio_list);
            
          } else if (type == "WordToFig") {
            WordToFiG wordToFiG = WordToFiG.fromJson(levelData);
           
            urls.add(wordToFiG.image_url);
            urls.addAll(wordToFiG.image_url_list);
            
          } else if (type == "FigToWord") {
            FigToWord figToWord = FigToWord.fromJson(levelData);
         
            urls.add(figToWord.image_url);
            
          } else if (type == "AudioToImage") {
            AudioToImage audioToImage = AudioToImage.fromJson(levelData);
        
            urls.addAll(audioToImage.audio_url);
            urls.addAll(audioToImage.image_list);
             
          } else if (type == "AudioToAudio") {
            AudioToAudio audioToAudio= AudioToAudio.fromJson(levelData);
         
            urls.addAll(audioToAudio.audio_list);
           
          } else if (type == "Muted&Unmuted") {
          MutedUnmuted mutedUnmuted=  MutedUnmuted.fromJson(levelData);
       
            urls.addAll(mutedUnmuted.video_url);
          
          } else if (type == "HalfMuted") {
          HalfMuted halfMuted=  HalfMuted.fromJson(levelData);
           
            urls.addAll(halfMuted.video_url);
            
          } else if (type == "DiffSounds") {
            DiffSounds diffSounds= DiffSounds.fromJson(levelData);
        
            urls.addAll(diffSounds.video_url);
            

          } else if (type == "OddOne") {
          OddOne oddOne=  OddOne.fromJson(levelData);
           
            urls.addAll(oddOne.video_url);

             
          } else if (type == "DiffHalf") {
          DiffHalf diffHalf=  DiffHalf.fromJson(levelData);
           
            urls.addAll(diffHalf.video_url);
           
          } else {}
        }
      }
      print("returning urls $urls");
      return urls;
  }
}
