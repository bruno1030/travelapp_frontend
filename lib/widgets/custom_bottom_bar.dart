import 'package:flutter/material.dart';
import 'package:travelapp_frontend/screens/home_screen.dart';
import 'package:travelapp_frontend/controllers/locale_controller.dart';
import 'package:provider/provider.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Pegando o idioma diretamente do LocaleController
    final localeController = Provider.of<LocaleController>(context);

    return BottomAppBar(
      color: const Color(0xFF020202),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomBarItem(
              icon: Icons.home,
              label: 'Home', // Aqui você pode adicionar lógica para mudar o label baseado no currentLocale
              onTap: () {
                // Agora não é mais necessário passar o idioma manualmente
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false, // Remove todas as rotas anteriores
                );
              },
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
            color: const Color(0xFFFE1F80),
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFF9FAFB),
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
