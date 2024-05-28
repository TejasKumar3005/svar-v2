import 'dart:core';
class ImageToAudio
{
  final String image_url;
  final List<String> audio_url_list;
  final String correct_audio_url;

  ImageToAudio._({required this.image_url ,required this.audio_url_list ,required this.correct_audio_url});

  factory ImageToAudio.fromJson(Map<String,dynamic> json){
    return ImageToAudio._(
      image_url: json["image_url"], 
      audio_url_list: List<String>.from(json["audio_url_list"]), 
      correct_audio_url: json["correct_audio_url"]
      );
  }
  String get getImageUrl=> image_url;
  String get getCorrectOutput => correct_audio_url;
  List<String> get getAudioList => audio_url_list;

}

class WordToFiG 
{
  final String image_url; 
  final List<String> text_list;
  final String correct_text;

  WordToFiG._({required this.image_url , required this.text_list , required this.correct_text}) ;
  factory WordToFiG.fromJson(Map<String , dynamic> json)
  {
    return WordToFiG._(
      image_url: json["image_url"], 
      text_list: List<String>.from(json["text_list"]),
      correct_text: json["correct_text"]
      );
  }
  String get getImageUrl => image_url;
  String get getCorrectOutput => correct_text;
  List<String> get getTextList => text_list;
}

class FigToWord 
{
  final String text; 
  final List<String> image_url_list; 
  final String correct_image_url; 
  FigToWord._({required this.text , required this.image_url_list , required this.correct_image_url});
  factory FigToWord.fromJson(Map<String , dynamic> json){
    return FigToWord._(
      text: json["text"], 
      image_url_list: List<String>.from(json["image_url_list"]), 
      correct_image_url: json["correct_image_url"]
      );
  }
  String get getImageUrl => text;
  String get getCorrectOutput => correct_image_url;
  List<String> get getImageUrlList => image_url_list;

}
