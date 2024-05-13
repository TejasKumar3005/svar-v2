import 'package:flutter/material.dart';

import '../models/phonems_level_screen_one_model.dart';

/// A provider class for the PhonemsLevelScreenOneScreen.
///
/// This provider manages the state of the PhonemsLevelScreenOneScreen, including the
/// current phonemsLevelScreenOneModelObj
class PhonemsLevelScreenOneProvider extends ChangeNotifier {
PhonemsLevelScreenOneModel phonemsLevelScreenOneModelObj =
PhonemsLevelScreenOneModel();

@override
void dispose() {
super.dispose();
}
}

