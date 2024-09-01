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
  final String video_url;
  final String correct_output;
  final List<String> image_url;
  AudioToImage._(
      {required this.video_url,
      required this.correct_output,
      required this.image_url});
  factory AudioToImage.fromJson(Map<String, dynamic> json) {
    return AudioToImage._(
        video_url: json["video_url"] as String,
        correct_output: json["correct_output"] as String,
        image_url: List<String>.from(json["image_url"]));
  }
  List<String> getImageUrlList() {
    return image_url;
  }

  String getCorrectOutput() {
    return correct_output;
  }

  String getAudioUrl() {
    return video_url;
  }
}


class AudioToAudio{
  final List<String> audio_list;
  final int correct_output;
  AudioToAudio._({required this.audio_list, required this.correct_output});
  factory AudioToAudio.fromJson(Map<String, dynamic> json){
    return AudioToAudio._(
      audio_list: List<String>.from(json["audio_list"]),
      correct_output: json["correct_output"] as int
    );
  }
  List<String> getAudioList(){
    return audio_list;
  }
  int getCorrectOutput(){
    return correct_output;
  }
}

class MutedUnmuted {
  final int level;
  final String type;
  final List<String> videoUrls;

  MutedUnmuted._({
    required this.level,
    required this.type,
    required this.videoUrls,
  });

  factory MutedUnmuted.fromJson(Map<String, dynamic> json) {
    return MutedUnmuted._(
      level: json['level'] as int,
      type: json['type'] as String,
      videoUrls: List<String>.from(json['video_url']),
    );
  }

  List<String> getVideoUrls() {
    return videoUrls;
  }

  int getLevel() {
    return level;
  }

  String getType() {
    return type;
  }
}

class HalfMuted {
  final int level;
  final String type;
  final String videoUrl;

  HalfMuted._({
    required this.level,
    required this.type,
    required this.videoUrl,
  });

  factory HalfMuted.fromJson(Map<String, dynamic> json) {
    return HalfMuted._(
      level: json['level'] as int,
      type: json['type'] as String,
      videoUrl: json['video_url'][0] as String, // Accessing the first item
    );
  }

  String getVideoUrl() {
    return videoUrl;
  }

  int getLevel() {
    return level;
  }

  String getType() {
    return type;
  }
}


class DiffSounds {
  final int level;
  final String type;
  final List<String> videoUrls;

  DiffSounds._({
    required this.level,
    required this.type,
    required this.videoUrls,
  });

  factory DiffSounds.fromJson(Map<String, dynamic> json) {
    return DiffSounds._(
      level: json['level'] as int,
      type: json['type'] as String,
      videoUrls: List<String>.from(json['video_url']),
    );
  }

  List<String> getVideoUrls() {
    return videoUrls;
  }

  int getLevel() {
    return level;
  }

  String getType() {
    return type;
  }
}

class OddOne {
  final int level;
  final String type;
  final List<String> videoUrls;

  OddOne._({
    required this.level,
    required this.type,
    required this.videoUrls,
  });

  factory OddOne.fromJson(Map<String, dynamic> json) {
    return OddOne._(
      level: json['level'] as int,
      type: json['type'] as String,
      videoUrls: List<String>.from(json['video_url']),
    );
  }

  List<String> getVideoUrls() {
    return videoUrls;
  }

  int getLevel() {
    return level;
  }

  String getType() {
    return type;
  }
}


class DiffHalf {
  final int level;
  final String type;
  final List<String> videoUrls;

  DiffHalf._({
    required this.level,
    required this.type,
    required this.videoUrls,
  });

  factory DiffHalf.fromJson(Map<String, dynamic> json) {
    return DiffHalf._(
      level: json['level'] as int,
      type: json['type'] as String,
      videoUrls: List<String>.from(json['video_url']),
    );
  }

  List<String> getVideoUrls() {
    return videoUrls;
  }

  int getLevel() {
    return level;
  }

  String getType() {
    return type;
  }
}
