import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:chiclet/chiclet.dart';

class AudioWidget extends StatefulWidget {
  final List<String> audioLinks;
  final Color waveformColor;
  final bool isGrid;

  const AudioWidget({
    Key? key,
    required this.audioLinks,
    this.waveformColor = Colors.green,
    this.isGrid = false,
  }) : super(key: key);

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  late AudioPlayer audioPlayer;
  late BehaviorSubject<WaveformProgress> _progressStream;
  late int currentIndex;
  late Duration currentPosition = Duration.zero;
  late Duration totalDuration = Duration.zero;
  bool isPlaying = false;

  // Getter for current progress
  double get progress {
    if (totalDuration == Duration.zero) return 0.0;
    return currentPosition.inMilliseconds / totalDuration.inMilliseconds;
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _progressStream = BehaviorSubject<WaveformProgress>();
    currentIndex = 0;
    _initializeAudio();
    
    audioPlayer.positionStream.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });

    audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          totalDuration = duration;
        });
      }
    });
  }

  Future<void> _initializeAudio() async {
    if (widget.audioLinks.isEmpty) return;
    
    try {
      // Get temporary directory for storing files
      final tempDir = await getTemporaryDirectory();
      final audioFile = File(path.join(tempDir.path, 'audio_${currentIndex}.mp3'));
      
      // Download and save the audio file
      final response = await http.get(Uri.parse(widget.audioLinks[currentIndex]));
      await audioFile.writeAsBytes(response.bodyBytes);
      
      // Create waveform file
      final waveFile = File(path.join(tempDir.path, 'waveform_${currentIndex}.wave'));
      
      // Extract waveform
      JustWaveform.extract(
        audioInFile: audioFile,
        waveOutFile: waveFile,
        zoom: const WaveformZoom.pixelsPerSecond(100),
      ).listen(
        _progressStream.add,
        onError: _progressStream.addError,
      );

      // Set audio source
      await audioPlayer.setFilePath(audioFile.path);
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  Future<void> _playPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * (widget.isGrid ? 0.4 : 0.9);

    return ChicletAnimatedButton(
      onPressed: () {},
      buttonType: ChicletButtonTypes.roundedRectangle,
      backgroundColor: Color(0xFFF47C37),
      height: 50,
      width: containerWidth,
      child: widget.isGrid ? _buildGridLayout() : _buildRowLayout(),
    );
  }

  Widget _buildGridLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _playPause,
          color: Colors.white,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _buildWaveform(),
        ),
      ],
    );
  }

  Widget _buildRowLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _playPause,
          color: Colors.white,
        ),
        const SizedBox(width: 5.0),
        Container(
          height: 50,
          width: 5,
          decoration: const BoxDecoration(color: Colors.white),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: _buildWaveform(),
        ),
      ],
    );
  }

  Widget _buildWaveform() {
    return StreamBuilder<WaveformProgress>(
      stream: _progressStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data?.waveform == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final waveform = snapshot.data!.waveform!;
        final progress = totalDuration.inMilliseconds > 0
            ? currentPosition.inMilliseconds / totalDuration.inMilliseconds
            : 0.0;

        return AudioWaveformWidget(
          waveform: waveform,
          start: Duration.zero,
          duration: totalDuration,
          waveColor: widget.waveformColor,
          progress: progress,
        );
      },
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _progressStream.close();
    super.dispose();
  }
}

// Add progress indicator to the AudioWaveformWidget
class AudioWaveformWidget extends StatelessWidget {
  final Waveform waveform;
  final Duration start;
  final Duration duration;
  final Color waveColor;
  final double progress;

  const AudioWaveformWidget({
    Key? key,
    required this.waveform,
    required this.start,
    required this.duration,
    required this.waveColor,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: AudioWaveformPainter(
          waveform: waveform,
          start: start,
          duration: duration,
          waveColor: waveColor,
          progress: progress,
        ),
      ),
    );
  }
}

class AudioWaveformPainter extends CustomPainter {
  final Waveform waveform;
  final Duration start;
  final Duration duration;
  final Color waveColor;
  final double progress;
  final Paint wavePaint;
  final Paint progressPaint;

  AudioWaveformPainter({
    required this.waveform,
    required this.start,
    required this.duration,
    required this.waveColor,
    required this.progress,
  }) : wavePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..strokeCap = StrokeCap.round
    ..color = waveColor.withOpacity(0.5),
    progressPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..strokeCap = StrokeCap.round
    ..color = waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (duration == Duration.zero) return;

    final progressWidth = size.width * progress;
    final height = size.height;
    final waveformPixelsPerWindow = waveform.positionToPixel(duration);
    final pixelsPerStep = waveformPixelsPerWindow / size.width;

    for (var x = 0.0; x < size.width; x++) {
      final sampleIdx = (x * pixelsPerStep).toInt();
      final minY = _normalizeY(waveform.getPixelMin(sampleIdx), height);
      final maxY = _normalizeY(waveform.getPixelMax(sampleIdx), height);

      // Draw background waveform
      canvas.drawLine(
        Offset(x, minY),
        Offset(x, maxY),
        x <= progressWidth ? progressPaint : wavePaint,
      );
    }
  }

  double _normalizeY(int sample, double height) {
    final normalized = (sample + 32768) / 65536;
    return height - (normalized * height);
  }

  @override
  bool shouldRepaint(covariant AudioWaveformPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}