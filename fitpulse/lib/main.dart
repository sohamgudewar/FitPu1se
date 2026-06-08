import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/auth_provider.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(authProvider.notifier).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const FitPulseApp(),
    ),
  );
}
