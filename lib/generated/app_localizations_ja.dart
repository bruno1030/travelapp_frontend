// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get hello => 'こんにちは';

  @override
  String get welcome => 'ClickHuntへようこそ!';

  @override
  String get about_us => '私たちについて';

  @override
  String get language => '言語';

  @override
  String get search_city => '都市を検索...';

  @override
  String get language_name => '日本語';
}
