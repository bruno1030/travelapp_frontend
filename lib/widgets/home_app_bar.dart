import 'package:flutter/material.dart';
import 'package:travelapp_frontend/widgets/menu_button.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Locale currentLocale;
  final Function(Locale) onLocaleChange;

  const HomeAppBar({
    super.key,
    required this.onLocaleChange,
    required this.currentLocale,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _HomeAppBarState extends State<HomeAppBar> {
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.currentLocale;
  }

  @override
  void didUpdateWidget(covariant HomeAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLocale != widget.currentLocale) {
      setState(() {
        _currentLocale = widget.currentLocale;
      });
    }
  }

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
          onLocaleChange: (locale) {
            widget.onLocaleChange(locale);
            setState(() {
              _currentLocale = locale;
            });
          },
          currentLocale: _currentLocale,
        ),
      ],
    );
  }
}
