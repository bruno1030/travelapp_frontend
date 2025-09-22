import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/models/photo.dart';
import 'package:travelapp_frontend/config.dart';

class ApiService {
  static Future<List<City>> fetchCities() async {
    final response = await http.get(Uri.parse('$baseUrl/cities'));

    if (response.statusCode == 200) {
      var utf8DecodedBody = utf8.decode(response.bodyBytes);
      var data = jsonDecode(utf8DecodedBody);
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

  static Future<void> savePhoto({
    File? imageFile,
    Uint8List? imageBytes,
    required double latitude,
    required double longitude,
    required int userId,
  }) async {
    try {
      debugPrint('Iniciando savePhoto...');

      final signResponse = await http.post(
        Uri.parse('$baseUrl/cloudinary/signature'),
      );

      if (signResponse.statusCode != 200) {
        throw Exception('Erro ao obter assinatura do Cloudinary: ${signResponse.body}');
      }

      final signData = jsonDecode(signResponse.body);
      final String timestamp = signData['timestamp'].toString();
      final String signature = signData['signature'];
      final String api_key = signData['api_key'];

      const String cloudName = 'travelappprd';
      const String uploadFolder = 'travelapp';

      var uploadRequest = http.MultipartRequest(
        "POST",
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload"),
      );

      String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (kIsWeb && imageBytes != null) {
        uploadRequest.files.add(
          http.MultipartFile.fromBytes('file', imageBytes, filename: fileName),
        );
      } else if (imageFile != null) {
        uploadRequest.files.add(
          await http.MultipartFile.fromPath('file', imageFile.path, filename: fileName),
        );
      } else {
        throw Exception('Nenhuma imagem fornecida para upload.');
      }

      uploadRequest.fields['timestamp'] = timestamp;
      uploadRequest.fields['signature'] = signature;
      uploadRequest.fields['api_key'] = api_key;
      uploadRequest.fields['folder'] = uploadFolder;

      debugPrint('Fazendo upload para Cloudinary...');
      var uploadResponse = await uploadRequest.send();
      var uploadResult = await http.Response.fromStream(uploadResponse);

      if (uploadResponse.statusCode != 200) {
        throw Exception('Erro ao enviar para Cloudinary: ${uploadResult.body}');
      }

      final cloudData = jsonDecode(uploadResult.body);
      final String secureUrl = cloudData['secure_url'];

      debugPrint('Upload Cloudinary concluído: $secureUrl');

      final registerResponse = await http.post(
        Uri.parse('$baseUrl/photos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "image_url": secureUrl,
          "latitude": latitude,
          "longitude": longitude,
          "user_id": userId,
        }),
      );

      if (registerResponse.statusCode != 200) {
        throw Exception('Erro ao registrar foto no backend: ${registerResponse.body}');
      }

      debugPrint('Foto registrada no backend com sucesso!');
    } catch (e, st) {
      debugPrint('Erro em savePhoto: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  /// ----------------------------
  /// Novo método: atualizar usuário
  /// ----------------------------
  static Future<void> updateUserProfile({
    required String firebaseUid,
    String? username,
    String? name,
  }) async {
    final url = Uri.parse('$baseUrl/users/update');

    final body = <String, dynamic>{};
    if (username != null) body['username'] = username;
    if (name != null) body['name'] = name;

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'firebase-uid': firebaseUid, // 👈 envia UID no header
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário: ${response.body}');
    }
  }
}
