import 'package:flutter/material.dart';

import '../../../core/utils_test/weather_utils.dart';

Widget buildWeatherCondition(WeatherType weatherType) {
  // Get the weather type as a string (e.g., "sunny", "cloudy")
  final String weatherString = weatherType.toString().split('.').last;

  // Capitalize the first letter and make the rest lowercase
  final String formattedWeatherString =
      weatherString[0].toUpperCase() + weatherString.substring(1).toLowerCase();

  return Text(
    formattedWeatherString,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}