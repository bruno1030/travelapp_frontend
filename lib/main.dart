import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'generated/app_localizations.dart';
import 'controllers/locale_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Aqui, acessamos o LocaleController diretamente no build
    final localeController = Provider.of<LocaleController>(context);

    return MaterialApp(
      title: 'Clixpot',
      theme: ThemeData(primarySwatch: Colors.blue),
      locale: localeController.locale,  // Usando o idioma globalmente
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
      home: HomeScreen(
        // Agora não precisamos mais passar currentLocale ou onLocaleChange
        // A mudança de idioma é tratada pelo LocaleController diretamente
      ),
    );
  }
}
