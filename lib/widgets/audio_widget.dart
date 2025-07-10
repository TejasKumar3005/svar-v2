import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:svar_new/core/network/cacheManager.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/widgets/Options.dart';
import 'dart:async';
import 'package:chiclet/chiclet.dart';

// Global audio player (keep this if you need only one instance)
AudioPlayer globalAudioPlayer = AudioPlayer();

class AudioWidget extends StatefulWidget {
  final List<String> audioLinks;
  final Color spectrumColor;
  final bool isGrid;

  const AudioWidget({
    Key? key,
    required this.audioLinks,
    this.spectrumColor = Colors.green,
    this.isGrid = false,
  }) : super(key: key);

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  late AudioPlayer _audioPlayer;
  late int currentIndex;
  late List<double> _lengths;
  late double totalLength;
  bool _isInitialized = false;

  // ValueNotifier for progress
  final ValueNotifier<double> _progress = ValueNotifier<double>(0.0);
  // ValueNotifier for playing state
  final ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);

  ValueNotifier<double> get progress => _progress;
  ValueNotifier<bool> get isPlaying => _isPlaying;
  List<double> get lengths => _lengths;
  bool get isInitialized => _isInitialized;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _audioPlayer = AudioPlayer();
    totalLength = 0.0;
    _lengths = [];
    _loadAudioLengths(); // Use _ to indicate private method

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (_audioPlayer.duration != null &&
          _audioPlayer.duration!.inSeconds > 0) {
        _progress.value = _calculateProgress(position);
      }
    });

    // Listen to player state changes
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      _isPlaying.value = state.playing;
    });
  }

  double _calculateProgress(Duration position) {
    double completedSeconds = 0;
    for (int i = 0; i < currentIndex; i++) {
      completedSeconds += _lengths[i];
    }
    return (completedSeconds + position.inSeconds.toDouble()) / totalLength;
  }

  Future<void> _loadAudioLengths() async {
    for (int i = 0; i < widget.audioLinks.length; i++) {
      double length = await _getAudioLength(widget.audioLinks[i]);
      _lengths.add(length);
      totalLength += length;
    }
    _isInitialized = true;
  }

  Future<double> _getAudioLength(String link) async {
    try {
      File? file;
      file =
          await CachingManager().getCachedFile(widget.audioLinks[currentIndex]);
      if (file != null) {
        await _audioPlayer.setAudioSource(AudioSource.file(file.path));
      } else {
        await _audioPlayer.setUrl(widget.audioLinks[currentIndex]);
      }

      var duration = await _audioPlayer.load();
      return duration?.inSeconds.toDouble() ?? 5.0; // Null check
    } catch (e) {
      print('Error loading audio: $e');
      return 5.0;
    }
  }

  Future<void> playNext() async {
    if (globalAudioPlayer.playing) {
      await globalAudioPlayer.stop();
    }

    globalAudioPlayer = _audioPlayer;

    if (currentIndex < widget.audioLinks.length) {
      try {
        File? file;
        file = await CachingManager()
            .getCachedFile(widget.audioLinks[currentIndex]);
        if (file != null) {
          await _audioPlayer.setAudioSource(AudioSource.file(file.path));
        } else {
          await _audioPlayer.setUrl(widget.audioLinks[currentIndex]);
        }
        await _audioPlayer.play();

        // Cancel previous subscription to prevent memory leaks
        _playerStateSubscription?.cancel();

        _playerStateSubscription =
            _audioPlayer.playerStateStream.listen((state) {
          // Update playing state
          _isPlaying.value = state.playing;

          if (state.processingState == ProcessingState.completed) {
            if (currentIndex < widget.audioLinks.length - 1) {
              // Move to next audio
              currentIndex++;
              playNext();
            } else {
              // All audio files have been played, stop completely
              _resetToStart();
            }
          }
        });
      } catch (e) {
        print('Error playing audio: $e');
        // Reset state on error
        _resetToStart();
      }
    }
  }

  void _resetToStart() {
    currentIndex = 0;
    _progress.value = 1.0; // Set progress to complete briefly
    _isPlaying.value = false; // Ensure playing state is false
    _audioPlayer.stop();

    // Reset progress after a short delay to show completion
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        _progress.value = 0.0;
      }
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    _progress.dispose(); // Dispose ValueNotifier
    _isPlaying.dispose(); // Dispose playing state ValueNotifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final click = ClickProvider.of(context)?.click;
    double containerWidth =
        MediaQuery.of(context).size.width * (widget.isGrid ? 0.4 : 0.9);

    return ChicletAnimatedButton(
      onPressed: () {},
      buttonType: ChicletButtonTypes.roundedRectangle,
      backgroundColor: const Color(0xFFF47C37),
      height: 50,
      width: containerWidth,
      padding: const EdgeInsets.all(3),
      child: widget.isGrid
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _isPlaying,
                  builder: (context, isPlayingValue, child) {
                    print("value is " + isPlayingValue.toString());
                    return CustomButton(
                      key: ValueKey(isPlayingValue),
                      type: isPlayingValue
                          ? ButtonType.ImagePause
                          : ButtonType.ImagePlay,
                      onPressed: () async {
                        if (isPlayingValue) {
                          await _audioPlayer.pause();
                          _isPlaying.value = false;
                        } else {
                          // If we're at the end, reset to start
                          if (currentIndex >= widget.audioLinks.length) {
                            currentIndex = 0;
                            _progress.value = 0.0;
                          }
                          playNext();
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ValueListenableBuilder<double>(
                    valueListenable: _progress,
                    builder: (context, progressValue, child) {
                      return CustomButton(
                        type: ButtonType.Spectrum,
                        clippingStyle: ClippingStyle.leftToRight,
                        animationCurve: Curves.linear,
                        // animationDuration: Duration(seconds: _lengths[currentIndex].toInt()),
                        onPressed: () {
                          if (click != null) {
                            click();
                          }
                        },
                        progress: progressValue, // Use ValueNotifier's value
                        color: widget.spectrumColor,
                      );
                    },
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10.0),
                ValueListenableBuilder<bool>(
                  valueListenable: _isPlaying,
                  builder: (context, isPlayingValue, child) {
                    return CustomButton(
                      key: ValueKey(isPlayingValue),
                      type: isPlayingValue
                          ? ButtonType.ImagePause
                          : ButtonType.ImagePlay,
                      onPressed: () async {
                        if (isPlayingValue) {
                          await _audioPlayer.pause();
                          _isPlaying.value = false;
                        } else {
                          // If we're at the end, reset to start
                          if (currentIndex >= widget.audioLinks.length) {
                            currentIndex = 0;
                            _progress.value = 0.0;
                          }
                          playNext();
                        }
                      },
                    );
                  },
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: click,
                    child: ValueListenableBuilder<double>(
                      valueListenable: _progress,
                      builder: (context, progressValue, child) {
                        return CustomButton(
                          type: ButtonType.Spectrum,
                          clippingStyle: ClippingStyle.leftToRight,
                          animationCurve: Curves.linear,

                          onPressed: () {
                            if (click != null) {
                              click();
                            }
                          },
                          progress: progressValue, // Use ValueNotifier's value
                          color: widget.spectrumColor,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
