import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/screens/home/state/models/city_model.dart';
import 'package:weather_application/screens/select_city/select_city_screen_components/current_temperature_section.dart';
import 'package:weather_application/screens/select_city/select_city_screen_components/forecast_button.dart';
import 'package:weather_application/screens/select_city/select_city_screen_components/location_button.dart';
import 'package:weather_application/screens/select_city/select_city_screen_components/location_section.dart';
import 'package:weather_application/screens/select_city/select_city_screen_components/more_details_button.dart';
import 'package:weather_application/screens/select_city/select_city_screen_components/weather_forecast_list.dart';
import '../select_city/select_city_screen_components/weather_condition.dart';
import '../../../core/utils_test/weather_utils.dart';
import '/screens/home/state/weather_provider.dart';

class SelectCityScreen extends StatelessWidget {
  final CityModel city;

  const SelectCityScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<WeatherProvider>(context, listen: true);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_getBackgroundImage(
                WeatherUtils.getWeatherTypeFromCode(state.currentWeatherCode))),
            fit: BoxFit.cover,
          ),
        ),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Location Icon and City Name
              buildLocationSection(city.name),
              // Location button
              buildLocationButton(context),
              // Current Temperature Section
              buildCurrentTemperatureSection(state.currentTemperature),
              // Weather Condition
              buildWeatherCondition(WeatherUtils.getWeatherTypeFromCode(
                  state.currentWeatherCode)),
              // More details button
              buildMoreDetailsButton(),
              // Weather Forecast List
              ...buildWeatherForecast(context, state.days),
              const SizedBox(height: 20),
              // 5-day Weather Forecast button
              buildFiveDayForecastButton(context),
            ],
          ),
        ),
      ),
    ));
  }

  // Screen background
  String _getBackgroundImage(WeatherType weather) {
    switch (weather) {
      case WeatherType.sunnyRainy:
        return 'assets/images/sunny_rainy.jpg';
      case WeatherType.rainy:
        return 'assets/images/rainy.jpg';
      case WeatherType.stormy:
        return 'assets/images/stormy.jpg';
      case WeatherType.cloudy:
        return 'assets/images/cloudy.jpg';
      case WeatherType.clear:
        return 'assets/images/clear.jpg';
      default:
        return 'assets/images/sunny.jpg';
    }
  }
}
