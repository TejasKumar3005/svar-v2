import 'package:flutter/material.dart';
import 'package:svar_new/presentation/phenome_list/phonmes_list_model.dart.dart';
import '../../../core/app_export.dart';

/// A provider class for the PhonmesListScreen.
///
/// This provider manages the state of the PhonmesListScreen, including the
/// current phonmesListModelObj
class PhonmesListProvider extends ChangeNotifier {
PhonmesListModel phonmesListModelObj = PhonmesListModel();

@override
void dispose() {
super.dispose();
}
}

