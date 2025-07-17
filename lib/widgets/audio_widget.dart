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

// Global list to track all AudioWidget instances
List<AudioWidgetState> _allAudioWidgets = [];

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
  Timer? _progressTimer;
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

    // Add this instance to the global list
    _allAudioWidgets.add(this);

    _loadAudioLengths(); // Use _ to indicate private method

    // Use a more frequent position stream for smoother animation
    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      if (_audioPlayer.duration != null &&
          _audioPlayer.duration!.inMilliseconds > 0) {
        _progress.value = _calculateProgress(position);
      }
    });

    // Add a high-frequency timer for ultra-smooth progress updates
    _progressTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_audioPlayer.playing && mounted) {
        final position = _audioPlayer.position;
        if (_audioPlayer.duration != null &&
            _audioPlayer.duration!.inMilliseconds > 0) {
          _progress.value = _calculateProgress(position);
        }
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
    // Use milliseconds for smoother progress calculation
    double currentPositionSeconds = position.inMilliseconds / 1000.0;
    double progress = (completedSeconds + currentPositionSeconds) / totalLength;
    // Clamp the progress between 0.0 and 1.0 to prevent overflow
    return progress.clamp(0.0, 1.0);
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
      file = await CachingManager().getCachedFile(link);
      if (file != null) {
        await _audioPlayer.setAudioSource(AudioSource.file(file.path));
      } else {
        await _audioPlayer.setUrl(link);
      }

      var duration = await _audioPlayer.load();
      // Use milliseconds for more precise duration calculation
      return duration?.inMilliseconds.toDouble() != null
          ? duration!.inMilliseconds.toDouble() / 1000.0
          : 5.0; // Null check
    } catch (e) {
      print('Error loading audio: $e');
      return 5.0;
    }
  }

  Future<void> playNext() async {
    globalAudioPlayer = _audioPlayer;

    if (currentIndex < widget.audioLinks.length) {
      try {
        _resetAllOtherAudioWidgets(this);
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

  // Method to reset this widget to the beginning
  void resetToBeginning() {
    if (mounted) {
      setState(() {
        _audioPlayer.stop();
        currentIndex = 0;
        _progress.value = 0.0;
        _isPlaying.value = false;
      });
    }
  }

  // Static method to reset all other AudioWidgets except the current one
  static void _resetAllOtherAudioWidgets(AudioWidgetState currentWidget) {
    for (AudioWidgetState widget in _allAudioWidgets) {
      if (widget != currentWidget && widget.mounted) {
        widget.resetToBeginning();
      }
    }
  }

  // Method to start playing with proper reset of other widgets
  Future<void> startPlaying() async {
    // Always reset all other AudioWidgets when this one starts playing
    _resetAllOtherAudioWidgets(this);

    // If we're at the end, reset to start
    if (currentIndex >= widget.audioLinks.length) {
      currentIndex = 0;
      _progress.value = 0.0;
    }

    await playNext();
  }

  @override
  void dispose() {
    // Remove this instance from the global list
    _allAudioWidgets.remove(this);

    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _progressTimer?.cancel(); // Cancel the progress timer
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
                          await startPlaying();
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
                          await startPlaying();
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
