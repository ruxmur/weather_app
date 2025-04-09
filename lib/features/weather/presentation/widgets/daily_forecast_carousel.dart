import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/features/home/state/day_model.dart';
import 'package:weather_application/features/weather/presentation/widgets/weather_utils.dart';

import '../../../../styles/styles.dart';

class ForecastCarousel extends StatelessWidget {
  final List<DayModel> days;
  final Function(int)? onPageChanged;

  const ForecastCarousel({super.key, required this.days, this.onPageChanged});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: carouselContainerDecoration,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today, color: Colors.white),
              SizedBox(width: 8),
              Text('7-day Forecast', style: forecastTextStyle),
            ],
          ),
          const SizedBox(height: 8),
          CarouselSlider(
            items: days.map((day) => _buildWeatherForecastItem(day)).toList(),
            options: carouselOptions.copyWith(
              onPageChanged: (index, reason) {
                if (onPageChanged != null) {onPageChanged!(index);}
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherForecastItem(DayModel day) {
    final weatherIcon = getWeatherIconData(day.date, day.weatherCode, forceDayIcon: true);

    return Container(
      width: 70, // Fixed width
      height: 140, // Fixed height
      margin: const EdgeInsets.all(5), // Add spacing between items
      decoration: weatherForecastItemContainerStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day of the week
          // Abbreviated day name (ex: "Mon")
          Text(DateFormat('E').format(day.date), style: locationButtonTextStyle),
          const SizedBox(height: 8),
          // Weather icon
          Image.asset(
            weatherIcon.iconPath,
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 8),
          // Max and min temperature
          Text(
            '${day.maxTemperature.toInt()}°/${day.minTemperature.toInt()}°',
            style: maxMinTempTextStyle,
          ),
        ],
      ),
    );
  }
}
