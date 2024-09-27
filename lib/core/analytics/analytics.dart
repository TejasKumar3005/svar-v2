import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
   FirebaseAnalytics _analytics = FirebaseAnalytics.instance;


  Future<void> logScreenView(String screenName,String userName) async {
    await _analytics.logScreenView(
      screenName: screenName,
      parameters: {
        "user_name":userName,
        "time": DateTime.now().toString()
      }
      
    );
  }

  Future<void> logSignIn(String email) async {
    await _analytics.logLogin(
      callOptions: AnalyticsCallOptions(global:true ),
      parameters: {
        email:email,
          "time": DateTime.now().toString()
      }
    );
  }
  Future<void> logSignup(String email) async {
    await _analytics.logSignUp(
    signUpMethod: "email",
      parameters: {
        email:email,
          "time": DateTime.now().toString()
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
