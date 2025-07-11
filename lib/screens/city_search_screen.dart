import 'package:flutter/material.dart';
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/screens/city_photos_screen.dart';
import 'package:travelapp_frontend/widgets/custom_app_bar.dart';

class CitySearchScreen extends StatefulWidget {
  final List<City> cities;

  CitySearchScreen(this.cities);

  @override
  _CitySearchScreenState createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  late List<City> suggestions;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    suggestions = [];
    _filterCities(''); // Mostra todas as cidades inicialmente
  }

  void _filterCities(String query) {
    final queryLower = query.toLowerCase();
    setState(() {
      if (queryLower.isEmpty) {
        suggestions = widget.cities;
      } else {
        suggestions = widget.cities.where((city) {
          return city.name.toLowerCase().startsWith(queryLower);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: Container(
        color: Color(0xFF262626), // 🔥 BACKGROUND ESCURO ADICIONADO
        child: Column(
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                    title: Text(
                      city.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityPhotosScreen(
                            cityId: city.id,
                            cityName: city.name,
                          ),
                        ),
                      );
                      _filterCities(_controller.text);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
