import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

final class FitPulseApp extends ConsumerWidget {
  const FitPulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'FitPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF00BFA5),
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF00BFA5),
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
