import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/analytics/screen-tracking.dart';
import 'package:svar_new/core/utils/firebaseoptions.dart';
import 'package:svar_new/core/utils/musicManager.dart';
import 'package:svar_new/presentation/auditory_screen/provider/auditory_provider.dart';
import 'package:svar_new/presentation/ling_learning/ling_learning_provider.dart';
import 'package:svar_new/presentation/home/provider/main_interaction_provider.dart';
import 'package:svar_new/presentation/phoneme_level_one/provider/level_one_provider.dart';
import 'package:svar_new/presentation/settings_screen/setting.dart';
import 'package:svar_new/providers/appUpdateProvider.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'core/app_export.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: kIsWeb ? Options().options : null,
  );
}

Future<User?> initializeFirebaseAuth() async {
  final completer = Completer<User?>();

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (!completer.isCompleted) {
      completer.complete(user);
    }
  });

  return completer.future;
}

final globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  if (kIsWeb) {
    await Firebase.initializeApp(options: Options().options);
  } else {
    await Firebase.initializeApp();
  }

  final AnalyticsService analyticsService = AnalyticsService();
  await analyticsService.logOpenApp();

  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]),
    PrefUtils().init()
  ]).then((value) {
    initializeFirebaseAuth();
    runApp(
      MusicManager(
        child: MyApp(
        analyticsService: analyticsService,
            ),
      ));
  });
// final AnalyticsService analyticsService = AnalyticsService();
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeFirebase();
//   runApp(MyApp(analyticsService));
}

class MyApp extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final AnalyticsService analyticsService;
  final ScreenTracking _screenTracking;
  final NetworkInfo _networkInfo = NetworkInfo();

  MyApp({required this.analyticsService})
      : _screenTracking = ScreenTracking(analyticsService) {
    _networkInfo.onConnectivityChanged.listen((ConnectivityResult result) {
      final isConnected = result != ConnectivityResult.none;
      showConnectivitySnackBar(isConnected);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => ThemeProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => UserDataProvider(),
            ),
            ChangeNotifierProvider(create: (context) => LingLearningProvider()),
            ChangeNotifierProvider(
              create: (context) => MainInteractionProvider(),
            ),
            ChangeNotifierProvider(create: (context) => AppUpdateProvider()),
            ChangeNotifierProvider(
                create: (context) => PhonemsLevelOneProvider()),
            ChangeNotifierProvider(
                create: (context) =>
                    AuditoryProvider()),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return MaterialApp(
                theme: theme,
                title: 'Svar',
                navigatorKey: NavigatorService.navigatorKey,
                scaffoldMessengerKey: globalMessengerKey,
                debugShowCheckedModeBanner: false,
                navigatorObservers: [_screenTracking],
                localizationsDelegates: [
                  AppLocalizationDelegate(),
                  // CountryLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                // supportedLocales: locals,
                // initialRoute: AppRoutes.logInSignUpScreenPotraitScreen,
                initialRoute: auth.currentUser == null
                    ? AppRoutes.loginSignup
                    : AppRoutes
                        .loadingScreen, //auditoryScreenAssessmentScreenAudioVisualResizedScreen
                routes: AppRoutes.routes,
                // home: SettingsScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
