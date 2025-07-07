class City {
  final int id;
  final String name;
  final String country;
  final String coverPhotoUrl;

  City({
    required this.id, 
    required this.name, 
    required this.country, 
    required this.coverPhotoUrl
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      country: json['country'],
      name: json['name'],
      coverPhotoUrl: json['cover_photo_url'],
    );
  }
}