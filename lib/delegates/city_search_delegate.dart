import 'package:flutter/material.dart';
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/screens/city_photos_screen.dart';  // Import necessário para a navegação

class CitySearchDelegate extends SearchDelegate<City?> {
  final List<City> cities;

  CitySearchDelegate(this.cities);

  @override
  String? get searchFieldLabel => 'Search a city...';

  @override
  TextStyle? get searchFieldStyle => TextStyle(color: Colors.white);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF020202),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final queryLower = query.toLowerCase();

    final suggestions = cities.where((city) {
      return city.name.toLowerCase().startsWith(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final city = suggestions[index];
        return ListTile(
          title: Text(city.name),
          onTap: () {
            close(context, city); // Fecha a pesquisa e retorna a cidade selecionada

            // Navega para a tela de fotos da cidade, substituindo a tela de pesquisa
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CityPhotosScreen(
                  cityId: city.id,
                  cityName: city.name,  // Passando o nome da cidade
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Mesmo que buildSuggestions
    return buildSuggestions(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }
}
