import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/features/home/state/day_model.dart';
import 'package:weather_application/features/weather/presentation/widgets/weather_utils.dart';

class ForecastCarousel extends StatelessWidget {
  final List<DayModel> days;
  final Function(int)? onPageChanged;

  const ForecastCarousel({super.key, required this.days, this.onPageChanged});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today, color: Colors.white),
              SizedBox(width: 8),
              Text(
                '7-day Forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CarouselSlider(
            items: days.map((day) => _buildWeatherForecastItem(day)).toList(),
            options: CarouselOptions(
              height: 140, // Fixed height for the carousel
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.0),
            Colors.black.withOpacity(0.1),
          ],
          stops: [0.3, 0.4, 0.9, 1.0],
        ),
        border: Border.all(
          width: 1.5,
          color: Colors.white.withOpacity(0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2,
            spreadRadius: 0.5,
          ),
        ],
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
              color: Colors.white,
            ),
          ),
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
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
