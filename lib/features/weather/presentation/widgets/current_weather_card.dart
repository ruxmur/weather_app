import 'package:flutter/material.dart';
import 'package:weather_application/core/utils/weather_utils.dart';
import 'package:weather_application/core/domain/location/city.dart';
import 'package:weather_application/core/domain/weather/weather_details.dart';
import 'package:weather_application/features/weather/presentation/widgets/weather_utils.dart';
import 'package:weather_application/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/core/domain/providers/weather_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  final CityModel city;
  final double currentWeather;
  final int currentWeatherCode;
  final WeatherDetailsModel? weatherDetails;

  const CurrentWeatherCard({
    super.key,
    required this.city,
    required this.currentWeather,
    required this.currentWeatherCode,
    required this.weatherDetails,
  });

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final feelsLike = weatherProvider.feelsLikeTemperature;
    final hourlyWeatherIcon = getWeatherIconData(DateTime.now(), currentWeatherCode);

    return Container(
      height: 300,
      decoration: weatherContainerDecoration,
      child: SafeArea(
        child: Padding(
          padding: homePadding,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Weather', style: weatherTextStyle),
                  const Text('Now', style: nowTextStyle),
                  Row(
                    children: [
                      // Real weather for the selected city
                      Text('${currentWeather.toStringAsFixed(1)}º', style: currentWeatherTextStyle),
                      Image.asset(
                        hourlyWeatherIcon.iconPath,
                        width: 45,
                        height: 45,
                      ),
                    ],
                  ),
                  Text('Feels like ${feelsLike.round().toString()}º', style: climateTextStyle),
                ],
              ),
              // Spacer to push the next column to the right
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                // Align vertically
                children: [
                  buildWeatherCondition(WeatherUtils.getWeatherTypeFromCode(currentWeatherCode)),
                  Text(
                    'Precipitation: ${weatherDetails?.precipitation.toStringAsFixed(1)}%',
                    style: climateTextStyle,
                  ),
                  Text(
                    'Humidity: ${weatherDetails?.humidity.toStringAsFixed(1)}%',
                    style: climateTextStyle,
                  ),
                  Text(
                    'Wind: ${weatherDetails?.windSpeed.toStringAsFixed(1)} km/h',
                    style: climateTextStyle,
                  ),
                  Text(
                    'Air: ${_getAirQualityDescription(weatherDetails?.airQuality ?? 0)}',
                    style: climateTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAirQualityDescription(double airQualityIndex) {
    if (airQualityIndex <= 10) return 'Good';
    if (airQualityIndex >= 10 && airQualityIndex <= 20) return 'Fair';
    if (airQualityIndex >= 20 && airQualityIndex <= 25) return 'Moderate';
    if (airQualityIndex >= 25 && airQualityIndex <= 50) return 'Poor';
    if (airQualityIndex >= 50 && airQualityIndex <= 75) return 'Very poor';
    if (airQualityIndex >= 75 && airQualityIndex <= 800) return 'Extremely poor';
    return 'Hazardous';
  }

  Widget buildWeatherCondition(WeatherType weatherType) {
    // Get the weather type as a string (e.g., "sunny", "cloudy")
    final String weatherString = weatherType.toString().split('.').last;

    // Capitalize the first letter and make the rest lowercase
    final String formattedWeatherString =
        weatherString[0].toUpperCase() + weatherString.substring(1).toLowerCase();

    return Text(formattedWeatherString, style: formattedWeatherTextStyle);
  }
}