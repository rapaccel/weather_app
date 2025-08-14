import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/home/domain/entities/weather_entity.dart';
import 'package:weather_app/home/presentation/provider/weather_notifier.dart';
import 'package:weather_app/home/presentation/widget/search_city_screen.dart';

class WeatherScreen extends StatefulWidget {
  final double? lat;
  final double? lon;
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
  const WeatherScreen({Key? key, this.lat, this.lon}) : super(key: key);
}

class _WeatherScreenState extends State<WeatherScreen> {
  late WeatherNotifier weatherNotifier;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissionAndFetchWeather();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    weatherNotifier = Provider.of<WeatherNotifier>(context, listen: false);
  }

  Future<void> _requestPermissionAndFetchWeather() async {
    try {
      var permission = await Permission.location.request();
      if (permission == PermissionStatus.granted) {
        if (widget.lat != null && widget.lon != null) {
          await weatherNotifier.fetchWeatherByLatLon(widget.lat!, widget.lon!);
        } else {
          await weatherNotifier.fetchWeatherByCurrentLocation();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Location permission is required to get weather data',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  IconData getWeatherIcon(String? condition) {
    if (condition == null) return Icons.wb_sunny;

    final cond = condition.toLowerCase();

    if (cond.contains('clear') || cond.contains('sunny')) {
      return Icons.wb_sunny;
    } else if (cond.contains('cloud')) {
      return Icons.cloud;
    } else if (cond.contains('rain')) {
      return Icons.grain;
    } else if (cond.contains('snow')) {
      return Icons.ac_unit;
    } else if (cond.contains('thunder')) {
      return Icons.flash_on;
    }

    return Icons.wb_sunny;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherNotifier>(
        builder: (context, weatherNotifier, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: getBackgroundGradient(weatherNotifier.weather),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(weatherNotifier),
                  Expanded(
                    child: weatherNotifier.isLoading
                        ? _buildLoadingWidget()
                        : weatherNotifier.error != null
                        ? _buildErrorWidget(weatherNotifier.error!)
                        : weatherNotifier.weather != null
                        ? _buildWeatherContent(weatherNotifier.weather!)
                        : _buildEmptyState(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(WeatherNotifier weatherNotifier) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white, size: 20),
                  SizedBox(width: 5),
                  Text(
                    weatherNotifier.weather?.name.toString() ?? 'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: TextField(
              readOnly: true,
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for a city...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.white70),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (weatherNotifier.isLoading)
                      Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(right: 8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white70,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(Icons.my_location, color: Colors.white70),
                      onPressed: weatherNotifier.isLoading
                          ? null
                          : () async {
                              await weatherNotifier
                                  .fetchWeatherByCurrentLocation();
                            },
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchCityScreen(
                      weatherEntity: weatherNotifier.weather!,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Loading weather data...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait a moment',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, color: Colors.white, size: 64),
            ),
            SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              error,
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await weatherNotifier.fetchWeatherByCurrentLocation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 8),
                  Text('Try Again'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_searching,
              color: Colors.white,
              size: 64,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No weather data available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Please allow location access or search for a city',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(WeatherEntity weather) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    getWeatherIcon(
                      weather.weather.isNotEmpty
                          ? weather.weather[0].main
                          : null,
                    ),
                    color: Colors.white,
                    size: 80,
                  ),
                ),
                SizedBox(height: 20),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: weather.main.temp),
                  duration: Duration(milliseconds: 1000),
                  builder: (context, value, child) {
                    return Text(
                      '${value.round()}°',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.w300,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Text(
                  weather.weather.isNotEmpty
                      ? weather.weather[0].description.toUpperCase()
                      : 'Loading...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  _getCurrentDate(),
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherDetail(
                        Icons.visibility,
                        'Visibility',
                        '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                      ),
                      _buildWeatherDetail(
                        Icons.water_drop,
                        'Humidity',
                        '${weather.main.humidity}%',
                      ),
                      _buildWeatherDetail(
                        Icons.air,
                        'Wind',
                        '${weather.wind.speed.toStringAsFixed(1)} m/s',
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeatherDetail(
                        Icons.thermostat,
                        'Feels like',
                        '${weather.main.feelsLike.round()}°',
                      ),
                      _buildWeatherDetail(
                        Icons.compress,
                        'Pressure',
                        '${weather.main.pressure} hPa',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.white60, fontSize: 12)),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

LinearGradient getBackgroundGradient(WeatherEntity? weather) {
  if (weather == null) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
    );
  }

  final condition = weather.weather.isNotEmpty
      ? weather.weather[0].main.toLowerCase()
      : '';
  final isDay = DateTime.now().hour >= 6 && DateTime.now().hour < 18;

  if (condition.contains('clear') || condition.contains('sunny')) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDay
          ? [Color(0xFF87CEEB), Color(0xFF4682B4)]
          : [Color(0xFF1e3c72), Color(0xFF2a5298)],
    );
  } else if (condition.contains('cloud')) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF6C7B7F), Color(0xFF4A6741)],
    );
  } else if (condition.contains('rain') || condition.contains('drizzle')) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF373B44), Color(0xFF4286f4)],
    );
  } else if (condition.contains('snow')) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
    );
  } else if (condition.contains('thunder')) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF232526), Color(0xFF414345)],
    );
  }

  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
  );
}
