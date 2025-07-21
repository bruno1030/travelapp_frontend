import 'package:flutter/material.dart';
import 'package:travelapp_frontend/screens/home_screen.dart'; // Certifique-se de importar corretamente sua Home
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final Function(Locale) onLocaleChange; // Função para mudar o idioma
  final Locale currentLocale; // Novo parâmetro para o idioma atual

  const CustomBottomBar({
    super.key, 
    required this.onLocaleChange,
    required this.currentLocale, // Passando o currentLocale
  });

  @override
  Widget build(BuildContext context) {
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(
                    onLocaleChange: onLocaleChange, 
                    currentLocale: currentLocale, // Passando o currentLocale para a Home
                  )),
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
