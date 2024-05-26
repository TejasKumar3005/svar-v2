import 'dart:core';
/*
    Similar to visual representation
 */
class AudioToVisual
{
  final String input_audio_url;
  final List<String> option_image_url;
  final String output_ref;

  AudioToVisual._({required this.input_audio_url , required this.option_image_url , required this.output_ref});
  factory AudioToVisual.fromMap(Map<String , dynamic> json){
    return AudioToVisual._(
        input_audio_url: json["input_audio_url"],
        option_image_url: json["option_image_url"],
        output_ref: json["output_ref"]
    );
  }

}

class AudioToAudioMicro
{
  final String input_audio_url;
  final String output_text;
  AudioToAudioMicro._({required this.input_audio_url , required this.output_text});
  factory AudioToAudioMicro.fromMap(Map<String , dynamic> json){
   return AudioToAudioMicro._(
       input_audio_url: json["input_audio_url"],
       output_text: json["output_text"]
   );
  }
}
class AudioAudioOpt
{
  final String input_audio_url;
  final List<String> option_audio_url;
  final String output_ref;
  AudioAudioOpt._({required this.input_audio_url , required this.option_audio_url , required this.output_ref});
  factory AudioAudioOpt.fromMap(Map<String , dynamic> json){
    return AudioAudioOpt._(
        input_audio_url: json["input_audio_url"],
        option_audio_url: json["option_audio_url"],
        output_ref: json["output_ref"]
    );
  }
}