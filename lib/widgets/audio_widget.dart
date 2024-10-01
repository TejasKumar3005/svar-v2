import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/widgets/Options.dart';

// Global audio player to ensure only one instance plays at a time
AudioPlayer globalAudioPlayer = AudioPlayer();

class AudioWidget extends StatefulWidget {
  final List<String> audioLinks;
  final double progress; // Pass the current progress
  final Color spectrumColor;

  const AudioWidget({
    Key? key,
    required this.audioLinks,
    this.progress = 0.0,
    this.spectrumColor = Colors.green,
  }) : super(key: key);

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  late AudioPlayer _audioPlayer;
  late double progress;
  late int currentIndex;
  late double completed;
  late List<double> lengths;
  late double totalLength;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _audioPlayer = AudioPlayer();
    progress = 0.0;
    completed = 0.0;
    totalLength = 0.0;
    lengths = [];

    // Load audio lengths
    loadAudioLengths();

    // Listen to the audio player's position
    _audioPlayer.positionStream.listen((position) {
      if (_audioPlayer.duration != null &&
          _audioPlayer.duration!.inSeconds > 0) {
        setState(() {
          progress = (completed + position.inSeconds.toDouble()) / totalLength;
        });
      }
    });
  }

  Future<void> loadAudioLengths() async {
    for (int i = 0; i < widget.audioLinks.length; i++) {
      double length = await getAudioLength(widget.audioLinks[i]);
      lengths.add(length);
      totalLength += length;
    }
  }

  Future<double> getAudioLength(String link) async {
    var duration = await _audioPlayer.setUrl(link);
    if (duration != null) {
      await _audioPlayer.load(); // Wait for the audio to load
      return duration.inSeconds.toDouble(); // Return length in seconds
    } else {
      return 5.0; // Fallback value if the audio URL couldn't be loaded
    }
  }

  Future<void> playNext() async {
    // Pause or stop any audio that is currently playing
    if (globalAudioPlayer.playing) {
      await globalAudioPlayer.stop();
    }

    // Assign the globalAudioPlayer to control playback across widgets
    globalAudioPlayer = _audioPlayer;

    if (currentIndex < widget.audioLinks.length) {
      await _audioPlayer.setUrl(widget.audioLinks[currentIndex]);
      await _audioPlayer.play();
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (currentIndex < widget.audioLinks.length - 1) {
            setState(() {
              completed += lengths[currentIndex];
              currentIndex++;
            });
            playNext();
          } else {
            setState(() {
              currentIndex = 0;
              progress = 0.0;
              _audioPlayer.stop();
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.5, // Adjust the container width based on screen size
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFF47C37),
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomButton(
            type: ButtonType.ImagePlay,
            onPressed: () {
              if (_audioPlayer.playing) {
                _audioPlayer.pause();
              } else {
                playNext();
              }
            },
          ),
          const SizedBox(width: 5.0),
          Container(
            height: 50,
            width: 5,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (click != null) {
                  click();
                }
              },
              child: CustomButton(
                type: ButtonType.Spectrum,
                onPressed: () {
                  if (click != null) {
                    click();
                  }
                },
                progress: progress, // Pass dynamic progress
                color: widget.spectrumColor, // Pass dynamic color
              ),
            ),
            // Use Expanded to handle overflow
          ),
        ],
      ),
    );
  }
}
