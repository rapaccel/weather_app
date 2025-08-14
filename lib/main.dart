import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/home/presentation/provider/city_notifier.dart';
import 'package:weather_app/home/presentation/provider/weather_notifier.dart';
import 'package:weather_app/home/presentation/widget/weather_screen.dart';
import 'package:weather_app/injection.dart' as di;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.locator<WeatherNotifier>()),
        ChangeNotifierProvider(create: (_) => di.locator<CityNotifier>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: WeatherScreen(),
      ),
    );
  }
}
