import 'package:flutter/material.dart';
import 'package:travelapp_frontend/services/api_service.dart';
import 'package:travelapp_frontend/widgets/photo_card.dart';
import 'package:travelapp_frontend/models/photo.dart';
import 'package:travelapp_frontend/widgets/custom_app_bar.dart';
import 'package:travelapp_frontend/widgets/custom_bottom_bar.dart';
import 'package:travelapp_frontend/screens/photo_details_screen.dart';

class CityPhotosScreen extends StatefulWidget {
  final int cityId;
  final String cityName;
  final Function(Locale) onLocaleChange;
  final Locale currentLocale;

  const CityPhotosScreen({
    super.key,
    required this.cityId,
    required this.cityName,
    required this.onLocaleChange,
    required this.currentLocale,
  });

  @override
  _CityPhotosScreenState createState() => _CityPhotosScreenState();
}

class _CityPhotosScreenState extends State<CityPhotosScreen> {
  List<Photo> photos = [];

  Future<void> fetchPhotos() async {
    try {
      final data = await ApiService.fetchPhotosByCityId(widget.cityId);
      setState(() {
        photos = data;
      });
    } catch (e) {
      print('Erro ao carregar fotos: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.cityName, 
        onLocaleChange: widget.onLocaleChange, 
        currentLocale: widget.currentLocale,  // Passando o currentLocale para o CustomAppBar
      ),
      bottomNavigationBar: CustomBottomBar(
        onLocaleChange: widget.onLocaleChange, 
        currentLocale: widget.currentLocale,  // Passando o currentLocale para o CustomBottomBar
      ),
      body: Container(
        color: const Color(0xFF262626),
        child: photos.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.0,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoDetailScreen(
                            imageUrl: photo.imageUrl,
                            latitude: photo.latitude,
                            longitude: photo.longitude,
                            onLocaleChange: widget.onLocaleChange,
                          ),
                        ),
                      );
                    },
                    child: PhotoCard(imageUrl: photo.imageUrl),
                  );
                },
              ),
      ),
    );
  }
}
