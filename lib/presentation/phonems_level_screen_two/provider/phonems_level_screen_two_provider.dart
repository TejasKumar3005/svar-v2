import 'package:flutter/material.dart';

import '../models/phonems_level_screen_two_model.dart';

/// A provider class for the PhonemsLevelScreenTwoScreen.
///
/// This provider manages the state of the PhonemsLevelScreenTwoScreen, including the
/// current phonemsLevelScreenTwoModelObj
class PhonemsLevelScreenTwoProvider extends ChangeNotifier {
TextEditingController imageSeventyNineController = TextEditingController();

PhonemsLevelScreenTwoModel phonemsLevelScreenTwoModelObj =
PhonemsLevelScreenTwoModel();

@override
void dispose() {
super.dispose();
imageSeventyNineController.dispose();
}
}

