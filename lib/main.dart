import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:svar_new/core/analytics/analytics.dart';
import 'package:svar_new/core/analytics/screen-tracking.dart';
import 'package:svar_new/core/utils/firebaseoptions.dart';
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

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

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
      DeviceOrientation.portraitUp,
    ]),
    PrefUtils().init()
  ]).then((value) {
    initializeFirebaseAuth();
    runApp(MyApp(analyticsService));
  });
// final AnalyticsService analyticsService = AnalyticsService();
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeFirebase();
//   runApp(MyApp(analyticsService));
}

Iterable<Locale> locals = [
  Locale("af"),
  Locale("am"),
  Locale("ar"),
  Locale("az"),
  Locale("be"),
  Locale("bg"),
  Locale("bn"),
  Locale("bs"),
  Locale("ca"),
  Locale("cs"),
  Locale("da"),
  Locale("de"),
  Locale("el"),
  Locale("en"),
  Locale("es"),
  Locale("et"),
  Locale("fa"),
  Locale("fi"),
  Locale("fr"),
  Locale("gl"),
  Locale("ha"),
  Locale("he"),
  Locale("hi"),
  Locale("hr"),
  Locale("hu"),
  Locale("hy"),
  Locale("id"),
  Locale("is"),
  Locale("it"),
  Locale("ja"),
  Locale("ka"),
  Locale("kk"),
  Locale("km"),
  Locale("ko"),
  Locale("ku"),
  Locale("ky"),
  Locale("lt"),
  Locale("lv"),
  Locale("mk"),
  Locale("ml"),
  Locale("mn"),
  Locale("ms"),
  Locale("nb"),
  Locale("nl"),
  Locale("nn"),
  Locale("no"),
  Locale("pl"),
  Locale("ps"),
  Locale("pt"),
  Locale("ro"),
  Locale("ru"),
  Locale("sd"),
  Locale("sk"),
  Locale("sl"),
  Locale("so"),
  Locale("sq"),
  Locale("sr"),
  Locale("sv"),
  Locale("ta"),
  Locale("tg"),
  Locale("th"),
  Locale("tk"),
  Locale("tr"),
  Locale("tt"),
  Locale("uk"),
  Locale("ug"),
  Locale("ur"),
  Locale("uz"),
  Locale("vi"),
  Locale("zh")
];

class MyApp extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  final AnalyticsService _analyticsService;
  final ScreenTracking _screenTracking;

  MyApp(this._analyticsService)
      : _screenTracking = ScreenTracking(_analyticsService);
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
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return MaterialApp(
                theme: theme,
                title: 'svar_new',
                navigatorKey: NavigatorService.navigatorKey,
                scaffoldMessengerKey: globalMessengerKey,
                debugShowCheckedModeBanner: false,
                navigatorObservers: [_screenTracking],
                localizationsDelegates: [
                  AppLocalizationDelegate(),
                  CountryLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: locals,
                initialRoute: auth.currentUser == null
                    ? AppRoutes.logInSignUpScreenPotraitScreen
                    : AppRoutes
                        .loadingScreen, //auditoryScreenAssessmentScreenAudioVisualResizedScreen
                routes: AppRoutes.routes,
              );
            },
          ),
        );
      },
    );
  }
}
