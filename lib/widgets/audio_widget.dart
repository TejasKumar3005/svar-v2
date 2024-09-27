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
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  late AudioPlayer _audioPlayer;
  late double _progress;
  late int currentIndex;
  late List<double> lengths;

  Future <double> get_audio_length(String link) async {

    var j = await _audioPlayer.setUrl(link);
      print("j is ${j!.inMilliseconds}");
      await _audioPlayer.load();
      return  j != null ? j.inMilliseconds.toDouble() / 1000 : 2.0;

  }

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _audioPlayer = AudioPlayer();
    _progress = 0.0;
    double total_length = 0.0;
    lengths = [];
    print("widget.audioLinks is ${widget.audioLinks.length}");
    for (int i = 0; i < widget.audioLinks.length; i++) {
      // double length = 0.0;
      print("i is $i");
      get_audio_length(widget.audioLinks[i]).then((value) {
        print("value is $value");
        double length = value;
      print("length is $length");
      lengths.add(length);
      total_length += length;
      print("total_length is $total_length");
      });
    }
    print("lengths is $lengths");
    print("total_length is $total_length");
    _audioPlayer.positionStream.listen((position) {
      if (_audioPlayer.duration != null &&
          _audioPlayer.duration!.inSeconds > 0) {
        setState(() {
          _progress = position.inSeconds / total_length;
        });
      }
    });
  }

  Future<void> playNext() async {
    print("currentIndex: $currentIndex");
    print("progress: ${_progress}");
    if (currentIndex < widget.audioLinks.length) {
      await _audioPlayer.setUrl(widget.audioLinks[currentIndex]);
      await _audioPlayer.play();
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (currentIndex < widget.audioLinks.length - 1) {
            setState(() {
              currentIndex++;
            });
            playNext();
          } else {
            setState(() {
              currentIndex = 0;
              _progress = 0.0;
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
                      progress: _progress, // Pass dynamic progress here
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
