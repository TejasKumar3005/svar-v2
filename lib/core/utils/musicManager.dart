import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:svar_new/core/utils/playBgm.dart';
class MusicManager extends StatefulWidget {
  final Widget child;

  MusicManager({required this.child});

  @override
  _MusicManagerState createState() => _MusicManagerState();

  static _MusicManagerState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MusicManagerState>();
  }
}

class _MusicManagerState extends State<MusicManager>
    with WidgetsBindingObserver {
  final PlayBgm _playBgm = PlayBgm();

  List<String> screensWithoutMusic = [
    
    '/home',
    '/loading_screen',
    '/login',
      '/login_signup'
    '/register',
    "/auditory_screen",
    '/setting_screen',
    '/phonmes_list_screen',
    '/phonems_level_screen_one_screen',
    '/user_profile'
  ];

  @override
  void initState() {
    super.initState();

    // Register as an observer
    WidgetsBinding.instance.addObserver(this);

    // Start playing the music if not on an excluded screen
    _handleMusicPlayback();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playBgm.stopMusic();
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _playBgm.stopMusic();
    } else if (state == AppLifecycleState.resumed) {
      _handleMusicPlayback();
    }
  }

  void _handleMusicPlayback() {
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    debugPrint("Current Route: ");
    debugPrint(currentRoute + " kjjkkj");
    debugPrint("Screens");
    if (screensWithoutMusic.contains(currentRoute)) {
      _playBgm.playMusic('Main_Interaction_Screen.mp3', "mp3", true);
    } else {
      _playBgm.stopMusic();
    }
  }

  @override
  Widget build(BuildContext context) {
    _handleMusicPlayback(); // Ensure music starts or stops as per the current screen
    return widget.child;
  }
}
