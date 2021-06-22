import 'package:flutter/material.dart';

class MupColors {
  static final Color mainTheme = Color.fromARGB(255, 77, 108, 250);
  static final Color cardColor = Color.fromARGB(255, 239, 241, 243);
  static final Color background = Color.fromARGB(255, 222, 255, 252);
  static final Color shadowColor = Color(0x802196F3);

  //Credit: https://blog.usejournal.com/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
