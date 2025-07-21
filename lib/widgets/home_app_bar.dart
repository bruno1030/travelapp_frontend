import 'package:flutter/material.dart';
import 'package:travelapp_frontend/widgets/menu_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(Locale) onLocaleChange;
  final Locale currentLocale; // Adicionando o parâmetro currentLocale

  const HomeAppBar({
    super.key,
    required this.onLocaleChange,
    required this.currentLocale, // Passando currentLocale no construtor
  });

  @override
  Widget build(BuildContext context) {
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
            'ClickHunt',
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
          onLocaleChange: onLocaleChange,
          currentLocale: currentLocale, // Passando currentLocale para MenuButton
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
