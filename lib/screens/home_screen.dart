import 'package:flutter/material.dart';
import 'package:travelapp_frontend/services/api_service.dart';
import 'package:travelapp_frontend/widgets/city_card.dart';
import 'package:travelapp_frontend/widgets/home_app_bar.dart';
import 'package:travelapp_frontend/widgets/custom_bottom_bar.dart';
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/screens/city_search_screen.dart'; // Importando a nova tela de pesquisa
import 'package:travelapp_frontend/screens/city_photos_screen.dart'; // Importando CityPhotosScreen
import 'package:flutter_localizations/flutter_localizations.dart'; // Adicionando suporte a localizações
import 'package:travelapp_frontend/generated/app_localizations.dart'; // Adicionando o arquivo de localizações

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange; // Novo parâmetro
  final Locale currentLocale; // Recebendo o currentLocale

  const HomeScreen({super.key, required this.onLocaleChange, required this.currentLocale});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<City> cities = [];

  Future<void> fetchCities() async {
    try {
      final data = await ApiService.fetchCities();
      setState(() {
        cities = data;
      });
    } catch (e) {
      print('Erro ao carregar cidades: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  // Função que será chamada ao mudar o idioma
  void _changeLocale(Locale locale) {
    widget.onLocaleChange(locale); // Alterando a linguagem através da função passada
  }

  @override
  Widget build(BuildContext context) {
    // Pegando o texto traduzido para "Search a city"
    String searchCityText = AppLocalizations.of(context)?.search_city ?? 'Search a city..';

    return Scaffold(
      appBar: HomeAppBar(
        onLocaleChange: _changeLocale, // Passando a função que altera o locale
        currentLocale: widget.currentLocale, // Passando o currentLocale para o AppBar
      ),
      body: Container(
        color: Color(0xFF262626),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CitySearchScreen(
                        cities: cities,
                        onLocaleChange: widget.onLocaleChange,  // Passando a função onLocaleChange
                        currentLocale: widget.currentLocale, // Passando o currentLocale
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          searchCityText,  // Usando o texto traduzido
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(Icons.search, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: cities.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CityPhotosScreen(
                                  cityId: city.id, 
                                  cityName: city.name,
                                  onLocaleChange: widget.onLocaleChange,  // Passando a função onLocaleChange
                                  currentLocale: widget.currentLocale, // Passando o currentLocale
                                ),
                              ),
                            );
                          },
                          child: CityCard(
                            imageUrl: city.coverPhotoUrl,
                            cityName: city.name,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        onLocaleChange: widget.onLocaleChange,
        currentLocale: widget.currentLocale, // Passando currentLocale para o CustomBottomBar
      ),
    );
  }
}
