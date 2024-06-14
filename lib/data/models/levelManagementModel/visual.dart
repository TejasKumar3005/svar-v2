import 'dart:core';

class ImageToAudio {
  final String image_url;
  final List<String> audio_url_list;
  final String correct_audio_url;

  ImageToAudio._(
      {required this.image_url,
      required this.audio_url_list,
      required this.correct_audio_url});

  factory ImageToAudio.fromJson(Map<String, dynamic> json) {
    return ImageToAudio._(
        image_url: json["image_url"] as String,
        audio_url_list: List<String>.from(json["audio_list"]),
        correct_audio_url: json["correct_output"] as String);
  }
  String getImageUrl() {
    return image_url;
  }

  List<String> getAudioList() {
    return audio_url_list;
  }

  String getCorrectOutput() {
    return correct_audio_url;
  }
}

class WordToFiG {
  final String image_url;
  final List<String> image_url_list;
  final String correct_image_url;
  WordToFiG._(
      {required this.correct_image_url,
      required this.image_url,
      required this.image_url_list});
  factory WordToFiG.fromJson(Map<String, dynamic> json) {
    return WordToFiG._(
        correct_image_url: json["correct_output"] as String,
        image_url: json["text"] as String,
        image_url_list: List<String>.from(json["image_list"]));
  }

  String getImageUrl() {
    return image_url;
  }

  String getCorrectOutput() {
    return correct_image_url;
  }

  List<String> getImageUrlList() {
    return image_url_list;
  }
}

class FigToWord {
  final String image_url;
  final List<String> text_list;
  final String correct_text;
  FigToWord._(
      {required this.text_list,
      required this.image_url,
      required this.correct_text});
  factory FigToWord.fromJson(Map<String, dynamic> json) {
    return FigToWord._(
        text_list: List<String>.from(json["text_list"]),
        image_url: json["image_url"] as String,
        correct_text: json["correct_output"] as String);
  }
  String getImageUrl() {
    return image_url;
  }

  String getCorrectOutput() {
    return correct_text;
  }

  List<String> getTextList() {
    return text_list;
  }
}

class AudioToImage {
  final String audio_url;
  final String correct_output;
  final List<String> image_list;
  AudioToImage._(
      {required this.audio_url,
      required this.correct_output,
      required this.image_list});
  factory AudioToImage.fromJson(Map<String, dynamic> json) {
    return AudioToImage._(
        audio_url: json["audio_url"] as String,
        correct_output: json["correct_output"] as String,
        image_list: List<String>.from(json["image_list"]));
  }
  List<String> getImageUrlList() {
    return image_list;
  }

  String getCorrectOutput() {
    return correct_output;
  }

  String getAudioUrl() {
    return audio_url;
  }
}
