import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ThemeOption { system, light, dark }

final themeOptionProvider = StateProvider<ThemeOption>((ref) => ThemeOption.system);

final themeModeProvider = Provider<ThemeMode>((ref) {
  final option = ref.watch(themeOptionProvider);
  switch (option) {
    case ThemeOption.system: return ThemeMode.system;
    case ThemeOption.light: return ThemeMode.light;
    case ThemeOption.dark: return ThemeMode.dark;
  }
});
