import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:svar_new/widgets/custom_button.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:svar_new/widgets/Options.dart';

class AudioWidget extends StatefulWidget {
  final List<String> audioLinks; // Optional click function from parent

  const AudioWidget({Key? key, required this.audioLinks}) : super(key: key);

  @override
  AudioWidgetState createState() => AudioWidgetState();
}

class AudioWidgetState extends State<AudioWidget> {
  late AudioPlayer _audioPlayer;
  late double progress;
  late int currentIndex;
  late double completed;
  late List<double> lengths;
  late double total_length;

@override
void initState() {
  super.initState();
  currentIndex = 0;
  _audioPlayer = AudioPlayer();
  progress = 0.0;
  completed = 0.0;
  total_length = 0.0;
  lengths = [];
  
  print("widget.audioLinks is ${widget.audioLinks.length}");
  
  // Call the async function to ensure the for loop runs sequentially
  loadAudioLengths();
  
  // Subscribe to the audio player's position stream
  _audioPlayer.positionStream.listen((position) {
    if (_audioPlayer.duration != null && _audioPlayer.duration!.inSeconds > 0) {
      setState(() {
        progress = (completed + position.inSeconds.toDouble()) / total_length;
      });
    }
  });
}

Future<void> loadAudioLengths() async {
  for (int i = 0; i < widget.audioLinks.length; i++) {
    print("i is $i");
    print("audio link is ${widget.audioLinks[i]}");
    
    // Await the result of the async function before continuing the loop
    double length = await get_audio_length(widget.audioLinks[i]);
    
    print("value is $length");
    lengths.add(length);
    total_length += length;
    
    print("length is $length");
    print("total_length is $total_length");
  }
  
  print("lengths is $lengths");
  print("total_length is $total_length");
}

Future<double> get_audio_length(String link) async {
  print("hi $link");
  
  var j = await _audioPlayer.setUrl(link);
  print("bye $link");
  
  if (j != null) {
    print("j is ${j.inMilliseconds}");
    await _audioPlayer.load();  // Wait for the audio to load
    return j.inMilliseconds.toDouble() / 1000;  // Return the length in seconds
  } else {
    return 5.0;  // Fallback value if the audio URL couldn't be loaded
  }
}

  Future<void> playNext() async {
    print("currentIndex: $currentIndex");
    print("progress: ${progress}");
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
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFF47C37),
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
            print("detected");
              if (_audioPlayer.playing) {
                _audioPlayer.pause();
              } else {
                playNext();
              }
            },
            child: CustomButton(
              type: ButtonType.ImagePlay,
              onPressed: () {
                print("pressed");
                if (_audioPlayer.playing) {
                  _audioPlayer.pause();
                } else {
                  playNext();
                }
              },
            ),
          ),
          Container(
            height: 50,
            width: 5,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(width: 16.0),
          GestureDetector(
            onTap: () {
              print("Clicked in gesture detector");
              // Optionally handle any other tap events here
              if (click != null) {
                print("click is not null");
                click();
              }
            },
            child: Stack(
              children: [
                // First, display the original SVG (which remains white)
                SvgPicture.asset(
                  'assets/images/svg/Spectrum.svg', // Path to your SVG
                  width: MediaQuery.of(context).size.width * 0.3, // Adjust size
                  height: 60,
                ),
                // Overlay only the green part based on the progress
                Positioned.fill(
                  child: ClipRect(
                    clipper: _ProgressClipper(
                      progress: progress, // Pass dynamic progress here
                    ),
                    child: SvgPicture.asset(
                      'assets/images/svg/Spectrum.svg', // Same SVG path
                      width: MediaQuery.of(context).size.width *
                          0.3, // Adjust size
                      height: 60,
                      color: Colors.green, // Green overlay only on progress
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressClipper extends CustomClipper<Rect> {
  final double progress;

  _ProgressClipper({required this.progress});

  @override
  Rect getClip(Size size) {
    // Clip the SVG based on the progress
    return Rect.fromLTWH(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true; // Reclip every time progress changes
  }
}
