import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/auth_provider.dart';
import '../../../services/firestore_service.dart';

final class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final todayCals = ref.watch(todayCaloriesProvider);
    final streakAsync = ref.watch(streakProvider);
    final streak = streakAsync.valueOrNull ?? 0;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${auth.user?.displayName ?? 'FitPulse'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider).signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Today\'s Calories', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      todayCals.toInt().toString(),
                      style: theme.textTheme.displayLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                    Text('/ 2200 kcal goal', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.orange, size: 36),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Streak', style: theme.textTheme.titleMedium),
                        Text('$streak ${streak == 1 ? 'day' : 'days'}', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
