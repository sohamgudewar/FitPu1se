import 'package:flutter/material.dart';

final class FitPulseTheme {
  FitPulseTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF00BFA5),
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(centerTitle: true),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF00BFA5),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(centerTitle: true),
      );
}
