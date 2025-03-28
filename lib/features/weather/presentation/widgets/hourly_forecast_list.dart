import 'package:flutter/material.dart';
import 'hourly_forecast_header.dart';

class HourlyForecastList extends StatelessWidget {
  final List<Widget> children;
  final Widget? header;

  const HourlyForecastList({
    super.key,
    required this.children,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header ?? const HourlyForecastHeader(),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: children),
          ),
        ),
      ],
    );
  }
}
