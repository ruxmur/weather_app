import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized() is a method that
  // ensures the Flutter framework is properly initialized before running
  // any asynchronous code or accessing platform-specific functionality.
  // It is typically used in the following scenarios:
  // - When using plugins or packages that rely on platform channels (e.g., geolocation, camera, etc.).
  // - When running asynchronous code before calling runApp (e.g., fetching data, initializing services).
  // - When using async in the main function.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Application());
}