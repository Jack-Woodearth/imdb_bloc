import 'package:flutter/material.dart';
import 'package:imdb_bloc/constants/colors_constants.dart';
import 'package:imdb_bloc/extensions/theme_extension.dart';

class ColorsUtils {
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color yellowOrBlack(BuildContext context) =>
      context.isDarkMode ? ImdbColors.themeYellow : Colors.black;

  static Color secondaryBlackOrWhite(BuildContext context) {
    return context.isDarkMode
        ? lighten(Colors.black, 0.05)
        : darken(Colors.white, 0.05);
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
