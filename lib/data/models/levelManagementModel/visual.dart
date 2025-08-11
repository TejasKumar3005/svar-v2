import 'dart:core';

import 'package:flutter/foundation.dart';

class ImageToAudio {
  final String image_url;
  final List<String> audio_list;
  final String correct_output;

  ImageToAudio(
      {required this.image_url,
      required this.audio_list,
      required this.correct_output});

  factory ImageToAudio.fromJson(Map<String, dynamic> json) {
    return ImageToAudio(
        image_url: json["image_url"] as String,
        audio_list: List<String>.from(json["audio_list"]),
        correct_output: json["correct_output"] ?? "");
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
  WordToFiG(
      {required this.correct_image_url,
      required this.image_url,
      required this.image_url_list});
  factory WordToFiG.fromJson(Map<String, dynamic> json) {
    return WordToFiG(
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
  FigToWord(
      {required this.text_list,
      required this.image_url,
      required this.correct_text});
  factory FigToWord.fromJson(Map<String, dynamic> json) {
    return FigToWord(
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
  final List<String> audio_url;
  final String correct_output;
  final List<String> image_list;
  AudioToImage(
      {required this.audio_url,
      required this.correct_output,
      required this.image_list});
  factory AudioToImage.fromJson(Map<String, dynamic> json) {
    return AudioToImage(
        audio_url: [json["audio_url"] as String],
        correct_output: json["correct_output"] as String,
        image_list: List<String>.from(json["image_list"]));
  }
  List<String> getImageUrlList() {
    return image_list;
  }

  String getCorrectOutput() {
    return correct_output;
  }

  List<String> getAudioUrl() {
    return audio_url;
  }
}

class AudioToAudio {
  final List<String> audio_list;
  final int correct_output;
  AudioToAudio({required this.audio_list, required this.correct_output});
  factory AudioToAudio.fromJson(Map<String, dynamic> json) {
    return AudioToAudio(
        audio_list: List<String>.from(json['audio_list']),
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
  final List<String> video_url;
  final int muted;
  MutedUnmuted({
    required this.video_url,
    required this.muted,
  });

  factory MutedUnmuted.fromJson(Map<String, dynamic> json) {
    return MutedUnmuted(
      video_url: List<String>.from(json['video_url']),
      muted: json['muted'] as int,
    );
  }

  List<String> getVideoUrls() {
    return video_url;
  }

  int getMuted() {
    return muted;
  }
}

class HalfMuted {
  final List<String> video_url;

  HalfMuted({
    required this.video_url,
  });

  factory HalfMuted.fromJson(Map<String, dynamic> json) {
    return HalfMuted(
      video_url: [json['video_url'], json['video_url']],
    );
  }

  List<String> getVideoUrls() {
    return video_url;
  }
}

class DiffSounds {
  final bool same;
  final List<String> video_url;

  DiffSounds({
    required this.video_url,
    required this.same,
  });

  factory DiffSounds.fromJson(Map<String, dynamic> json) {
    return DiffSounds(
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

  OddOne({
    required this.video_url,
    required this.correct_output,
  });

  factory OddOne.fromJson(Map<String, dynamic> json) {
    return OddOne(
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

  DiffHalf({
    required this.video_url,
  });

  factory DiffHalf.fromJson(Map<String, dynamic> json) {
    return DiffHalf(
      video_url: List<String>.from(json['video_url']),
    );
  }

  List<String> getVideoUrls() {
    return video_url;
  }

  Map<String, dynamic> toJson() {
    return {
      'video_url': video_url,
    };
  }
}

class MaleFemale {
  final List<String> video_url;
  final String correct_output;

  MaleFemale({
    required this.video_url,
    required this.correct_output,
  });

  factory MaleFemale.fromJson(Map<String, dynamic> json) {
    return MaleFemale(
      video_url: List<String>.from(json['video_url']),
      correct_output: json['correct_output'] as String,
    );
  }

  List<String> getVideoUrl() {
    return video_url;
  }

  String getCorrectOutput() {
    return correct_output;
  }
}

class PictureMatchingComprehension {
  List<Map<String, dynamic>> options;
  int correct;
  String prompt_audio_url;
  String prompt;

  PictureMatchingComprehension({
    required this.options,
    required this.correct,
    required this.prompt_audio_url,
    required this.prompt,
  });

  factory PictureMatchingComprehension.fromJson(Map<String, dynamic> json) {
    return PictureMatchingComprehension(
      options: List<Map<String, dynamic>>.from(
          json['options']), // [{image_url: String, text: String}]
      correct: json['correct'] as int,
      prompt_audio_url: json['prompt_audio_url'] as String,
      prompt: json['prompt'] as String,
    );
  }

  List<Map<String, dynamic>> getOptions() {
    return options;
  }

  int getCorrect() {
    return correct;
  }

  String getPromptAudioUrl() {
    return prompt_audio_url;
  }

  String getPrompt() {
    return prompt;
  }
}

class Wh {
  String prompt;
  int correct;
  List<Map<String, dynamic>> options;

  Wh({
    required this.prompt,
    required this.correct,
    required this.options,
  });

  factory Wh.fromJson(Map<String, dynamic> json) {
    return Wh(
      prompt: json['prompt'] as String,
      correct: json['correct'] as int,
      options: List<Map<String, dynamic>>.from(json[
          'options']), // [{image_url: String, text: String]
    );
  }

  String getPrompt() {
    return prompt;
  }

  int getCorrect() {
    return correct;
  }

  List<Map<String, dynamic>> getOptions() {
    return options;
  }
}

class YesNoComprehension {
  String prompt;
  String correct;
  String output_prompt;
  String input_audio_url;
  String output_audio_url;
  String output_image_url;

  YesNoComprehension({
    required this.prompt,
    required this.correct,
    required this.output_prompt,
    required this.input_audio_url,
    required this.output_audio_url,
    required this.output_image_url,
  });

  factory YesNoComprehension.fromJson(Map<String, dynamic> json) {
    return YesNoComprehension(
      prompt: json['prompt'] as String,
      correct: json['correct'] as String,
      output_prompt: json['output_prompt'] as String,
      input_audio_url: json['input_audio_url'] as String,
      output_audio_url: json['output_audio_url'] as String,
      output_image_url: json['output_image_url'] as String,
    );
  }

  String getPrompt() {
    return prompt;
  }

  String getCorrect() {
    return correct;
  }
}

class StoryCompletion {
  String prompt;
  int correct;
  List<Map<String, dynamic>> options;

  StoryCompletion({
    required this.prompt,
    required this.correct,
    required this.options,
  });

  factory StoryCompletion.fromJson(Map<String, dynamic> json) {
    return StoryCompletion(
      prompt: json['prompt'] as String,
      correct: json['correct'] as int,
      options: List<Map<String, dynamic>>.from(json[
          'options']), //[{image_url: String, text: String,audio_url: String}]
    );
  }

  String getPrompt() {
    return prompt;
  }

  int getCorrect() {
    return correct;
  }
}

class Question {
  String answer;
  String audio_url;
  String text;
  List<Map<String, dynamic>>
      options; //[{image_url: String, text: String,audio_url: String}]

  Question({
    required this.answer,
    required this.audio_url,
    required this.text,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      answer: json['answer'] as String,
      audio_url: json['audio_url'] as String,
      text: json['text'] as String,
      options: List<Map<String, dynamic>>.from(json['options']),
    );
  }

  String getAnswer() {
    return answer;
  }

  String getAudioUrl() {
    return audio_url;
  }

  String getText() {
    return text;
  }

  List<Map<String, dynamic>> getOptions() {
    return options;
  }
}

class Scene {
  String audio_url;
  String description;
  String id;
  String image_concept;
  String image_url;
  Scene({
    required this.audio_url,
    required this.description,
    required this.id,
    required this.image_concept,
    required this.image_url,
  });
  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      audio_url: json['audio_url'] as String,
      description: json['description'] as String,
      id: json['id'] as String,
      image_concept: json['image_concept'] as String,
      image_url: json['image_url'] as String,
    );
  }
  String getAudioUrl() {
    return audio_url;
  }

  String getDescription() {
    return description;
  }
}

class StoryComprehension {
  String prompt;
  List<Question> questions;
  List<Scene> scenes;

  StoryComprehension({
    required this.prompt,
    required this.questions,
    required this.scenes,
  });

  factory StoryComprehension.fromJson(Map<String, dynamic> json) {
    return StoryComprehension(
      prompt: json['prompt'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      scenes: (json['scenes'] as List<dynamic>)
          .map((s) => Scene.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  String getPrompt() {
    return prompt;
  }

  List<Question> getQuestions() {
    return questions;
  }
}

Object retrieveObject(String type, Map<String, dynamic> data) {
  try {
    if (type == "ImageToAudio") return ImageToAudio.fromJson(data);
    if (type == "WordToFig") return WordToFiG.fromJson(data);
    if (type == "FigToWord") return FigToWord.fromJson(data);
    if (type == "AudioToImage") return AudioToImage.fromJson(data);
    if (type == "AudioToAudio") return AudioToAudio.fromJson(data);
    if (type == "MutedUnmuted") return MutedUnmuted.fromJson(data);
    if (type == "HalfMuted") return HalfMuted.fromJson(data);
    if (type == "DiffSounds") return DiffSounds.fromJson(data);
    if (type == "OddOne") return OddOne.fromJson(data);
    if (type == "DiffHalf") return DiffHalf.fromJson(data);
    if (type == "MaleFemale") return MaleFemale.fromJson(data);
    if (type == "DiffImageToAudio") return ImageToAudio.fromJson(data);
    if (type == "DiffAudioToImage") return AudioToImage.fromJson(data);
    if (type == "PictureMatchingComprehension")
      return PictureMatchingComprehension.fromJson(data);
    if (type == "Wh") return Wh.fromJson(data);
    if (type == "YesNoComprehension") return YesNoComprehension.fromJson(data);
    if (type == "StoryCompletion") return StoryCompletion.fromJson(data);
    if (type == "StoryComprehension") return StoryComprehension.fromJson(data);

    debugPrint(
        "Unexpected object type to retrieve: $type. Returning 'unexpected value'.");
    return "unexpected value";
  } catch (e) {
    debugPrint(
        "Error in retrieveObject for type $type: $e. Returning 'unexpected value'.");
    return "unexpected value";
  }
}

List<MutedUnmuted> sampleMutedUnmuted = [
  MutedUnmuted(video_url: [
    "https://svarbucket.s3.amazonaws.com/videos/cat_loop.mp4",
    "https://svarbucket.s3.amazonaws.com/videos/car_honking.mp4"
  ], muted: 0),
  MutedUnmuted(video_url: [
    "https://svarbucket.s3.amazonaws.com/videos/cooker_loop.mp4",
    "https://svarbucket.s3.amazonaws.com/videos/drum_loop.mp4"
  ], muted: 1),
  MutedUnmuted(video_url: [
    "https://svarbucket.s3.amazonaws.com/videos/clap.mp4",
    "https://svarbucket.s3.amazonaws.com/videos/coughing_loop.mp4"
  ], muted: 0)
];

List<dynamic> sampleVocabulary = [
  {
    "word": "boat",
    "url":
        "https://svarbucket.s3.amazonaws.com/new_vehicles/images/akg_20250606_052714_adf3fb26.png"
  },
  {
    "word": "airplane",
    "url":
        "https://svarbucket.s3.amazonaws.com/new_vehicles/images/akg_20250606_052716_9b74238a.png"
  },
  {
    "word": "stars",
    "url":
        "https://svarbucket.s3.amazonaws.com/new_environment/images/akg_20250606_052742_2be51053.png"
  },
  {
    "word": "mountain",
    "url":
        "https://svarbucket.s3.amazonaws.com/new_environment/images/akg_20250606_052744_411dae16.png"
  },
];

List<dynamic> samplePronunciations = [
  "काला",
  "अलमारी",
  "नापो",
  "चाचा",
  "माचिस"
];

List<HalfMuted> sampleHalfMuted = [
  HalfMuted(
      video_url: ["https://svarbucket.s3.amazonaws.com/videos/drum_loop.mp4"]),
  HalfMuted(
      video_url: ["https://svarbucket.s3.amazonaws.com/videos/clapping.mp4"]),
  HalfMuted(video_url: ["https://svarbucket.s3.amazonaws.com/videos/cat.mp4"])
];

List<DiffSounds> sampleDiffSounds = [
  DiffSounds(video_url: [
    "https://svarbucket.s3.amazonaws.com/audios/whistle.mp3",
    "https://svarbucket.s3.amazonaws.com/audios/coughing_loop.mp3"
  ], same: false),
  DiffSounds(video_url: [
    "https://svarbucket.s3.amazonaws.com/audios/cat_loop.mp3",
    "https://svarbucket.s3.amazonaws.com/audios/clapping.mp3"
  ], same: false),
  DiffSounds(video_url: [
    "https://svarbucket.s3.amazonaws.com/audios/clapping.mp3",
    "https://svarbucket.s3.amazonaws.com/audios/clapping.mp3"
  ], same: true)
];

List<OddOne> sampleOddOne = [
  OddOne(
      video_url: [
        "https://svarbucket.s3.amazonaws.com/audios/cooker_loop.mp3",
        "https://svarbucket.s3.amazonaws.com/audios/whistle.mp3",
        "https://svarbucket.s3.amazonaws.com/audios/whistle.mp3"
      ],
      correct_output:
          "https://svarbucket.s3.amazonaws.com/audios/cooker_loop.mp3"),
  OddOne(video_url: [
    "https://svarbucket.s3.amazonaws.com/audios/cat_loop.mp3",
    "https://svarbucket.s3.amazonaws.com/audios/clapping.mp3",
    "https://svarbucket.s3.amazonaws.com/audios/clapping.mp3"
  ], correct_output: "https://svarbucket.s3.amazonaws.com/audios/cat_loop.mp3"),
  OddOne(
      video_url: [
        "https://svarbucket.s3.amazonaws.com/audios/phone_loop.mp3",
        "https://svarbucket.s3.amazonaws.com/audios/drum_loop.mp3",
        "https://svarbucket.s3.amazonaws.com/audios/drum_loop.mp3"
      ],
      correct_output:
          "https://svarbucket.s3.amazonaws.com/audios/phone_loop.mp3")
];

List<DiffHalf> sampleDiffHalf = [
  DiffHalf(video_url: [
    "https://svarbucket.s3.amazonaws.com/audios/whistle.mp3",
    "https://svarbucket.s3.amazonaws.com/audios/phone_loop.mp3"
  ]),
  DiffHalf(video_url: [
    "https://svarbucket.s3.amazonaws.com/audios/cat_loop.mp3",
    "https://svarbucket.s3.amazonaws.com/audios/drum_loop.mp3"
  ]),
  DiffHalf(video_url: [
    "https://svarbucket.s3.amazonaws.com/audios/clapping.mp3",
    "https://svarbucket.s3.amazonaws.com/audios/coughing_loop.mp3"
  ])
];

List<MaleFemale> sampleMaleFemale = [
  MaleFemale(video_url: [
    "https://svarbucket.s3.amazonaws.com/audios/male_voice_sample.mp3",
    "https://svarbucket.s3.amazonaws.com/audios/female_voice_sample.mp3"
  ], correct_output: "male"),
  MaleFemale(video_url: [
    "https://svarbucket.s3.amazonaws.com/audios/female_voice_sample.mp3",
    "https://svarbucket.s3.amazonaws.com/audios/male_voice_sample.mp3",
  ], correct_output: "female")
];

List<ImageToAudio> sampleImageToAudio = [
  ImageToAudio(
      image_url: "https://svarbucket.s3.amazonaws.com/imgs/Whistle.png",
      audio_list: [
        "https://svarbucket.s3.amazonaws.com/audios/whistle.mp3",
        "https://svarbucket.s3.amazonaws.com/audios/akg_20250609_115930_81dd59ad.mp3"
      ],
      correct_output: "https://svarbucket.s3.amazonaws.com/audios/whistle.mp3")
];

List<ImageToAudio> sampleDiffImageToAudio = [
  ImageToAudio(
      image_url:
          "https://svarbucket.s3.amazonaws.com/images/akg_20250531_081701_ef0a2300.png",
      audio_list: [
        "https://svarbucket.s3.amazonaws.com/audios/akg_20250531_081659_83528d97.mp3",
        "https://svarbucket.s3.amazonaws.com/audios/akg_20250531_081657_594a1544.mp3"
      ],
      correct_output:
          "https://svarbucket.s3.amazonaws.com/audios/akg_20250531_081659_83528d97.mp3")
];

List<AudioToImage> sampleAudioToImage = [
  AudioToImage(
      audio_url: ["https://svarbucket.s3.amazonaws.com/audios/drum_loop.mp3"],
      correct_output: "https://svarbucket.s3.amazonaws.com/imgs/Drum.png",
      image_list: [
        "https://svarbucket.s3.amazonaws.com/imgs/coughing.png",
        "https://svarbucket.s3.amazonaws.com/imgs/Drum.png"
      ]),
  AudioToImage(
      audio_url: ["https://svarbucket.s3.amazonaws.com/audios/cat_loop.mp3"],
      correct_output: "https://svarbucket.s3.amazonaws.com/imgs/cat.png",
      image_list: [
        "https://svarbucket.s3.amazonaws.com/imgs/cat.png",
        "https://svarbucket.s3.amazonaws.com/imgs/phone.png"
      ]),
  AudioToImage(
      audio_url: [
        "https://svarbucket.s3.amazonaws.com/audios/car_honking_loop.mp3"
      ],
      correct_output: "https://svarbucket.s3.amazonaws.com/imgs/car.png",
      image_list: [
        "https://svarbucket.s3.amazonaws.com/imgs/car.png",
        "https://svarbucket.s3.amazonaws.com/imgs/cooker.png"
      ])
];

List<AudioToImage> sampleDiffAudioToImage = [
  AudioToImage(
      audio_url: [
        "https://svarbucket.s3.amazonaws.com/audios/akg_20250528_112523_1e5afea3.mp3"
      ],
      correct_output:
          "https://svarbucket.s3.amazonaws.com/images/akg_20250528_112530_fb2c839d.png",
      image_list: [
        "https://svarbucket.s3.amazonaws.com/images/akg_20250528_112530_fb2c839d.png",
        "https://svarbucket.s3.amazonaws.com/images/akg_20250528_112529_3df8a0a6.png"
      ])
];
