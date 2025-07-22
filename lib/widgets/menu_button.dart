import 'package:flutter/material.dart';
import 'package:travelapp_frontend/generated/app_localizations.dart';

class MenuButton extends StatelessWidget {
  final Function(Locale) onLocaleChange;
  final Locale currentLocale;

  const MenuButton({
    super.key,
    required this.onLocaleChange,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final aboutUs = AppLocalizations.of(context)?.about_us ?? 'About us';
    final languageLabel = _getLanguageNativeName(currentLocale);
    final flagPath = _getFlagForLocale(currentLocale);

    final clickHuntVersion = AppLocalizations.of(context)?.clickhunt_version ?? 'ClickHunt v1.0';
    final developedBy = AppLocalizations.of(context)?.developed_by ?? 'Developed by Bruno Martins';
    final close = AppLocalizations.of(context)?.close ?? 'Close';

    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: Colors.white),
      onSelected: (value) {
        if (value == 'about') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(aboutUs),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(clickHuntVersion),
                  SizedBox(height: 8),
                  Text(developedBy),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('+351 911542459'),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(close),
                ),
              ],
            ),
          );
        }

        if (value == 'change_language') {
          _showLanguageDialog(context);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'change_language',
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/flags/$flagPath'),
              ),
              const SizedBox(width: 8),
              Text(languageLabel),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'about',
          child: Text(aboutUs),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)?.language ?? 'Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption(context, const Locale('pt', 'BR')),
            _languageOption(context, const Locale('en', 'US')),
            _languageOption(context, const Locale('ja', 'JP')),
            _languageOption(context, const Locale('zh', 'CN')),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(BuildContext context, Locale locale) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/flags/${_getFlagForLocale(locale)}'),
      ),
      title: Text(_getLanguageNativeName(locale)),
      onTap: () {
        Navigator.of(context).pop(); // Fecha o dialogo
        onLocaleChange(locale); // Troca o idioma
      },
    );
  }

  String _getFlagForLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'us_uk.jpeg';
      case 'pt':
        return 'br_pt.png';
      case 'ja':
        return 'japan.png';
      case 'zh':
        return 'china.jpeg';
      default:
        return 'us_uk.jpeg';
    }
  }

  String _getLanguageNativeName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'pt':
        return 'Português';
      case 'ja':
        return '日本語';
      case 'zh':
        return '中文';
      default:
        return 'English';
    }
  }
}
