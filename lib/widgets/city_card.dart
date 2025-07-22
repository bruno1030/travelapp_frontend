// lib/widgets/city_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CityCard extends StatelessWidget {
  final String imageUrl;
  final String cityName;

  CityCard({required this.imageUrl, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Stack(
        children: [
          // A imagem da cidade como fundo
          Image.network(
            imageUrl,
            fit: BoxFit.cover,  // A imagem vai preencher o espaço do card
            height: 200,  // Definindo uma altura para a imagem
            width: double.infinity,  // Para a imagem ocupar toda a largura do card
          ),
          // O nome da cidade sobre a imagem
          Positioned(
            bottom: 10,  // Colocando o nome no fundo da imagem
            left: 10,
            right: 10,
            child: Container(
              color: Colors.black.withOpacity(0.5),  // Cor de fundo semi-transparente
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                cityName,
                style: TextStyle(
                  fontFamily: 'NotoSans',  // Usando a fonte customizada
                  color: Colors.white,  // Cor do texto
                  fontSize: 16,         // Tamanho da fonte
                  fontWeight: FontWeight.bold,  // Deixar o nome em negrito
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
