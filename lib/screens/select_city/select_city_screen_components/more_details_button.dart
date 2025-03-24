import 'package:flutter/material.dart';

Widget buildMoreDetailsButton() {
  return Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: EdgeInsets.only(right: 10),
      child: TextButton(
        style: TextButton.styleFrom(overlayColor: Colors.black),
        onPressed: () {},
        child: const Text(
          'More details >',
          style: TextStyle(color: Colors.black),
        ),
      ),
    ),
  );
}