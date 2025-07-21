import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController with ChangeNotifier {
  Locale _locale = Locale('en', 'US'); // Padrão: Inglês (EUA)

  Locale get locale => _locale;

  // Função para buscar o idioma salvo
  Future<void> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLocale = prefs.getString('locale_key');
    if (savedLocale != null) {
      _locale = Locale(savedLocale); // Recupera o idioma salvo
    } else {
      _locale = Locale('en', 'US'); // Padrão para inglês
    }
    notifyListeners(); // Notifica todos os ouvintes da mudança.
  }

  // Função para salvar o idioma escolhido
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    // Salve o idioma no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale_key', locale.languageCode);
    notifyListeners(); // Notifica todos os ouvintes da mudança.
  }
}
