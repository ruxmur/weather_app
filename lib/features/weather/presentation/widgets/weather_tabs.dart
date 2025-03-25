import 'package:flutter/material.dart';
import 'package:weather_application/core/domain/weather/weather_details.dart';
import 'package:weather_application/features/weather/presentation/widgets/weather_utils.dart';

class WeatherTabs extends StatelessWidget {
  final TabController tabController;
  final int weatherCode;
  final double temperature;
  final WeatherDetailsModel? weatherDetailsModel;
  final DateTime cityTime;

  const WeatherTabs({
    super.key,
    required this.tabController,
    required this.weatherCode,
    required this.temperature,
    required this.weatherDetailsModel,
    required this.cityTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Review'),
            Tab(text: 'Precipitations'),
            Tab(text: 'Wind'),
            Tab(text: 'Humidity'),
          ],
          // indicator: BoxDecoration(
          //   borderRadius: BorderRadius.circular(5), // Add borderRadius here
          //   color: Colors.blueAccent.withOpacity(0.3), // Background color of the selected tab
          // ),
          labelColor: Colors.black, // Text color of the selected tab
          unselectedLabelColor: Colors.black, // text color of the unselected tabs
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(
          height: 170, // fixed height for the tabBarView
          child: TabBarView(
            controller: tabController,
            children: [
              // Tab 1: Review
              _buildHourlyForecast(weatherCode, temperature),
              // Tab 2: Precipitations
              _buildPrecipitationForecast(),
              // Tab 3: Wind
              _buildWindForecast(),
              // Tab 4: Humidity
              _buildHumidityChart(),
            ],
          ),
        ),
      ],
    );
  }

  // Tab 1: Review
  Widget _buildHourlyForecast(int weatherCode, double temperature) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
          final hourlyWeatherIconData = getWeatherIconData(hourTime, weatherCode);

          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 40, 15, 15),
            child: Column(
              children: [
                Text('${hourTime.hour}:00'),
                const SizedBox(height: 10),
                Icon(
                  hourlyWeatherIconData.icon,
                  color: hourlyWeatherIconData.color,
                  size: 40,
                ),
                const SizedBox(height: 10),
                // Temperature per hour
                Text('${temperature.toStringAsFixed(1)}º'),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Tab 2: Precipitations
  Widget _buildPrecipitationForecast() {
    final currentTime = DateTime.now();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(24, (i) {
          final hourTime = cityTime.add(Duration(hours: i));

          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 40, 15, 15),
            child: Column(
              children: [
                Text('${hourTime.hour}:00'),
                const SizedBox(height: 10),
                Icon(
                  Icons.water_drop,
                  size: 40,
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
                const SizedBox(height: 10),
                Text('${weatherDetailsModel?.precipitation.toStringAsFixed(1)}%'),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Tab 3: Wind
  Widget _buildWindForecast() {
    final currentTime = DateTime.now();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(24, (i) {
          final hourTime = cityTime.add(Duration(hours: i));

          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 40, 15, 15),
            child: Column(
              children: [
                Text('${hourTime.hour}:00'),
                const SizedBox(height: 10),
                Icon(
                  // todo introduce real wind arrow
                  Icons.arrow_forward_rounded,
                  size: 40,
                  color: Colors.blueAccent.withOpacity(0.5),
                ),
                const SizedBox(height: 10),
                Text('${weatherDetailsModel?.windSpeed.toStringAsFixed(1)} km/h'),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Tab 4: Humidity
  // todo get real humidity data throw chart
  Widget _buildHumidityChart() {
    return const Center(
      child: Text('Humidity Chart Placeholder'),
    );
  }
}