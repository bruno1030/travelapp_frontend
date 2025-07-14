import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF020202),
      toolbarHeight: 80, // Altura customizada igual à HomeAppBar
      leading: leading != null
          ? IconTheme(
              data: const IconThemeData(color: Color(0xFFFFFFFF)), // Cor do ícone do back button
              child: leading!,
            )
          : IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFFFFFFFF), // Garante que o ícone de voltar será branco
              ),
              onPressed: () {
                Navigator.pop(context); // Volta para a tela anterior
              },
            ),
      title: Builder(
        builder: (context) {
          final width = MediaQuery.of(context).size.width;
          final leadingWidth = leading != null ? 50.0 : 0.0; // Ajusta a largura do leading (botão de voltar)

          return Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza horizontalmente
            children: [
              // Se houver um leading (botão de voltar), ajustamos o tamanho
              if (leading != null)
                SizedBox(width: leadingWidth), // Ajusta o espaço para o botão de back
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFFE1F80),
                  fontSize: 30,
                  fontWeight: FontWeight.w200
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white, // Cor do ícone do menu
          ),
          onPressed: () {
            // Lógica do menu (ainda não implementada)
            print("Menu clicked");
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
