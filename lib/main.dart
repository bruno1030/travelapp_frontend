import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('pt', 'BR'); // Idioma padrão

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: _locale, // Aplica a mudança de idioma
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'), // Inglês
        Locale('pt', 'BR'), // Português
        Locale('ja', 'JP'), // Japonês
        Locale('zh', 'CN'), // Mandarim
      ],
      home: HomeScreen(onLocaleChange: _setLocale),
    );
  }
}
