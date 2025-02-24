import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  // Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  // Get a percentage of screen width
  double widthPercent(double percent) => screenWidth * (percent / 100);

  // Get a percentage of screen height
  double heightPercent(double percent) => screenHeight * (percent / 100);

  // Get screen orientation
  Orientation get orientation => MediaQuery.of(this).orientation;

  // Check if the screen is in portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  // Check if the screen is in landscape mode
  bool get isLandscape => orientation == Orientation.landscape;
}
