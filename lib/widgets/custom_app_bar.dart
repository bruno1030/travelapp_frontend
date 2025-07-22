import 'package:flutter/material.dart';
import 'package:travelapp_frontend/widgets/menu_button.dart';
import 'package:provider/provider.dart'; // Para usar o LocaleController
import 'package:travelapp_frontend/controllers/locale_controller.dart';
import 'package:travelapp_frontend/models/city.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final City? city;
  final Locale locale;
  final Widget? leading;
  final String? title;  // Aqui, title deve ser do tipo String? (String ou null)

  const CustomAppBar({
    super.key,
    required this.city,
    required this.locale,
    this.leading,
    this.title,  // Certificando-se de que title é opcional
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    // Obtendo o nome traduzido da cidade
    final translatedName = city?.translations[locale.languageCode] ?? city?.name ?? 'Unknown City';

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
            title ?? translatedName,  // Se title for null, usa translatedName
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
          onLocaleChange: (newLocale) {
            // Alterando o idioma global através do LocaleController
            Provider.of<LocaleController>(context, listen: false).setLocale(newLocale);
          },
          currentLocale: locale,
        ),
      ],
    );
  }
}
