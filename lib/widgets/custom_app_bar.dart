import 'package:flutter/material.dart';
import 'package:travelapp_frontend/widgets/menu_button.dart';
import 'package:provider/provider.dart'; // Para usar o LocaleController
import 'package:travelapp_frontend/controllers/locale_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    // Pegando o LocaleController para acessar o idioma global
    final localeController = Provider.of<LocaleController>(context);

    return AppBar(
      backgroundColor: const Color(0xFF020202),
      toolbarHeight: 80,
      leading: leading != null
          ? IconTheme(
              data: const IconThemeData(color: Colors.white),
              child: leading!,
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) const SizedBox(width: 50),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFE1F80),
              fontSize: 30,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
      actions: [
        MenuButton(
          onLocaleChange: (locale) {
            // Alterando o idioma global através do LocaleController
            localeController.setLocale(locale);
          },
          currentLocale: localeController.locale, // Pegando o idioma atual diretamente do LocaleController
        ),
      ],
    );
  }
}
