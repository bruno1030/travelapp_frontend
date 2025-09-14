import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travelapp_frontend/controllers/locale_controller.dart';
import 'package:travelapp_frontend/controllers/auth_controller.dart';
import 'package:travelapp_frontend/screens/home_screen.dart';
import 'package:travelapp_frontend/screens/profile_screen.dart';
import 'package:travelapp_frontend/services/api_service.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Provider.of<LocaleController>(context);
    final auth = Provider.of<AuthController>(context);

    return BottomAppBar(
      color: const Color(0xFF020202),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomBarItem(
              icon: Icons.home,
              label: 'Home',
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
                );
              },
            ),
            _BottomBarItem(
              icon: Icons.upload_file,
              label: 'Upload Photo',
              onTap: () async {
                await _handleUploadPhoto(context);
              },
            ),
            _BottomBarItem(
              icon: Icons.person,
              label: 'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUploadPhoto(BuildContext context) async {
    // Verifica se o serviço de localização está habilitado
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Solicita permissões de localização
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission permanently denied.')),
      );
      return;
    }

    // Abre a câmera para tirar a foto
    final ImagePicker picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(source: ImageSource.camera);

    if (imageFile == null) return; // Usuário cancelou a câmera

    // Pega a posição atual
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Photo captured at Lat: ${position.latitude}, Lon: ${position.longitude}'),
      ),
    );

    // Faz upload da foto para o backend
    try {
      if (kIsWeb) {
        Uint8List imageBytes = await imageFile.readAsBytes();
        String fakeFileName =
            'web_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
        File fakeFile = File(fakeFileName); // Apenas estrutura, não precisa existir de fato
        await ApiService.savePhoto(
          imageFile: fakeFile,
          imageBytes: imageBytes,
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } else {
        File file = File(imageFile.path);
        await ApiService.savePhoto(
          imageFile: file,
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } catch (e) {
      debugPrint('Erro ao salvar foto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar foto: $e')),
      );
    }
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
