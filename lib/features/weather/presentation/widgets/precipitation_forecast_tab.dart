import 'package:flutter/material.dart';
import '../../../../core/domain/weather/weather_details.dart';
import '../../glass_container.dart';
import 'hourly_forecast_list.dart';

class PrecipitationForecastTab extends StatelessWidget {
  final WeatherDetailsModel? weatherDetailsModel;
  final DateTime cityTime;

  const PrecipitationForecastTab({
    super.key,
    required this.weatherDetailsModel,
    required this.cityTime,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      stops: 0.4,
      child: HourlyForecastList(
        children: List.generate(24, (i) {
          final hourTime = cityTime.add(Duration(hours: i));

          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
            child: Column(
              children: [
                Text('${hourTime.hour}:00', style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 15),
                Image.asset('assets/icons/drop.png', width: 40, height: 40, color: Colors.white),
                const SizedBox(height: 15),
                Text(
                  '${weatherDetailsModel?.precipitation.toStringAsFixed(1)}%',
                  style: const TextStyle(color: Colors.white)
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}