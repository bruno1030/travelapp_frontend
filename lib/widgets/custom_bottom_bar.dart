import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF020202),
      child: SizedBox(
        height: 50, // Altura total da barra (reduzida)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomBarItem(
              icon: Icons.home,
              label: 'Home',
              onTap: () {},
            ),
            _BottomBarItem(
              icon: Icons.photo_camera,
              label: 'Send photo',
              onTap: () {},
            ),
            _BottomBarItem(
              icon: Icons.person,
              label: 'Profile',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Color(0xFFFE1F80),
            size: 30, // Ícone maior
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFFF9FAFB),
              fontSize: 15.0, // Texto maior
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
