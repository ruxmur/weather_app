import 'package:flutter/material.dart';

class HourlyForecastHeader extends StatelessWidget {
  const HourlyForecastHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
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
    );
  }
}