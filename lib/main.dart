import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:svar_new/core/utils/firebaseoptions.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_screen_audio/auditory_screen_assessment_screen_audio_visual_one_screen.dart';
import 'package:svar_new/presentation/auditory_screen_assessment_visual/auditory_screen_assessment_screen_visual_audio_screen.dart';
import 'package:svar_new/providers/userDataProvider.dart';
import 'core/app_export.dart';
import 'package:svar_new/database/authentication.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> initializeFirebase() async {
  const firebaseConfig = FirebaseOptions(
 apiKey: "AIzaSyBO_ie7IMB82HbFgT90Rz6JOz35iUVz55M",
  authDomain: "svar-v2-4f0f4.firebaseapp.com",
  databaseURL: "https://svar-v2-4f0f4-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "svar-v2-4f0f4",
  storageBucket: "svar-v2-4f0f4.appspot.com",
  messagingSenderId: "628827446185",
  appId: "1:628827446185:web:951f546cf62d94092742b8",
  measurementId: "G-V50ECXEL5P"
);

  await Firebase.initializeApp(
    options: kIsWeb ? firebaseConfig : null,
  );
}


var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() async {
  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //       options: Options().options
            
  //           );
  // } else {
  //   await Firebase.initializeApp();
  // }

  // Future.wait([
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //   ]),
  //   PrefUtils().init()
  // ]).then((value) {
  //   initializeFirebase();
  //   runApp(MyApp());
  // });
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(MyApp());
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
                  CountryLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: locals,
                initialRoute:auth.currentUser!=null? AppRoutes
                    .loginScreenPotraitScreen:AppRoutes.logInSignUpScreenPotraitScreen, //auditoryScreenAssessmentScreenAudioVisualResizedScreen
                routes: AppRoutes.routes,
                
                // home: PhonmesListScreen(),
              );
            },
          ),
        );
      },
    );
  }
}


