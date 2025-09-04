import 'package:flutter/material.dart';
import 'package:travelapp_frontend/services/api_service.dart';
import 'package:travelapp_frontend/widgets/city_card.dart';
import 'package:travelapp_frontend/widgets/home_app_bar.dart';
import 'package:travelapp_frontend/widgets/custom_bottom_bar.dart';
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/screens/city_search_screen.dart';
import 'package:travelapp_frontend/screens/city_photos_screen.dart';
import 'package:travelapp_frontend/generated/app_localizations.dart';
import 'package:travelapp_frontend/controllers/locale_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final localeController = Provider.of<LocaleController>(context);
    final currentLocale = localeController.locale;
    String searchCityText =
        AppLocalizations.of(context)?.search_city ?? 'Search a city...';

    // Calculando childAspectRatio baseado na largura da tela
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 2; // 2 cards por linha
    final spacing = 8 * (crossAxisCount + 1); // espaçamento total entre cards
    final cardWidth = (screenWidth - spacing) / crossAxisCount;
    // deixa os cards mais altos que largos
    final cardHeight = cardWidth * 1.4;
    final dynamicAspectRatio = cardWidth / cardHeight;

    return Scaffold(
      appBar: HomeAppBar(
        onLocaleChange: localeController.setLocale,
      ),
      body: Container(
        color: const Color(0xFF262626),
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
                        onLocaleChange: localeController.setLocale,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          searchCityText,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.search, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: cities.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: dynamicAspectRatio,
                      ),
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        final cityName = city
                                .translations[currentLocale.languageCode] ??
                            city.name;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CityPhotosScreen(
                                  city: city,
                                  onLocaleChange: localeController.setLocale,
                                ),
                              ),
                            );
                          },
                          child: CityCard(
                            imageUrl: city.coverPhotoUrl,
                            cityName: cityName,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
