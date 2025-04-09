import 'package:flutter/material.dart';
import '../../../../styles/styles.dart';

Widget buildLocationButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pop(context);
    },
    style: locationButtonStyle,
    child: const Text(
      'Go Back to Main Screen',
      style: locationButtonTextStyle,
    ),
  );
}