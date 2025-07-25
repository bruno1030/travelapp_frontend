import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/models/photo.dart';
import 'package:travelapp_frontend/config.dart'; 

class ApiService {
  static Future<List<City>> fetchCities() async {
    final response = await http.get(Uri.parse('$baseUrl/cities'));

    if (response.statusCode == 200) {
      // Garantindo que a resposta seja decodificada corretamente em UTF-8
      var utf8DecodedBody = utf8.decode(response.bodyBytes);  // Use bodyBytes para garantir a integridade
      var data = jsonDecode(utf8DecodedBody);  // Agora decodifica o JSON da resposta
      return (data as List).map((city) => City.fromJson(city)).toList();
    } else {
      throw Exception('Falha ao carregar cidades');
    }
  }

  static Future<List<Photo>> fetchPhotosByCityId(int cityId) async {
    final response = await http.get(Uri.parse('$baseUrl/photos/by_city/$cityId'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return (data as List).map((photo) => Photo.fromJson(photo)).toList();
    } else {
      throw Exception('Falha ao carregar fotos');
    }
  }
}
