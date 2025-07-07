import 'package:flutter/material.dart';
import 'package:travelapp_frontend/services/api_service.dart'; 
import 'package:travelapp_frontend/widgets/photo_card.dart'; 
import 'package:travelapp_frontend/models/photo.dart'; 
import 'package:travelapp_frontend/widgets/custom_app_bar.dart'; // Importando CustomAppBar
import 'package:travelapp_frontend/widgets/custom_bottom_bar.dart'; // Importando CustomBottomBar

class CityPhotosScreen extends StatefulWidget {
  final int cityId;
  final String cityName; // Adicionando o nome da cidade

  CityPhotosScreen({required this.cityId, required this.cityName}); // Recebendo o nome da cidade

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
      appBar: CustomAppBar(title: 'City Photos'), // Usando CustomAppBar
      bottomNavigationBar: CustomBottomBar(), // Usando CustomBottomBar
      body: Container(
        color: Color(0xFF262626), // Definindo a cor de fundo igual à HomeScreen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.cityName, // Exibindo o nome da cidade
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: photos.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        final photo = photos[index];
                        return PhotoCard(
                          imageUrl: photo.imageUrl,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
