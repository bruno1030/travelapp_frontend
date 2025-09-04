// lib/widgets/city_card.dart
import 'package:flutter/material.dart';

class CityCard extends StatelessWidget {
  final String imageUrl;
  final String cityName;

  const CityCard({
    Key? key,
    required this.imageUrl,
    required this.cityName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.transparent, // remove fundo branco
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge, // imagem respeita o borderRadius
      child: Stack(
        children: [
          // Imagem da cidade
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Nome da cidade dentro de uma caixinha
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.6), // cinza claro translúcido
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                cityName,
                style: const TextStyle(
                  fontFamily: 'NotoSans',
                  color: Colors.white,
                  fontSize: 16, // fonte maior
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black45,
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
