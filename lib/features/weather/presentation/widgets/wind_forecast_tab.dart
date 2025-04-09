import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/domain/weather/weather_details.dart';
import '../../../../styles/styles.dart';
import '../../glass_container.dart';
import 'hourly_forecast_list.dart';

class WindForecastTab extends StatelessWidget {
  final WeatherDetailsModel? weatherDetailsModel;
  final DateTime cityTime;
  final double windDirection;

  const WindForecastTab({
    super.key,
    required this.weatherDetailsModel,
    required this.cityTime,
    required this.windDirection,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      stops: 0.5,
      child: HourlyForecastList(
        children: List.generate(24, (i) {
          final hourTime = cityTime.add(Duration(hours: i));
          final windDirection = weatherDetailsModel?.windDirection ?? 0;
          final windSpeed = weatherDetailsModel?.windSpeed ?? 0;

          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
            child: Column(
              children: [
                Text('${hourTime.hour}:00', style: glassContainerTextStyle),
                const SizedBox(height: 15),
                Transform.rotate(
                  angle: (windDirection * (pi / 180)), // Convert degrees to radians
                  child: Icon(
                    Icons.arrow_upward,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '${windSpeed.toStringAsFixed(1)} km/h',
                  style: glassContainerTextStyle,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}