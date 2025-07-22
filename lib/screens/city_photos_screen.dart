import 'package:flutter/material.dart';
import 'package:travelapp_frontend/services/api_service.dart';
import 'package:travelapp_frontend/widgets/photo_card.dart';
import 'package:travelapp_frontend/models/photo.dart';
import 'package:travelapp_frontend/widgets/custom_app_bar.dart';
import 'package:travelapp_frontend/widgets/custom_bottom_bar.dart';
import 'package:travelapp_frontend/screens/photo_details_screen.dart';
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/controllers/locale_controller.dart';
import 'package:provider/provider.dart'; // Para acessar o LocaleController

class CityPhotosScreen extends StatefulWidget {
  final City city;
  final Function(Locale) onLocaleChange;

  const CityPhotosScreen({
    super.key,
    required this.city,
    required this.onLocaleChange,
  });

  @override
  _CityPhotosScreenState createState() => _CityPhotosScreenState();
}

class _CityPhotosScreenState extends State<CityPhotosScreen> {
  List<Photo> photos = [];

  Future<void> fetchPhotos() async {
    try {
      final data = await ApiService.fetchPhotosByCityId(widget.city.id);  // Ajuste para usar city.id
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
    final locale = Provider.of<LocaleController>(context).locale;

    return Scaffold(
      appBar: CustomAppBar(
        city: widget.city,  // Passando o objeto city completo
        locale: locale,     // Passando o locale atual
        title: null,        // Passando null para usar o translatedName da cidade
      ),
      bottomNavigationBar: CustomBottomBar(),
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
