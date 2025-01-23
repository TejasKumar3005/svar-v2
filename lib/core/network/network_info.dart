import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/main.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

// For checking internet connectivity
abstract class NetworkInfoI {
  Future<bool> isConnected();

  Future<List<ConnectivityResult>> get connectivityResult;

  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class NetworkInfo implements NetworkInfoI {
  Connectivity connectivity;

  static final NetworkInfo _networkInfo = NetworkInfo._internal(Connectivity());

  factory NetworkInfo() {
    return _networkInfo;
  }

  NetworkInfo._internal(this.connectivity) {
    connectivity = this.connectivity;
  }

  ///checks internet is connected or not
  ///returns [true] if internet is connected
  ///else it will return [false]
  @override
  Future<bool> isConnected() async {
    final result = await connectivity.checkConnectivity();
    if (result != ConnectivityResult.none) {
      return true;
    }
    return false;
  }

  // to check type of internet connectivity
  @override
  Future<List<ConnectivityResult>> get connectivityResult async {
    return connectivity.checkConnectivity();
  }

  //check the type on internet connection on changed of internet connection
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;
}

void showConnectivitySnackBar(bool isConnected) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    duration: const Duration(seconds: 3),
    content: AwesomeSnackbarContent(
      title: isConnected ? 'Connected' : 'No Internet',
      message: isConnected
          ? 'Your device is now connected to the internet'
          : 'Please check your internet connection',
      contentType: isConnected ? ContentType.success : ContentType.failure,
      // Optional custom colors if you want to override the default ones
      color: isConnected ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C),
      // Customize icons
      inMaterialBanner: true,
    ),
  );

  // If you're using a GlobalKey<ScaffoldMessengerState>
  globalMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
