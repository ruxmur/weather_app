import 'package:flutter/material.dart';
import 'package:weather_application/features/weather/presentation/widgets/weather_utils.dart';
import '../../../../styles/styles.dart';
import '../../glass_container.dart';
import 'hourly_forecast_list.dart';

class TemperatureForecastTab extends StatelessWidget {
  final int weatherCode;
  final double temperature;
  final DateTime cityTime;

  const TemperatureForecastTab({
    super.key,
    required this.weatherCode,
    required this.temperature,
    required this.cityTime,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: HourlyForecastList(
        // List
        // -functional programming style, -returns a new list directly,
        // -more concise for simple list generation, -immutable by nature (creates a new list),
        // -automatically handles index (passed as i parameter),
        // -better for transformations where each element is computed from its index

        // for loop:
        // -imperative programming style, -requires manual list creation and population,
        // -more flexible for complex logic, -mutable (you modify the list in place),
        // -bBetter for conditional additions or complex iterations,
        // -more verbose but clearer for complex operations

        // Use List instead of for (var i = 0; i < 24; i++)
        // because it simple iteration (24 hours):
        children: List.generate(24, (i) {
          final hourTime = cityTime.add(Duration(hours: i));
          final hourlyWeatherIcon = getWeatherIconData(hourTime, weatherCode);

          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
            child: Column(
              children: [
                Text('${hourTime.hour}:00', style: glassContainerTextStyle),
                const SizedBox(height: 15),
                Image.asset(hourlyWeatherIcon.iconPath, width: 45, height: 45),
                const SizedBox(height: 15),
                Text('${temperature.toStringAsFixed(1)}º', style: glassContainerTextStyle),
              ],
            ),
          );
        }),
      ),
    );
  }
}