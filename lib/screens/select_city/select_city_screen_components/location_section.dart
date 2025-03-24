import 'package:flutter/material.dart';
import '../../../styles/styles.dart';

Widget buildLocationSection(String locationName) {
  return Column(
    children: [
      Icon(
        Icons.location_on,
        color: Colors.black,
        size: 35,
      ),
      Text(
        locationName,
        style: locationTextStyle,
      ),
    ],
  );
}