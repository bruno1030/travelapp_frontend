import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: Colors.white),
      onSelected: (value) {
        if (value == 'about') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('About us'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('ClickHunt v1.0'),
                  SizedBox(height: 8),
                  Text('Developed by Bruno Martins'),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('+351 911542459'),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'about',
          child: Text('About us'),
        ),
      ],
    );
  }
}
