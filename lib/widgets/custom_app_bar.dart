import 'package:flutter/material.dart';
import 'package:travelapp_frontend/widgets/menu_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Function(Locale) onLocaleChange; // Adicionando o parâmetro onLocaleChange

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    required this.onLocaleChange, // Passando o parâmetro no construtor
  });

  @override
  Widget build(BuildContext context) {
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
      title: Builder(
        builder: (context) {
          final leadingWidth = leading != null ? 50.0 : 0.0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) SizedBox(width: leadingWidth),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFFE1F80),
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        MenuButton(onLocaleChange: onLocaleChange), // Passando o onLocaleChange para o MenuButton
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
