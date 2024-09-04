import 'package:flutter/material.dart';

class ThemeDataStyle {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade100,
      primary: Colors.deepPurple.shade200,
      secondary: Colors.deepPurple.shade300,
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      primary: Colors.deepPurple.shade500,
      secondary: Colors.deepPurple.shade700,
    ),
  );
}
