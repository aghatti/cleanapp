import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'start.dart';
import 'login.dart';
import 'home.dart';
import 'splash_start.dart';
import 'report_problem.dart';

// TODO: Convert ShrineApp to stateful widget (104)
class CleaningApp extends StatefulWidget {
  const CleaningApp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CleaningAppState();


}
class _CleaningAppState extends State<CleaningApp> {
  //late final AuthenticationRepository _authenticationRepository;
  //late final UserRepository _userRepository;

  //ColorSeed colorSelected = ColorSeed.baseColor;


  @override
  void initState() {
    super.initState();
    //_authenticationRepository = AuthenticationRepository();
    //_userRepository = UserRepository();
  }

  @override
  void dispose() {
    //_authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const CleaningAppView();
  }
}

class CleaningAppView extends StatefulWidget {
  const CleaningAppView({super.key});

  @override
  State<CleaningAppView> createState() => _CleaningAppViewState();
}

class _CleaningAppViewState extends State<CleaningAppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Clean App',
      /*localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('ru'), // Russian
      ],*/
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/splash_start',
      routes: {
        '/splash_start': (BuildContext context) =>
        const SplashPage(primaryColor: Color.fromRGBO(255, 255, 255, 1.0), secondaryColor: Color.fromRGBO(126, 123, 244, 1.0)),
        //'/login': (BuildContext context) => const LoginPage(),
        // TODO: Change to a Backdrop with a HomePage frontLayer (104)
        '/': (BuildContext context) => const StartPage(),
        '/home': (BuildContext context) => const HomePage(),
        // TODO: Make currentCategory field take _currentCategory (104)
        // TODO: Pass _currentCategory for frontLayer (104)
        // TODO: Change backLayer field value to CategoryMenuPage (104)
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/login") {
          return PageRouteBuilder(
              settings: settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
              //pageBuilder: (_, __, ___) => const LoginPage(),
              pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
              //transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                final tween = Tween(begin: begin, end: end);
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: curve,
                );

                return SlideTransition(
                  position: tween.animate(curvedAnimation),
                  child: child,
                );
              }
          );
        }
        else if(settings.name == "/report_problem") {
          return PageRouteBuilder(
              settings: settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
              //pageBuilder: (_, __, ___) => const LoginPage(),
              pageBuilder: (context, animation, secondaryAnimation) => const ReportProblemPage(),
              //transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                final tween = Tween(begin: begin, end: end);
                final curvedAnimation = CurvedAnimation(
                  parent: animation,
                  curve: curve,
                );

                return SlideTransition(
                  position: tween.animate(curvedAnimation),
                  child: child,
                );
              }
          );
        }
        // Unknown route
        //return MaterialPageRoute(builder: (_) => UnknownPage());
      },

      themeMode: ThemeMode.light,
      // TODO: Customize the theme (103)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(85, 81, 241, 1.0)),
        useMaterial3: true,
        brightness: Brightness.light,

        /*textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Hind'),
          headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
        ),*/
      ),

    );
  }
}

