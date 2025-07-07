import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/models/photo.dart'; // Importando a classe Photo

class ApiService {
  // Função para fazer a requisição à API e buscar as cidades
  static Future<List<City>> fetchCities() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/cities'));

    if (response.statusCode == 200) {
      // Se a resposta for bem-sucedida, decodifica os dados JSON
      var data = jsonDecode(response.body);
      List<City> cities = (data as List).map((city) => City.fromJson(city)).toList();
      return cities;
    } else {
      throw Exception('Falha ao carregar cidades');
    }
  }

  // Novo método para buscar as fotos pela ID da cidade
  static Future<List<Photo>> fetchPhotosByCityId(int cityId) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/photos/by_city/$cityId'));

    if (response.statusCode == 200) {
      // Se a resposta for bem-sucedida, decodifica os dados JSON
      var data = jsonDecode(response.body);
      List<Photo> photos = (data as List).map((photo) => Photo.fromJson(photo)).toList();
      return photos;
    } else {
      throw Exception('Falha ao carregar fotos');
    }
  }
}
