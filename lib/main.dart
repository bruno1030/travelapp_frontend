import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'generated/app_localizations.dart'; // Importando o arquivo gerado

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en', 'US'); // default language

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClickHunt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      locale: _locale, // Aplica a mudança de idioma
      localizationsDelegates: [
        AppLocalizations.delegate, // Adicionando a delegada correta
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
      home: HomeScreen(
        onLocaleChange: _setLocale, // Passando a função que altera o locale
        currentLocale: _locale, // Passando o currentLocale também
      ),
    );
  }
}
