import 'dart:core';
class ImageToAudio
{
  final String image_url;
  final List<String> audio_url_list;
  final String correct_audio_url;

  ImageToAudio._({required this.image_url ,required this.audio_url_list ,required this.correct_audio_url});

  factory ImageToAudio.fromJson(Map<String,dynamic> json){
    return ImageToAudio._(
      image_url: json["image_url"] as String,
      audio_url_list: List<String>.from(json["audio_url_list"]),
      correct_audio_url: json["correct_audio_url"] as String
      );
  }
    String getImageUrl(){
      return image_url;
    }
   List< String> getAudioList(){
      return audio_url_list;
    }
    String getCorrectOutput(){
      return correct_audio_url;
    }
}



class WordToFiG
{
  final String image_url;
  final List<String> image_url_list;
  final String correct_image_url;
  WordToFiG._({required this.correct_image_url , required this.image_url , required this.image_url_list});
  factory WordToFiG.fromJson(Map<String , dynamic> json) 
  {
    return WordToFiG._(
      correct_image_url: json["correct_image_url"] as String,
      image_url: json["image_url"] as String,
      image_url_list: List<String>.from(json["image_url_list"])
    );
  }

  String getImageUrl(){
    return image_url;
  }
  String getCorrectOutput()
  {
    return correct_image_url;
  }
  List<String> getImageUrlList(){
    return image_url_list;
  }
}


class FigToWord
{
  final String image_url;
  final List<String> text_list;
  final String correct_text;
  FigToWord._({required this.text_list ,required this.image_url ,required this.correct_text});
  factory FigToWord.fromJson(Map<String , dynamic> json)
  {
    return FigToWord._(
      text_list:List<String>.from( json["text_list"] ),
      image_url: json["image_url"] as String,
      correct_text: json["correct_text"] as String
    );
  }
  String getImageUrl(){
    return image_url;
  }
  String getCorrectOutput(){
    return correct_text;
  }
  List<String> getTextList()
  {
    return text_list;
  }

}
