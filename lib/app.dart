import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/features/home/home_screen.dart';
import 'package:weather_application/core/domain/location/city.dart';
import 'package:weather_application/features/weather/weather_screen.dart';
import 'features/location/selected_city_screen.dart';
import 'core/domain/providers/weather_provider.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider()..init(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: { // Home screen
          '/': (context) => HomeScreen(), // Home screen
          '/second': (context) {
            final city = ModalRoute.of(context)!.settings.arguments as CityModel;
            final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
            weatherProvider.setCity(city);
            return SelectedCityScreen(city: city);
          },
          '/weather': (context) {
            final city = ModalRoute.of(context)!.settings.arguments as CityModel;
            return WeatherScreen(city: city); // Pass the city to the Weather screen
          },
        },
      ),
    );
  }
}