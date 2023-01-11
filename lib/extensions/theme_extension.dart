import 'package:flutter/material.dart';

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.maybeOf(this)?.platformBrightness;
    return brightness == Brightness.dark;
  }
}
