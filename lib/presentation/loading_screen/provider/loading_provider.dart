import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/loading_model.dart';

/// A provider class for the LoadingScreen.
///
/// This provider manages the state of the LoadingScreen, including the
/// current loadingModelObj

// ignore_for_file: must_be_immutable
class LoadingProvider extends ChangeNotifier {
  LoadingModel loadingModelObj = LoadingModel();

  @override
  void dispose() {
    super.dispose();
  }
}
