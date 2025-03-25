import 'package:flutter/material.dart';
import 'package:weather_application/core/domain/location/city.dart';

class HeaderSection extends StatelessWidget {
  final CityModel city;

  const HeaderSection({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        // todo adjust the time according to the city time
      '${city.name}   ${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')}',
        style: const TextStyle(
          fontSize: 23,
          color: Colors.black,
        ),
      ),
    );
  }
}