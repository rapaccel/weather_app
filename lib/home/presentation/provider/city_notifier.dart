import 'package:flutter/material.dart';
import 'package:weather_app/home/domain/entities/city_entity.dart';
import 'package:weather_app/home/domain/useCases/get_city.dart';

class CityNotifier extends ChangeNotifier {
  final GetCity getCity;
  CityNotifier({required this.getCity});
  List<CityEntity>? _city;
  List<CityEntity>? get city => _city;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;
  Future<void> fetchCityByName(String cityName) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      final result = await getCity.call(cityName);
      _city = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
