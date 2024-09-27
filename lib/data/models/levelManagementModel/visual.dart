import 'dart:core';

class ImageToAudio {
  final String image_url;
  final List<String> audio_list;
  final String correct_output;

  ImageToAudio._(
      {required this.image_url,
      required this.audio_list,
      required this.correct_output});

  factory ImageToAudio.fromJson(Map<String, dynamic> json) {
    return ImageToAudio._(
        image_url: json["image_url"] as String,
        audio_list: List<String>.from(json["audio_list"]),
        correct_output: json["correct_output"] as String);
  }
  String getImageUrl() {
    return image_url;
  }

  List<String> getAudioList() {
    return audio_list;
  }

  String getCorrectOutput() {
    return correct_output;
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

class AudioToAudio {
  final List<String> audio_list;
  final int correct_output;
  AudioToAudio._({required this.audio_list, required this.correct_output});
  factory AudioToAudio.fromJson(Map<String, dynamic> json) {
    return AudioToAudio._(
        audio_list: List<String>.from(json["audio_list"]),
        correct_output: json["correct_output"] as int);
  }
  List<String> getAudioList() {
    return audio_list;
  }

  int getCorrectOutput() {
    return correct_output;
  }
}

class MutedUnmuted {
  final String type;
  final List<String> video_url;

  MutedUnmuted._({
    required this.type,
    required this.video_url,
  });

  factory MutedUnmuted.fromJson(Map<String, dynamic> json) {
    return MutedUnmuted._(
      type: json['type'] as String,
      video_url: List<String>.from(json['video_url']),
    );
  }

  List<String> getVideoUrls() {
    return video_url;
  }

  String getType() {
    return type;
  }
}

class HalfMuted {
  final String video_url;

  HalfMuted._({
    required this.video_url,
  });

  factory HalfMuted.fromJson(Map<String, dynamic> json) {
    return HalfMuted._(
      video_url: json['video_url'] as String, // Accessing the first item
    );
  }

  String getVideoUrl() {
    return video_url;
  }
}

class DiffSounds {
  final bool same;

  final List<String> video_url;

  DiffSounds._({
    required this.video_url,
    required this.same,
  });

  factory DiffSounds.fromJson(Map<String, dynamic> json) {
    return DiffSounds._(
      video_url: List<String>.from(json['video_url']),
      same: json['same'] as bool,
    );
  }

  List<String> getVideoUrls() {
    return video_url;
  }

  bool getSame() {
    return same;
  }

  @override
  String toString() {
    return 'DiffSounds{same: $same, video_url: $video_url}';
  }
}

class OddOne {
  final String correct_output;
  final List<String> video_url;

  OddOne._({
    required this.video_url,
    required this.correct_output,
  });

  factory OddOne.fromJson(Map<String, dynamic> json) {
    return OddOne._(
      video_url: List<String>.from(json['video_url']),
      correct_output: json['correct_output'] as String,
    );
  }

  List<String> getVideoUrls() {
    return video_url;
  }

  String getCorrectOutput() {
    return correct_output;
  }
}

class DiffHalf {
  

  final List<String> video_url;

  DiffHalf._({
    required this.video_url,
    
  });

  factory DiffHalf.fromJson(Map<String, dynamic> json) {
    return DiffHalf._(
      video_url: List<String>.from(json['video_url']),
    
    );
  }

  List<String> getVideoUrls() {
    return video_url;
  }
}

class MaleFemale {
  final String video_url;
  final String correct_output;

  MaleFemale._({
    required this.video_url,
    required this.correct_output,
  });

  factory MaleFemale.fromJson(Map<String, dynamic> json) {
    return MaleFemale._(
      video_url: json['video_url'],
      correct_output: json['correct_output'] as String,
    );
  }

  String getVideoUrl() {
    return video_url;
  }

  String getCorrectOutput() {
    return correct_output;
  }
}
