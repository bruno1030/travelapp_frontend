import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoDetailScreen extends StatelessWidget {
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String cityName;

  const PhotoDetailScreen({
    super.key,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.cityName
  });

  void _launchMaps() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262626),
      appBar: AppBar(
        backgroundColor: Color(0xFF020202),
        title: Text(
          cityName,
          style: TextStyle(
            color: Color(0xFFFE1F80),
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.network(imageUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFE1F80),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _launchMaps,
              child: Text(
                'Take me there!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
