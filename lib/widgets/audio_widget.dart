import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:svar_new/widgets/Options.dart';
import 'dart:async';
import 'package:chiclet/chiclet.dart';

// Global audio player to ensure only one instance plays at a time
AudioPlayer globalAudioPlayer = AudioPlayer();

class AudioWidget extends StatefulWidget {
  final List<String> audioLinks;
  final double progress;
  final Color spectrumColor;
  final bool isGrid;

  const AudioWidget({
    Key? key,
    required this.audioLinks,
    this.progress = 0.0,
    this.spectrumColor = Colors.green,
    this.isGrid = false, // Add isGrid parameter
  }) : super(key: key);

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  StreamSubscription<Duration>? _positionSubscription;
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
    loadAudioLengths();

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
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
    try {
      var duration = await _audioPlayer.setUrl(link);
      if (duration != null) {
        await _audioPlayer.load();
        return duration.inSeconds.toDouble();
      }
    } catch (e) {
      print('Error loading audio: $e');
    }
    return 5.0; // Fallback value
  }

  Future<void> playNext() async {
    if (globalAudioPlayer.playing) {
      await globalAudioPlayer.stop();
    }

    globalAudioPlayer = _audioPlayer;

    if (currentIndex < widget.audioLinks.length) {
      try {
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
      } catch (e) {
        print('Error playing audio: $e');
      }
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;
    double containerWidth =
        MediaQuery.of(context).size.width * (widget.isGrid ? 0.4 : 0.9);

    return ChicletAnimatedButton(
      onPressed: () {
        if (click != null) {
          click();
        }
      },
      buttonType: ChicletButtonTypes.roundedRectangle,
      backgroundColor: Color(0xFFF47C37),
      height: 50,
      width: containerWidth,
      child: widget.isGrid
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  type: ButtonType.ImagePlay,
                  onPressed: () {
                    _audioPlayer.playing ? _audioPlayer.pause() : playNext();
                  },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: CustomButton(
                    type: ButtonType.Spectrum,
                    onPressed: () {
                      if (click != null) {
                        click();
                      }
                    },
                    progress: progress,
                    color: widget.spectrumColor,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  type: ButtonType.ImagePlay,
                  onPressed: () {
                    _audioPlayer.playing ? _audioPlayer.pause() : playNext();
                  },
                ),
                const SizedBox(width: 5.0),
                Container(
                  height: 50,
                  width: 5,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: click,
                    child: CustomButton(
                      type: ButtonType.Spectrum,
                      onPressed: () {
                        if (click != null) {
                          click();
                        }
                      },
                      progress: progress,
                      color: widget.spectrumColor,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
