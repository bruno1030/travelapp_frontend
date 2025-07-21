import 'package:flutter/material.dart';
import 'package:travelapp_frontend/widgets/menu_button.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Function(Locale) onLocaleChange;
  final Locale currentLocale;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    required this.onLocaleChange,
    required this.currentLocale,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late Locale _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.currentLocale;
  }

  @override
  void didUpdateWidget(covariant CustomAppBar oldWidget) {
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
      leading: widget.leading != null
          ? IconTheme(
              data: const IconThemeData(color: Colors.white),
              child: widget.leading!,
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.leading != null) const SizedBox(width: 50),
          Text(
            widget.title,
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
