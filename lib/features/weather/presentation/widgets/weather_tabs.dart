import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/core/domain/weather/weather_details.dart';
import 'package:weather_application/features/weather/presentation/widgets/precipitation_forecast_tab.dart';
import 'package:weather_application/features/weather/presentation/widgets/temperature_forecast_tab.dart';
import 'package:weather_application/features/weather/presentation/widgets/wind_forecast_tab.dart';
import '../../../../styles/styles.dart';
import '../../weather_controller.dart';
import 'humidity_forecast_tab.dart';

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
    // Gets the weather data from our app's state management (using Provider).
    final weatherController = Provider.of<WeatherController>(context);

    return Column(
      children: [
        _buildTabBar(),
        const SizedBox(height: 5),
        SizedBox(
          height: 200,
          child: TabBarView(
            controller: tabController,
            children: [
              TemperatureForecastTab(
                weatherCode: weatherCode,
                temperature: temperature,
                cityTime: cityTime,
              ),
              PrecipitationForecastTab(
                weatherDetailsModel: weatherDetailsModel,
                cityTime: cityTime,
              ),
              WindForecastTab(
                weatherDetailsModel: weatherDetailsModel,
                cityTime: cityTime,
                windDirection: weatherDetailsModel?.windDirection ?? 0,
              ),
              HumidityForecastTab(
                context: context,
                weatherController: weatherController,
                cityTime: cityTime,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: tabController,
      tabs: const [
        Tab(text: 'Review'),
        Tab(text: 'Precipitations'),
        Tab(text: 'Wind'),
        Tab(text: 'Humidity'),
      ],
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
      labelStyle: selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
    );
  }
}