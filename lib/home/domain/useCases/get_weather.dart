import 'package:weather_app/home/domain/entities/weather_entity.dart';
import 'package:weather_app/home/domain/repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository weatherRepository;

  GetWeather(this.weatherRepository);

  Future<WeatherEntity> call(double lat, double lon) async {
    return await weatherRepository.getWeather(lat, lon);
  }
}
