import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/home/domain/entities/weather_entity.dart';
import 'package:weather_app/home/presentation/provider/city_notifier.dart';
import 'package:weather_app/home/presentation/widget/weather_screen.dart';

class SearchCityScreen extends StatelessWidget {
  final WeatherEntity weatherEntity;

  const SearchCityScreen({super.key, required this.weatherEntity});

  @override
  Widget build(BuildContext context) {
    Timer? _debounce;
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: getBackgroundGradient(weatherEntity),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white70),
                    labelText: 'Enter city name',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final cityName = searchController.text.trim();
                        if (cityName.isNotEmpty) {
                          context.read<CityNotifier>().fetchCityByName(
                            cityName,
                          );
                        }
                      },
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        context.read<CityNotifier>().fetchCityByName(value);
                      });
                    }
                  },
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      context.read<CityNotifier>().fetchCityByName(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<CityNotifier>(
                  builder: (context, notifier, _) {
                    if (notifier.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (notifier.error != null) {
                      return Center(
                        child: Text(
                          notifier.error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    if (notifier.city == null) {
                      return const Center(
                        child: Text(
                          'Search a city to see the result.',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }
                    final city = notifier.city!;
                    return ListView.builder(
                      itemCount: city.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.white.withOpacity(0.2),
                          elevation: 0,
                          child: ListTile(
                            title: Text(
                              city[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('State: ${city[index].state}'),
                                Text(
                                  'Lat: ${city[index].lat}, Lon: ${city[index].lon}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                            leading: const Icon(Icons.location_city),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WeatherScreen(
                                    lat: city[index].lat,
                                    lon: city[index].lon,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
