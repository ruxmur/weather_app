import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/core/domain/weather/weather_details.dart';
import 'package:weather_application/features/weather/presentation/widgets/weather_utils.dart';

import '../../weather_controller.dart';

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
        SizedBox(height: 5),
        SizedBox(
          height: 200, // fixed height for the tabBarView
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
              _buildHumidityChart(context),
            ],
          ),
        ),
      ],
    );
  }

  // todo refactor this class by separating into the smallest classes
  // Tab 1: Review
  Widget _buildHourlyForecast(int weatherCode, double temperature) {
    return Container(
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
          stops: [0.3, 0.3, 0.9, 1.0],
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.access_time, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Hourly Forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
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
                  final hourlyWeatherIcon = getWeatherIconData(hourTime, weatherCode);

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                    child: Column(
                      children: [
                        Text(
                          '${hourTime.hour}:00',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 15),
                        Image.asset(
                          hourlyWeatherIcon.iconPath,
                          width: 45,
                          height: 45,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${temperature.toStringAsFixed(1)}º',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab 2: Precipitations
  Widget _buildPrecipitationForecast() {
    return Container(
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
          stops: [0.4, 0.4, 0.9, 1.0],
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.access_time, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Hourly Forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Hourly forecast content
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(24, (i) {
                  final hourTime = cityTime.add(Duration(hours: i));

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                    child: Column(
                      children: [
                        Text(
                          '${hourTime.hour}:00',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 15),
                        Image.asset(
                          'assets/icons/drop.png',
                          width: 40,
                          height: 40,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${weatherDetailsModel?.precipitation.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab 3: Wind
  Widget _buildWindForecast() {
    return Container(
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
          stops: [0.5, 0.5, 0.9, 1.0],
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.access_time, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Hourly Forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Hourly forecast content
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(24, (i) {
                  final hourTime = cityTime.add(Duration(hours: i));

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                    child: Column(
                      children: [
                        Text(
                          '${hourTime.hour}:00',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 15),
                        Icon(
                          // todo introduce real wind arrow
                          Icons.arrow_forward_rounded,
                          size: 40,
                          color: Colors.blueAccent.withOpacity(0.5),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${weatherDetailsModel?.windSpeed.toStringAsFixed(1)} km/h',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab 4: Humidity with synchronized scrolling
  Widget _buildHumidityChart(BuildContext context) {
    // Gets the weather data from our app's state management (using Provider).
    final weatherController = Provider.of<WeatherController>(context);
    final scrollController = ScrollController();

    // Shows a loading spinner if data isn't ready yet.
    if (weatherController.isLoading ||
        weatherController.hourlyHumidity.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Define the line chart bar data
    // lineChartBarData: A preconfigured LineChartBarData object (humidity data).
    final lineChartBarData = LineChartBarData(
      //List of FlSpot(x, y) points (ex: FlSpot(0, 50) = midnight at 50% humidity).
      spots: List.generate(24, (index) {
        final humidity = index < weatherController.hourlyHumidity.length
            ? weatherController.hourlyHumidity[index]
            : 0.0;
        return FlSpot(index.toDouble(), humidity);
      }),
      isCurved: true,
      color: Colors.indigoAccent,
      barWidth: 3,
      // Fills the area under the line with opacity or gradient
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.blueAccent.withOpacity(0.4)
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
      ),
      dotData: const FlDotData(show: false),
    );

    // Calculate total width needed for all hours (60px per hour)
    final totalWidth = 24 * 60.0;

    return Container(
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
          stops: [0.7, 0.7, 0.9, 1.0],
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
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with clock icon and text
          Row(
            children: const [
              Icon(Icons.access_time, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Hourly Forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: totalWidth,
                child: Column(
                  children: [
                    // Humidity percentage labels
                    SizedBox(
                      height: 20,
                      child: Row(
                        children: List.generate(24, (index) {
                          final humidity = weatherController.hourlyHumidity[index];
                          return SizedBox(
                            width: 60,
                            child: Center(
                              child: Text(
                                '${humidity.round()}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    // The humidity line chart
                    SizedBox(
                      height: 80,
                      child: LineChart(
                        LineChartData(
                          // Controls touch interactions with the chart.
                          lineTouchData: const LineTouchData(enabled: false),
                          // background grid
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          // Configures the chart's border.
                          borderData: FlBorderData(show: false),
                          // 0 to 23: Maps to 24 hours (0 = midnight, 23 = 11 PM).
                          // (Matches hourly data points.)
                          minX: 0,
                          maxX: 23,
                          // 0 to 100: Humidity is displayed as a percentage (0%–100%).
                          // (Ensures the chart scales predictably for all values.)
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [lineChartBarData],
                        ),
                      ),
                    ),

                    // Hour labels
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: List.generate(24, (index) {
                          final hourTime = cityTime.add(Duration(hours: index));
                          return SizedBox(
                            width: 60,
                            child: Center(
                              child: Text(
                                '${hourTime.hour}:00',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
