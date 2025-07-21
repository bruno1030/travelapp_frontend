// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get hello => '你好';

  @override
  String get welcome => '欢迎使用ClickHunt!';

  @override
  String get about_us => '关于我们';

  @override
  String get language => '语言';

  @override
  String get search_city => '搜索城市...';
}
