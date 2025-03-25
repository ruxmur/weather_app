import 'package:flutter/material.dart';
import 'package:weather_application/core/domain/location/city.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/utils/timezone_utils.dart';

class HeaderSection extends StatefulWidget {
  final CityModel city;

  const HeaderSection({super.key, required this.city});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  late DateTime _localTime;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeTime();
  }

  Future<void> _initializeTime() async {
    await TimezoneUtils.initialize();
    final location = await TimezoneUtils.getLocationForCity(
      widget.city.latitude,
      widget.city.longitude,
      cityName: widget.city.name,
    );
    setState(() {
      _localTime = tz.TZDateTime.now(location);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: _isLoading ? const CircularProgressIndicator() : Text(
        '${widget.city.name}   ${TimezoneUtils.formatTime(_localTime)}',
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    );
  }
}