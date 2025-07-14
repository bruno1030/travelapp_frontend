import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF020202),
      toolbarHeight: 80, // custom height
      automaticallyImplyLeading: false, // Remove the standard back button
      title: Row(
        children: [
          Image.asset(
            'logo_FE1F80.png',
            height: 50,
            width: 50,
          ),
          SizedBox(width: 8),
          Text(
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
        IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // TODO: action to be implemented for the menu
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
