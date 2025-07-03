import 'package:flutter/material.dart';
import 'package:travelapp_frontend/services/api_service.dart';
import 'package:travelapp_frontend/widgets/city_card.dart';
import 'package:travelapp_frontend/widgets/custom_app_bar.dart';
import 'package:travelapp_frontend/widgets/custom_bottom_bar.dart';
import 'package:travelapp_frontend/models/city.dart';
import 'package:travelapp_frontend/delegates/city_search_delegate.dart';

class HomeScreen extends StatefulWidget {
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
    return Scaffold(
      appBar: CustomAppBar(title: 'ClickHunt'),
      bottomNavigationBar: CustomBottomBar(),
      body: Container(
        color: Color(0xFF262626),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: InkWell(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CitySearchDelegate(cities),
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
                          'Search a city...',
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
                        return CityCard(
                          imageUrl: city.coverPhotoUrl,
                          cityName: city.name,
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
