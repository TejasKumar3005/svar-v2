import 'package:flutter/material.dart';



/// A provider class for the PhonemsLevelScreenTwoScreen.
///
/// This provider manages the state of the PhonemsLevelScreenTwoScreen, including the
/// current phonemsLevelScreenTwoModelObj
class PhonemsLevelScreenTwoProvider extends ChangeNotifier {
TextEditingController imageSeventyNineController = TextEditingController();


@override
void dispose() {
super.dispose();
imageSeventyNineController.dispose();
}
}

