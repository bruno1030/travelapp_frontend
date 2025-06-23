// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travelapp_frontend/models/city.dart';

class ApiService {
  // Função para fazer a requisição à API
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
}
