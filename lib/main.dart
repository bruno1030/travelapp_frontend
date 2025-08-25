import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'generated/app_localizations.dart';
import 'controllers/locale_controller.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // necessário para Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleController()),
        ChangeNotifierProvider(
          create: (_) => AuthController()..init(),
          child: const MyApp(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Provider.of<LocaleController>(context);

    return MaterialApp(
      title: 'Clixpot',
      theme: ThemeData(primarySwatch: Colors.blue),
      locale: localeController.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('ja', 'JP'),
        Locale('zh', 'CN'),
        Locale('de', 'DE'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
      ],
      home: const HomeScreen(),
    );
  }
}
