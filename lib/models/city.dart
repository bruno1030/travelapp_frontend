class City {
  final String name;
  final String coverPhotoUrl;

  City({required this.name, required this.coverPhotoUrl});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      coverPhotoUrl: json['cover_photo_url'],
    );
  }
}