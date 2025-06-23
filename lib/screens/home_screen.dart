import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:travelapp_frontend/services/api_service.dart';  // Importa o serviço que faz a chamada à API
import 'package:travelapp_frontend/widgets/city_card.dart';     // Importa o CityCard
import 'package:travelapp_frontend/models/city.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista de cidades que será preenchida com a resposta da API
  List<City> cities = [];

  // Função para fazer a requisição à API
  Future<void> fetchCities() async {
    try {
      print('calling service');
      final data = await ApiService.fetchCities();  // Chama o serviço para pegar as cidades da API
      setState(() {
        cities = data;
      });
    } catch (e) {
      // Em caso de erro, você pode tratar isso aqui (ex: exibir uma mensagem de erro)
      print('Erro ao carregar cidades: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCities(); // Carregar as cidades assim que a tela for carregada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cidades para Visitar'),
        backgroundColor: Colors.blueAccent,
      ),
      body: cities.isEmpty
          ? Center(child: CircularProgressIndicator())  // Carregando
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,  // 3 cards por linha
                crossAxisSpacing: 8,  // Espaçamento horizontal entre os cards
                mainAxisSpacing: 8,   // Espaçamento vertical entre os cards
                childAspectRatio: 1.0, // Faz cada card ser quadrado
              ),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                return CityCard(
                  imageUrl: city.coverPhotoUrl,  // URL da imagem
                  cityName: city.name,             // Nome da cidade
                );
              },
            ),
    );
  }
}
