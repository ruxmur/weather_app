import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/screens/home/home.dart';
import 'package:weather_application/screens/home/state/models/city_model.dart';
import 'package:weather_application/screens/weather/weather.dart';
import 'screens/select_city/select_city.dart';
import '/screens/home/state/weather_provider.dart';

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
          '/': (context) => Home(), // Home screen
          '/second': (context) {
            final city = ModalRoute.of(context)!.settings.arguments as CityModel;
            final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
            weatherProvider.setCity(city);
            return SelectCity(city: city);
          },
          '/weather': (context) {
            final city = ModalRoute.of(context)!.settings.arguments as CityModel;
            return Weather(city: city); // Pass the city to the Weather screen
          },
        },
      ),
    );
  }
}