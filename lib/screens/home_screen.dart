import 'package:flutter/material.dart';
import 'package:travelapp_frontend/services/api_service.dart';
import 'package:travelapp_frontend/widgets/city_card.dart';
import 'package:travelapp_frontend/widgets/home_app_bar.dart';
import 'package:travelapp_frontend/widgets/custom_bottom_bar.dart';
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/screens/city_search_screen.dart'; // Importando a nova tela de pesquisa
import 'package:travelapp_frontend/screens/city_photos_screen.dart'; // Importando CityPhotosScreen
import 'package:travelapp_frontend/generated/app_localizations.dart'; // Adicionando o arquivo de localizações
import 'package:travelapp_frontend/controllers/locale_controller.dart'; // Importando LocaleController
import 'package:provider/provider.dart'; // Para usar o provider

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<City> cities = [];

  // Função para carregar cidades com as traducoes
  Future<void> fetchCities() async {
    try {
      final data = await ApiService.fetchCities(); // Sem passar idioma
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
    fetchCities();  // Carregando as cidades logo ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    final localeController = Provider.of<LocaleController>(context);
    final currentLocale = localeController.locale;  // Pegando o idioma atual

    return Scaffold(
      appBar: HomeAppBar(
        onLocaleChange: localeController.setLocale, // Passando a função que altera o locale
      ),
      body: Container(
        color: const Color(0xFF262626),
        child: Column(
          children: [
            // Exibindo cidades
            Expanded(
              child: cities.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        // Pegando o nome traduzido ou fallback para o nome original
                        final cityName = city.translations[currentLocale.languageCode] ?? city.name;

                        print('cityName: $cityName');

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CityPhotosScreen(
                                  cityId: city.id,
                                  cityName: cityName, // Passando o nome traduzido ou o padrão
                                  onLocaleChange: localeController.setLocale,
                                ),
                              ),
                            );
                          },
                          child: CityCard(
                            imageUrl: city.coverPhotoUrl,
                            cityName: cityName, // Usando o nome traduzido ou o padrão
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
