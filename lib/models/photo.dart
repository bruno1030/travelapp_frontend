class Photo {
  final int id;
  final String imageUrl;
  final double latitude;
  final double longitude;

  Photo({
    required this.id,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  // Método para mapear os dados da API (transformar o JSON recebido em um objeto Dart)
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      imageUrl: json['image_url'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // Método para converter o objeto Dart em um Map (caso precise enviar para a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
