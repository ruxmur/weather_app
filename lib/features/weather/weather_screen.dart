import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/core/domain/location/city.dart';
import 'package:weather_application/core/domain/providers/weather_provider.dart';
import 'package:weather_application/features/weather/weather_controller.dart';
import 'package:weather_application/features/weather/presentation/widgets/current_weather_card.dart';
import 'package:weather_application/features/weather/presentation/widgets/daily_forecast_carousel.dart';
import 'package:weather_application/features/weather/presentation/widgets/weather_header.dart';
import 'package:weather_application/features/weather/presentation/widgets/weather_tabs.dart';
import '../../core/domain/providers/city_time_provider.dart';

class WeatherScreen extends StatefulWidget {
  final CityModel city;

  const WeatherScreen({super.key, required this.city});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> with TickerProviderStateMixin {
  int _currentCarouselIndex = 0;
  late final WeatherController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = WeatherController(city: widget.city)..initialize();
    _tabController = TabController(length: 4, vsync: this);
    _initializeCityTime();
  }

  Future<void> _initializeCityTime() async {
    await Provider.of<CityTimeProvider>(context, listen: false)
        .updateCityTime(widget.city.latitude, widget.city.longitude);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<WeatherController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()), // Show loading indicator
            );
          }

          final weatherProvider = Provider.of<WeatherProvider>(context);
          final days = weatherProvider.days; // This will be List<WeatherDayModel>

          return Scaffold(
            backgroundColor: Colors.grey[300],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  HeaderSection(city: widget.city),
                  CurrentWeatherCard(
                    city: widget.city,
                    currentWeather: weatherProvider.currentTemperature,
                    currentWeatherCode: weatherProvider.currentWeatherCode,
                    weatherDetails: controller.weatherDetailsModel,
                  ),
                  const SizedBox(height: 20),
                  WeatherTabs(
                    tabController: _tabController,
                    weatherCode: weatherProvider.currentWeatherCode,
                    temperature: weatherProvider.currentTemperature,
                    weatherDetailsModel: controller.weatherDetailsModel,
                    cityTime: Provider.of<CityTimeProvider>(context).currentCityTime,
                  ),
                  const SizedBox(height: 20),
                  ForecastCarousel(
                    days: days.take(10).toList(),
                    // The onPageChanged callback in CarouselSlider is a crucial feature
                    // that serves several important purposes in weather app.
                    // Why it matters:
                    // 1. Tracking User Interaction
                    // It tells which item/slide is currently visible to the user
                    // Without it, app wouldn't "know" what the user is looking at in the carousel
                    // Example: If user swipes to day 3, app can react accordingly
                    // 2. Updating the UI
                    // Allows you to show visual feedback about the current position
                    // You could:
                    // Highlight the current day
                    // Show a page indicator (dots showing position)
                    // Update other parts of the screen based on selection
                    onPageChanged: (index) {
                      setState(() {
                        _currentCarouselIndex = index;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}