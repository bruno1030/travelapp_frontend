import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MenuButton extends StatelessWidget {
  final Function(Locale) onLocaleChange; // Recebendo a função para mudar o idioma

  const MenuButton({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: Colors.white),
      onSelected: (value) {
        if (value == 'about') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('About us'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('ClickHunt v1.0'),
                  SizedBox(height: 8),
                  Text('Developed by Bruno Martins'),
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
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
        // Aqui, você pode adicionar lógica para mudar o idioma
        if (value == 'change_language') {
          _showLanguageDialog(context);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'language',
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/flags/${_getFlagForLocale(Locale('pt', 'BR'))}'),
              ),
              const SizedBox(width: 8),
              Text(_getLanguageNameForLocale(Locale('pt', 'BR'))),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'about',
          child: Text('About us'),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _languageOption(context, Locale('pt', 'BR'), 'Portuguese'),
            _languageOption(context, Locale('en', 'US'), 'English'),
            _languageOption(context, Locale('ja', 'JP'), 'Japanese'),
            _languageOption(context, Locale('zh', 'CN'), 'Mandarin'),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(BuildContext context, Locale locale, String language) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/flags/${_getFlagForLocale(locale)}'),
      ),
      title: Text(language),
      onTap: () {
        onLocaleChange(locale);
        Navigator.pop(context);
      },
    );
  }

  String _getFlagForLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'us.png'; // Caminho da bandeira dos EUA
      case 'pt':
        return 'br.png'; // Caminho da bandeira do Brasil
      case 'ja':
        return 'jp.png'; // Caminho da bandeira do Japão
      case 'zh':
        return 'cn.png'; // Caminho da bandeira da China
      default:
        return 'us.png';
    }
  }

  String _getLanguageNameForLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'pt':
        return 'Portuguese';
      case 'ja':
        return 'Japanese';
      case 'zh':
        return 'Mandarin';
      default:
        return 'English';
    }
  }
}
