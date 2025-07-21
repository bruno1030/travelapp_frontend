import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US'); // Idioma padrão

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}
