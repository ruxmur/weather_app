import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../glass_container.dart';
import '../../weather_controller.dart';
import 'hourly_forecast_header.dart';

class HumidityForecastTab extends StatefulWidget {
  final BuildContext context;
  final WeatherController weatherController;
  final DateTime cityTime;

  const HumidityForecastTab({
    super.key,
    required this.context,
    required this.weatherController,
    required this.cityTime,
  });

  @override
  State<HumidityForecastTab> createState() => _HumidityForecastTabState();
}

class _HumidityForecastTabState extends State<HumidityForecastTab> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Shows a loading spinner if data isn't ready yet.
    if (widget.weatherController.isLoading || widget.weatherController.hourlyHumidity.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Define the line chart bar data
    // lineChartBarData: A preconfigured LineChartBarData object (humidity data).
    final lineChartBarData = _buildChartData(widget.weatherController);
    // Calculate total width needed for all hours (60px per hour)
    final totalWidth = 24 * 60.0;

    return GlassContainer(
      stops: 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HourlyForecastHeader(),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: totalWidth,
                child: Column(
                  children: [
                    _buildHumidityLabels(widget.weatherController),
                    _buildHumidityChart(lineChartBarData),
                    _buildHourLabels(widget.cityTime),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildChartData(WeatherController weatherController) {
    return LineChartBarData(
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
  }

  Widget _buildHumidityLabels(WeatherController weatherController) {
    // Humidity percentage labels
    return SizedBox(
      height: 20,
      child: Row(
        children: List.generate(24, (index) {
          final humidity = weatherController.hourlyHumidity[index];
          return SizedBox(
            width: 60,
            child: Center(
              child: Text(
                '${humidity.round()}%',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHumidityChart(LineChartBarData lineChartBarData) {
    // The humidity line chart
    return SizedBox(
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
    );
  }

  Widget _buildHourLabels(DateTime cityTime) {
    return SizedBox(
      height: 40,
      child: Row(
        children: List.generate(24, (index) {
          final hourTime = cityTime.add(Duration(hours: index));
          return SizedBox(
            width: 60,
            child: Center(
              child: Text(
                '${hourTime.hour}:00',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          );
        }),
      ),
    );
  }
}
