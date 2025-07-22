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

  @override
  String get language_name => '中文';

  @override
  String get clickhunt_version => 'ClickHunt 版本1.0';

  @override
  String get developed_by => '由 Bruno Martins 开发';

  @override
  String get close => '关闭';

  @override
  String get take_me_there => '带我去那里！';

  @override
  String get explore_cities => '探索城市';
}
