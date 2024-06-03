import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
   FirebaseAnalytics _analytics = FirebaseAnalytics.instance;


  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      screenName: screenName,
      
    );
  }

  Future<void> logSignIn(String email) async {
    await _analytics.logLogin(
      callOptions: AnalyticsCallOptions(global:true ),
      parameters: {
        email:email
      }
    );
  }

  Future<void> logOpenApp() async {
    await _analytics.logAppOpen();
  }

  Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
