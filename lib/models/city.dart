class City {
  final int id;
  final String name;
  final String country;
  final String coverPhotoUrl;
  final Map<String, String> translations;

  City({
    required this.id,
    required this.name,
    required this.country,
    required this.coverPhotoUrl,
    required this.translations,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    // Convertendo lista de objetos de tradução em Map<String, String>
    Map<String, String> parsedTranslations = {};
    if (json['translations'] != null) {
      for (var item in json['translations']) {
        parsedTranslations[item['language']] = item['translated_name'];
      }
    }

    return City(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      coverPhotoUrl: json['cover_photo_url'],
      translations: parsedTranslations,
    );
  }
}
