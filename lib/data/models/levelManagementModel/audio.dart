import 'dart:core';
/*
    Similar to visual representation
 */
class ImageToAudio
{
  final String image_url; 
  final List<String> audio_list_url;
  final String correct_audio_url;

  ImageToAudio._({required this.image_url , required this.audio_list_url , required this.correct_audio_url});
  factory ImageToAudio.fromJson(Map<String , dynamic> json){
    return ImageToAudio._(
      image_url: json["image_url"], 
      audio_list_url:List<String>.from( json["audio_list_url"] ), 
      correct_audio_url: json["correct_audio_url"]);
  }
}

class AudioToImage
{
  final String audio_url; 
  final List<String> image_url_list;
  final String correct_image_url;
  AudioToImage._({required this.audio_url , required this.image_url_list , required this.correct_image_url});
  factory AudioToImage.fromJson(Map<String , dynamic> json){
    return AudioToImage._(
      audio_url: json["audio_url"], 
      image_url_list: List<String>.from(json["image_url_list"]), 
      correct_image_url: json["correct_image_url"]
      );
  }
}