import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Store event in Firestore using a map with timestamp as the key
  Future<void> logEvent(
      String eventName, Map<String, dynamic> eventData) async {
    // Get the current timestamp
    String timestamp = DateTime.now().toIso8601String();
    String? uid = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser!.uid
        : null;

    if (uid == null) {
      return;
    }

    // Store the event data as a field in the user's document with the timestamp as key
    await _firestore.collection('user_activity').doc(uid).set(
      {
        timestamp: {
          'event': eventName,
          'data': eventData,
        },
      },
      SetOptions(merge: true), // Merge so we don't overwrite existing events
    );
  }

  Future<void> logScreenView(String screenName) async {
    await logEvent('screen_view', {
      'screen_name': screenName,
      'time': DateTime.now().toString(),
    });
  }

  Future<void> logSignIn(String email) async {
    await logEvent('sign_in', {
      'email': email,
      'time': DateTime.now().toString(),
    });
  }

  Future<void> logSignOut() async {
    await logEvent('sign_out', {
      'time': DateTime.now().toString(),
    });
  }

  Future<void> logAppOpen() async {
    await logEvent('app_open', {
      'time': DateTime.now().toString(),
    });
  }

  Future<void> logSignUp(String email) async {
    await logEvent("sign_up", {
      'email': email,
      'time': DateTime.now().toString(),
    });
  }

  Future<void> logTimeSpent(String screenName, int timeSpent) async {
    await logEvent('time_spent', {
      'screen_name': screenName,
      'time_spent': timeSpent,
      'time': DateTime.now().toString(),
    });
  }
}
