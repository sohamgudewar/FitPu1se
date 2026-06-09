import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';
import 'theme_provider.dart';

final class FitPulseApp extends ConsumerWidget {
  const FitPulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'FitPulse',
      debugShowCheckedModeBanner: false,
      theme: FitPulseTheme.light,
      darkTheme: FitPulseTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
