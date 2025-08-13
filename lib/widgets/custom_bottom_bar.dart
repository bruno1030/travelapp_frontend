import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:travelapp_frontend/controllers/locale_controller.dart';
import 'package:travelapp_frontend/screens/home_screen.dart';
import 'package:travelapp_frontend/services/api_service.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Provider.of<LocaleController>(context);

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
                  MaterialPageRoute(builder: (context) => HomeScreen()),
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
          ],
        ),
      ),
    );
  }

  Future<void> _handleUploadPhoto(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

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

    final ImagePicker picker = ImagePicker();
    XFile? imageFile;

    bool takeAnother = true;

    while (takeAnother) {
      imageFile = await picker.pickImage(source: ImageSource.camera);

      if (imageFile == null) return;

      Widget imageWidget;

      if (kIsWeb) {
        Uint8List imageBytes = await imageFile.readAsBytes();
        imageWidget = Image.memory(imageBytes);
      } else {
        imageWidget = Image.file(File(imageFile.path));
      }

      takeAnother = !(await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Photo'),
              content: imageWidget,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Retake Photo'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ) ??
          false);
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Photo captured at Lat: ${position.latitude}, Lon: ${position.longitude}'),
      ),
    );

    // Chamar o método para salvar no backend
    if (imageFile != null) {
      if (kIsWeb) {
        // No Web, apenas debug da foto + localização
        debugPrint('Web: savePhoto chamado! Lat: ${position.latitude}, Lon: ${position.longitude}');
      } else {
        await ApiService.savePhoto(
          imageFile: File(imageFile.path),
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
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
