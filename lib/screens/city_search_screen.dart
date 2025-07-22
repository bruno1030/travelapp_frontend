import 'package:flutter/material.dart';
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/screens/city_photos_screen.dart';
import 'package:travelapp_frontend/widgets/custom_app_bar.dart';
import 'package:travelapp_frontend/generated/app_localizations.dart';
import 'package:travelapp_frontend/controllers/locale_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:travelapp_frontend/generated/app_localizations.dart';

class CitySearchScreen extends StatefulWidget {
  final List<City> cities;
  final Function(Locale) onLocaleChange;

  CitySearchScreen({
    super.key,
    required this.cities,
    required this.onLocaleChange,
  });

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
    _filterCities('');
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
    final localeController = Provider.of<LocaleController>(context); // Acessando o controlador de idioma
    final currentLocale = localeController.locale;  // Pegando o idioma atual
    final exploreCities = AppLocalizations.of(context)?.explore_cities ?? 'Explore Cities';
    String searchCityText = AppLocalizations.of(context)?.search_city ?? 'Search a city...';

    return Scaffold(
      appBar: CustomAppBar(
        city: null,  // Passando null para city, já que não há cidade associada à tela de busca
        locale: currentLocale, // Passando o locale atual
        title: exploreCities, // Passando "Search Cities" como título
      ),
      body: Container(
        color: const Color(0xFF262626),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controller,
                onChanged: _filterCities,
                decoration: InputDecoration(
                  hintText: searchCityText,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final city = suggestions[index];
                  // Pegando o nome traduzido ou o nome padrão caso não exista tradução
                  final cityName = city.translations[currentLocale.languageCode] ?? city.name;

                  return ListTile(
                    title: Text(
                      cityName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityPhotosScreen(
                            city: city,  // Passando o objeto City completo
                            onLocaleChange: widget.onLocaleChange,
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
