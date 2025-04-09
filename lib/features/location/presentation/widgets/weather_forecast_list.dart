import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../styles/styles.dart';
import '../../../home/state/day_model.dart';
import '../../../../core/utils/weather_utils.dart';
import '../../../../core/domain/providers/weather_provider.dart';

List<Widget> buildWeatherForecast(BuildContext context, List<DayModel> days) {
  final state = Provider.of<WeatherProvider>(context, listen: true);

  // Ensure there's enough data to display
  if (days.isEmpty) {
    return [const SizedBox()]; // Return an empty widget if no data is available
  }

  // Limit the forecast to 7 days
  final forecastDays = state.days.take(7).toList();

  return forecastDays.map((day) {
    return buildWeatherForecastItem(
      DateFormat('EEE').format(day.date), // Day of the week
      day.minTemperature,
      day.maxTemperature,
      WeatherUtils.getWeatherTypeFromCode(day.weatherCode), // Weather type
    );
  }).toList();
}

class WeatherDay {
}

// Weather Forecast Item
Widget buildWeatherForecastItem(
    String dayOfWeek,
    double minTemperature,
    double maxTemperature,
    WeatherType weatherType
    ) {
  return Padding(
    padding: temperatureForecastPaddingStyle,
    child: Row(
      children: [
        Image.asset(
          WeatherUtils.getWeatherIcon(weatherType),
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 5),
        Text(
          '$dayOfWeek • ${weatherType.toString().split('.').last}',
          style: temperatureForecastTextStyle,
        ),
        const Spacer(),
        Text(
          '${minTemperature.toStringAsFixed(1)}º / ${maxTemperature.toStringAsFixed(1)}º',
          style: temperatureForecastTextStyle,
        ),
      ],
    ),
  );
}