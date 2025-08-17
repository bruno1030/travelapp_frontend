import 'package:flutter/material.dart';
import 'package:travelapp_frontend/widgets/menu_button.dart';
import 'package:provider/provider.dart';
import 'package:travelapp_frontend/controllers/locale_controller.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(Locale) onLocaleChange;

  const HomeAppBar({
    super.key,
    required this.onLocaleChange,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final localeController = Provider.of<LocaleController>(context);

    return AppBar(
      backgroundColor: const Color(0xFF020202),
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Image.asset(
            'assets/logo_FE1F80.png',
            height: 50,
            width: 50,
          ),
          const SizedBox(width: 8),
          const Text(
            'Clixpot',
            style: TextStyle(
              color: Color(0xFFFE1F80),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        MenuButton(
          onLocaleChange: (locale) {
            localeController.setLocale(locale); // Usando o LocaleController para mudar o idioma
            onLocaleChange(locale); // Notificando a mudança através do callback, se necessário
          },
          currentLocale: localeController.locale, // Pegando o locale atual do LocaleController
        ),
      ],
    );
  }
}
