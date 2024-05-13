import 'package:flutter/material.dart';

import '../models/tip_box_video_model.dart';

/// A provider class for the TipBoxVideoScreen.
///
/// This provider manages the state of the TipBoxVideoScreen, including the
/// current tipBoxVideoModelObj

// ignore_for_file: must_be_immutable
class TipBoxVideoProvider extends ChangeNotifier {
TipBoxVideoModel tipBoxVideoModelObj = TipBoxVideoModel();

@override
void dispose() {
super.dispose();
}
}

