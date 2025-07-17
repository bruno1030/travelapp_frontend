import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoDetailScreen extends StatelessWidget {
  final String imageUrl;
  final double latitude;
  final double longitude;

  const PhotoDetailScreen({
    super.key,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  void _launchMaps() async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // fundo neutro pra destacar a foto
      body: Stack(
        children: [
          // A imagem ocupando toda a tela
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // Botão de voltar no canto superior esquerdo
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

          // Botão "Take me there!" fixo na parte inferior
          Align(
            alignment: Alignment.bottomCenter,
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
                onPressed: _launchMaps,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_pin, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Take me there!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
