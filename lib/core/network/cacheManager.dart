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
    urls = urlsFromExercises(exercises);
    preloadFiles(urls);
  }

  // Access cached file or download and cache it if not found
  Future<File?> getCachedFile(String fileUrl) async {
    try {
      // Try to get the file from cache
      print("getting from cache" + fileUrl);
      final cachedFile = await DefaultCacheManager().getFileFromCache(fileUrl);
      if (cachedFile != null) {
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

  static List<String> urlsFromExercises(List<dynamic> exercises) {
    List<String> urls = [
      "https://svarbucket.s3.amazonaws.com/videos/cat_loop.mp4",
      "https://svarbucket.s3.amazonaws.com/videos/car_honking.mp4",
      "https://svarbucket.s3.amazonaws.com/videos/cooker_loop.mp4",
      "https://svarbucket.s3.amazonaws.com/videos/drum_loop.mp4",
      "https://svarbucket.s3.amazonaws.com/videos/clap.mp4",
      "https://svarbucket.s3.amazonaws.com/videos/coughing_loop.mp4",
      "https://svarbucket.s3.amazonaws.com/new_vehicles/images/akg_20250606_052714_adf3fb26.png",
      "https://svarbucket.s3.amazonaws.com/new_vehicles/images/akg_20250606_052716_9b74238a.png",
      "https://svarbucket.s3.amazonaws.com/new_environment/images/akg_20250606_052742_2be51053.png",
      "https://svarbucket.s3.amazonaws.com/new_environment/images/akg_20250606_052744_411dae16.png",
      "https://svarbucket.s3.amazonaws.com/videos/clapping.mp4",
      "https://svarbucket.s3.amazonaws.com/videos/cat.mp4",
      "https://svarbucket.s3.amazonaws.com/audios/whistle.mp3",
      "https://svarbucket.s3.amazonaws.com/audios/coughing_loop.mp3",
      "https://svarbucket.s3.amazonaws.com/audios/cat_loop.mp3",
      "https://svarbucket.s3.amazonaws.com/audios/clapping.mp3",
      "https://svarbucket.s3.amazonaws.com/audios/cooker_loop.mp3",
      "https://svarbucket.s3.amazonaws.com/audios/phone_loop.mp3",
      "https://svarbucket.s3.amazonaws.com/audios/drum_loop.mp3",
      "https://svarbucket.s3.amazonaws.com/audios/akg_20250609_115930_81dd59ad.mp3",
      "https://svarbucket.s3.amazonaws.com/images/akg_20250531_081701_ef0a2300.png",
      "https://svarbucket.s3.amazonaws.com/audios/akg_20250531_081659_83528d97.mp3",
      "https://svarbucket.s3.amazonaws.com/audios/akg_20250531_081657_594a1544.mp3",
      "https://svarbucket.s3.amazonaws.com/imgs/Whistle.png",
      "https://svarbucket.s3.amazonaws.com/imgs/Drum.png",
      "https://svarbucket.s3.amazonaws.com/imgs/coughing.png",
      "https://svarbucket.s3.amazonaws.com/imgs/cat.png",
      "https://svarbucket.s3.amazonaws.com/imgs/phone.png",
      "https://svarbucket.s3.amazonaws.com/audios/car_honking_loop.mp3",
      "https://svarbucket.s3.amazonaws.com/imgs/car.png",
      "https://svarbucket.s3.amazonaws.com/imgs/cooker.png",
      "https://svarbucket.s3.amazonaws.com/audios/akg_20250528_112523_1e5afea3.mp3",
      "https://svarbucket.s3.amazonaws.com/images/akg_20250528_112530_fb2c839d.png",
      "https://svarbucket.s3.amazonaws.com/images/akg_20250528_112529_3df8a0a6.png",
      "https://svarbucket.s3.amazonaws.com/audios/male_voice_sample.mp3",
      "https://svarbucket.s3.amazonaws.com/audios/female_voice_sample.mp3",
      "https://svarbucket.s3.amazonaws.com/new_vehicles/images/akg_20250606_052714_adf3fb26.png",
      "https://svarbucket.s3.amazonaws.com/new_vehicles/images/akg_20250606_052716_9b74238a.png",
      "https://svarbucket.s3.amazonaws.com/new_environment/images/akg_20250606_052742_2be51053.png",
      "https://svarbucket.s3.amazonaws.com/new_environment/images/akg_20250606_052744_411dae16.png"
    ];
    for (var exercise in exercises) {
      var type = exercise["type"];
      if (type == "video") {
        if (exercise["video"] != null) urls.add(exercise["video"]);
        if (exercise["video_url"] != null) urls.add(exercise["video_url"]);
      } else if (type == "ImageToAudio" || type == "DiffImageToAudio") {
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
      } else if (type == "AudioToImage" || type == "DiffAudioToImage") {
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
      } else if (type == "Vocabulary") {
        if (exercise["category"] == "opposites") {
          String image1 = exercise[exercise["word"].split("-")[0]] ?? "";
          String image2 = exercise[exercise["word"].split("-")[1]] ?? "";
          urls.add(image1);
          urls.add(image2);
        } else {
          urls.add(exercise["url"]);
        }
      } else if (type == "PictureMatchingComprehension") {
        PictureMatchingComprehension pictureMatching =
            PictureMatchingComprehension.fromJson(exercise);
        urls.add(pictureMatching.prompt_audio_url);
        for (var option in pictureMatching.options) {
          if (option['image_url'] != null) urls.add(option['image_url']);
        }
      } else if (type == "Wh") {
        Wh wh = Wh.fromJson(exercise);
        for (var option in wh.options) {
          if (option['image_url'] != null) urls.add(option['image_url']);
        }
      } else if (type == "YesNoComprehension") {
        YesNoComprehension yesNo = YesNoComprehension.fromJson(exercise);
        urls.add(yesNo.input_audio_url);
        urls.add(yesNo.output_audio_url);
        urls.add(yesNo.output_image_url);
      } else if (type == "StoryCompletion") {
        StoryCompletion storyCompletion = StoryCompletion.fromJson(exercise);
        for (var option in storyCompletion.options) {
          if (option['image_url'] != null) urls.add(option['image_url']);
          if (option['audio_url'] != null) urls.add(option['audio_url']);
        }
      } else if (type == "StoryComprehension") {
        StoryComprehension storyComprehension =
            StoryComprehension.fromJson(exercise);
        // Cache scene images and audio
        for (var scene in storyComprehension.scenes) {
          urls.add(scene.image_url);
          urls.add(scene.audio_url);
        }
        // Cache question audio and option images/audio
        for (var question in storyComprehension.questions) {
          urls.add(question.audio_url);
          for (var option in question.options) {
            if (option['image_url'] != null) urls.add(option['image_url']);
            if (option['audio_url'] != null) urls.add(option['audio_url']);
          }
        }
      } else {}
    }

    print("returning urls $urls");
    return urls;
  }
}
