import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  static const double appBarCustomHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF020202),
      elevation: 4,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo e título
          Row(
            children: [
              Image.asset(
                'logo_FE1F80.png', // Certifique-se de que o arquivo está na pasta assets
                height: 55,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFFFE1F80),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Ícone de menu (três riscos)
          IconButton(
            icon: Icon(Icons.menu),  // Ícone de menu (três riscos)
            iconSize: 45,
            color: Colors.white,  // Cor branca para o ícone de opções
            onPressed: () {
              // Abre um Drawer, modal ou qualquer ação
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      toolbarHeight: appBarCustomHeight,  // Defines the custom height
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarCustomHeight);  // returns the custom height
}
