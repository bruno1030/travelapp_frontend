// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get welcome => 'Welcome to TravelApp!';

  @override
  String get about_us => 'About us';

  @override
  String get language => 'Language';

  @override
  String get search_city => 'Search a city...';

  @override
  String get language_name => 'English';
}
