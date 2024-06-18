import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppUpdateProvider extends ChangeNotifier {
  static const platform = MethodChannel('com.svarnew.app/update');

  double progress = 0;
  bool dialogOpen = false;
  String status = '';

  void setProgress(double value) {
    progress = value;
    notifyListeners();
  }

  void setStatus(String value) {
    status = value;
    notifyListeners();
  }

  void setCallHandler() {
    platform.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> checkForUpdate() async {
    try {
      status = "Checking for updates...";
      dialogOpen = true;
      await platform.invokeMethod('checkForUpdate');

    } on PlatformException catch (e) {
      dialogOpen = false;
      status = "Failed to check for updates: ${e.message}";
      notifyListeners();
    }
  }

  void closeDialog() {
    dialogOpen = false;
    notifyListeners();
  }
  
  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "updateProgress":
        progress = call.arguments;
        status =
            "Downloading update... ${(progress * 100).toStringAsFixed(0)}%";
        notifyListeners();
        break;
      case "updateFailed":
        status = "Update failed: ${call.arguments}";
        notifyListeners();
        break;
      case "updateSuccess":
        status = "Update successful!";
        notifyListeners();
        break;
      default:
        throw MissingPluginException();
    }
  }
}
