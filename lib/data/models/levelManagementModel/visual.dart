import 'dart:core';
/*

    There can be two ways of learning representation (for now) => ref from figma design (section - underneath of level diagram)
      01. Text To Visual
              There will be an image of with some text and there will be some images options related to text and it must matched with one option
      02. Visual To Audio
              There will be an image , and child has to speak.
              Here , there can be two section mainly
                    -- there will be audio provided
                    -- child has to speak something
 */

class VisualToVisual
{
    final String input_image_url;
    final List<String> options_images_urls;
    final String output_ref;

    VisualToVisual._({required this.input_image_url , required this.options_images_urls , required this.output_ref});
    factory VisualToVisual.fromJson(Map<String , dynamic> json)
    {
        return VisualToVisual._(
            input_image_url: json["input_image_url"],
            options_images_urls: json["options_images_urls"],
            output_ref: json["output_ref"]
        );
    }
}
class VisualToAudioEmbed
{
    final String input_image_url;
    final String option_audio_url;
    final String output_ref;

    VisualToAudioEmbed._({required this.input_image_url , required this.option_audio_url , required this.output_ref});
    factory VisualToAudioEmbed.fromMap(Map<String , dynamic> json){
        return VisualToAudioEmbed._(
            input_image_url: json["input_image_url"],
            option_audio_url: json["option_audio_url"],
            output_ref: json["output_ref"]
        );
    }
}

class VisualToAudioMicro
{
    final String input_url;
    final String input_image_text;

    VisualToAudioMicro._({required this.input_url , required this.input_image_text});
    factory VisualToAudioMicro.fromMap(Map<String , dynamic >json){
        return VisualToAudioMicro._(
            input_url: json["input_url"],
            input_image_text: json["input_image_text"]
        );
    }
}
