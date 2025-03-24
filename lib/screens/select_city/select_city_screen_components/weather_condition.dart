import 'package:flutter/material.dart';

import '../../../core/utils_test/weather_utils.dart';
import '../../../styles/styles.dart';

Widget buildWeatherCondition(WeatherType weatherType) {
  return Text(
    weatherType.toString().split('.').last,
    style: weatherConditionTextStyle,
  );
}