import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/home/domain/entities/weather_entity.dart';
import 'package:weather_app/home/domain/useCases/get_weather.dart';

class WeatherNotifier extends ChangeNotifier {
  final GetWeather getWeather;

  WeatherNotifier({required this.getWeather});

  WeatherEntity? _weather;
  bool _isLoading = false;
  String? _error;

  WeatherEntity? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeatherByCurrentLocation() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final result = await getWeather.call(
        position.latitude,
        position.longitude,
      );
      print('Weather fetched: ${result.toString()}');

      _weather = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLatLon(double lat, double lon) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await getWeather.call(lat, lon);
      _weather = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
