import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/screens/home/state/models/day_model.dart';
import 'package:weather_application/screens/weather/weather_screen_components/weather_utils.dart';

class ForecastCarousel extends StatelessWidget {
  final List<DayModel> days;
  final Function(int)? onPageChanged;

  const ForecastCarousel({super.key, required this.days, this.onPageChanged});

  @override
  Widget build(BuildContext context) {

    return CarouselSlider(
      items: days.map((day) => _buildWeatherForecastItem(day)).toList(),
      options: CarouselOptions(
        height: 130, // Fixed height for the carousel
        enlargeCenterPage: false, // Make the center item slightly larger if it's true
        aspectRatio: 16 / 9, // Aspect ratio of each item
        autoPlayCurve: Curves.fastOutSlowIn, // Smooth scrolling animation
        enableInfiniteScroll: false, // Disable infinite scrolling
        autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
        viewportFraction: 0.2, // Fraction of the viewport each item occupies
        padEnds: false, // Remove padding at the ends
        onPageChanged: (index, reason) {
          if (onPageChanged != null) {
            onPageChanged!(index);
          }
        },
      ),
    );
  }

  Widget _buildWeatherForecastItem(DayModel day) {
    final iconData = getWeatherIconData(day.date, day.weatherCode);

    return Container(
      width: 70, // Fixed width
      height: 130, // Fixed height
      margin: const EdgeInsets.all(5), // Add spacing between items
      decoration: BoxDecoration(
        // color: Colors.white.withOpacity(0.3),
        color: Colors.blueAccent.withOpacity(0.2), // Transparent container
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day of the week
          Text(
            DateFormat('E').format(day.date),
            // Abbreviated day name (ex: "Mon")
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          // Weather icon
          // todo to use icons like this Image.asset(WeatherUtils.getWeatherIconFromCode(weatherCode))
          Icon(
            iconData.icon,
            color: iconData.color,
            size: 40,
          ),
          // Builder(
          //   builder: (context) {
          //     final iconData = getWeatherIconData(day.date, day.weatherCode);
          //     return Icon(
          //       iconData.icon,
          //       color: iconData.color,
          //       size: 40,
          //     );
          //   },
          // ),
          const SizedBox(height: 8),
          // Max and min temperature
          Text(
            '${day.maxTemperature.toInt()}°/${day.minTemperature.toInt()}°',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}