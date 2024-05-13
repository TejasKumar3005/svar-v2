import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:svar_new/data/models/game_statsModel.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'package:svar_new/widgets/game_stats_header.dart';
import 'core/app_export.dart';
import 'package:svar_new/database/authentication.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //       options: FirebaseOptions(
  //           apiKey: "AIzaSyBsu-nyp97TJiICB9WtvuH05Ygap7xLpsU",
  //           appId: "1:346602804482:web:57ea49a41e7b6a9cc2de1b",
  //           messagingSenderId: "346602804482",
  //           projectId: "faceattendance-a1720"));
  // } else {
  //   await Firebase.initializeApp();
  // }
  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
    PrefUtils().init()
  ]).then((value) {
    runApp(MyApp());
  });
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
            ChangeNotifierProvider(
              create: (context) => AuthConroller(),
            ),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return MaterialApp(
                theme: theme,
                title: 'svar_new',
                navigatorKey: NavigatorService.navigatorKey,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
                  AppLocalizationDelegate(),
                  CountryLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: locals,
                // initialRoute: AppRoutes.mainInteractionScreen,
                // routes: AppRoutes.routes,
                home: AppStatsHeader(),
              );
            },
          ),
        );
      },
    );
  }
}
