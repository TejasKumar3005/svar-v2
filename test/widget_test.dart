// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
import 'package:svar_new/widgets/audio_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Widget Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test Audio Widget'),
        ),
        body: Center(
          child: AudioWidget(
            audioLinks: [
              'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
              'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
              'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
            ], 
            imagePlayButtonKey: GlobalKey(),// replace with your audio links
          ),
        ),
      ),
    );
  }
}
