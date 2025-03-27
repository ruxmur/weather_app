import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/core/domain/location/city.dart';
import 'package:weather_application/features/location/presentation/widgets/current_temp_display.dart';
import 'package:weather_application/features/location/presentation/widgets/forecast_button.dart';
import 'package:weather_application/features/location/presentation/widgets/location_button.dart';
import 'package:weather_application/features/location/presentation/widgets/location_section.dart';
import 'package:weather_application/features/location/presentation/widgets/weather_forecast_list.dart';
import 'presentation/widgets/weather_condition.dart';
import '../../../core/utils/weather_utils.dart';
import '../../core/domain/providers/weather_provider.dart';

class SelectedCityScreen extends StatelessWidget {
  final CityModel city;

  const SelectedCityScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<WeatherProvider>(context, listen: true);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              _getBackgroundImage(
                WeatherUtils.getWeatherTypeFromCode(state.currentWeatherCode)
              ),
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8),
              BlendMode.dstATop,
            ),
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
              buildWeatherCondition(WeatherUtils.getWeatherTypeFromCode(state.currentWeatherCode)),
              const SizedBox(height: 30),
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
