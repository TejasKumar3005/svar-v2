import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayBgm {
  

   void playMusic(String audio,String mime,bool repeat) async {
      AudioCache.instance = AudioCache(prefix: '');
      AudioPlayer audioPlayer = AudioPlayer();
      if(repeat){

        audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the audio
      }
    await audioPlayer.play(
      AssetSource('assets/audio/bgm/$audio',mimeType: mime),
    
      ); // Load the audio
    // audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the audio
    // audioPlayer.resume(); // Start playing
  }
}
