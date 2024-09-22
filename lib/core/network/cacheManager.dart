
import 'dart:io';  // For File
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachingManager {

  Future<void> preloadFiles(List<String> urls) async {
    for (String url in urls) {
      try {
        await DefaultCacheManager().downloadFile(url);
      } catch (e) {
        print("Error preloading $url: $e");
      }
    }
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
        final downloadedFile = await DefaultCacheManager().downloadFile(fileUrl);
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
}
