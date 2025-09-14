import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travelapp_frontend/generated/app_localizations.dart';

class PhotoDetailScreen extends StatelessWidget {
  final String imageUrl;
  final double latitude;
  final double longitude;
  final Function(Locale) onLocaleChange;

  const PhotoDetailScreen({
    super.key,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.onLocaleChange,
  });

  void _launchMaps(BuildContext context) async {
    try {
      if (latitude.isNaN || longitude.isNaN) {
        _showErrorDialog(context, 'Coordenadas inválidas');
        return;
      }

      final urlsToTry = [
        'https://maps.google.com/?q=$latitude,$longitude',
        'geo:$latitude,$longitude?q=$latitude,$longitude',
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
        'google.navigation:q=$latitude,$longitude',
      ];

      for (final urlString in urlsToTry) {
        final uri = Uri.parse(urlString);
        final canLaunch = await canLaunchUrl(uri);

        if (canLaunch) {
          final launchResult = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (launchResult) return;
        }
      }

      _showErrorDialog(
        context,
        'Não foi possível abrir o mapa. Verifique se você tem um aplicativo de mapas instalado.',
      );
    } catch (e) {
      _showErrorDialog(context, 'Erro ao tentar abrir o mapa');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final takeMeThere =
        AppLocalizations.of(context)?.take_me_there ?? 'Take me there!';

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea( // 👈 garante que o botão não será coberto
              minimum: const EdgeInsets.only(bottom: 16),
              child: Container(
                color: Colors.black.withOpacity(0.6),
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE1F80),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _launchMaps(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_pin, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        takeMeThere,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
