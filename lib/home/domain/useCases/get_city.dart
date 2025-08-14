import 'package:weather_app/home/domain/entities/city_entity.dart';
import 'package:weather_app/home/domain/repositories/weather_repository.dart';

class GetCity {
  final WeatherRepository weatherRepository;

  GetCity(this.weatherRepository);

  Future<List<CityEntity>> call(String cityName) async {
    return await weatherRepository.getWeatherByCityName(cityName);
  }
}
