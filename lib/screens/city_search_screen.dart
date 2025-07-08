import 'package:flutter/material.dart';
import 'package:travelapp_frontend/models/city.dart';  // Importando o modelo de City
import 'package:travelapp_frontend/screens/city_photos_screen.dart';  // Importando a tela CityPhotosScreen
import 'package:travelapp_frontend/widgets/custom_app_bar.dart';  // Importando o CustomAppBar

class CitySearchScreen extends StatefulWidget {
  final List<City> cities;

  CitySearchScreen(this.cities);

  @override
  _CitySearchScreenState createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  List<City> suggestions = [];
  TextEditingController _controller = TextEditingController();

  void _filterCities(String query) {
    final queryLower = query.toLowerCase();
    setState(() {
      suggestions = widget.cities.where((city) {
        return city.name.toLowerCase().startsWith(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Search Cities'),  // Usando o CustomAppBar
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              onChanged: _filterCities,
              decoration: InputDecoration(
                hintText: 'Search for a city...',
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.search),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final city = suggestions[index];
                return ListTile(
                  title: Text(city.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityPhotosScreen(
                          cityId: city.id,
                          cityName: city.name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
