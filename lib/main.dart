import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'core/app_export.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBsu-nyp97TJiICB9WtvuH05Ygap7xLpsU",
            appId: "1:346602804482:web:57ea49a41e7b6a9cc2de1b",
            messagingSenderId: "346602804482",
            projectId: "faceattendance-a1720"));
  }else{

  await Firebase.initializeApp();
  }
  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
    PrefUtils().init()
  ]).then((value) {
    runApp(MyApp());
  });
}

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
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: [
                  Locale(
                    'en',
                    '',
                  ),
                ],
                initialRoute: AppRoutes.registerFormScreenPotratitV1ChildScreen,
                routes: AppRoutes.routes,
              );
            },
          ),
        );
      },
    );
  }
}
