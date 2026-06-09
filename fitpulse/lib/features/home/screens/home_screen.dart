import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/auth_provider.dart';
import '../../../services/firestore_service.dart';
import '../widgets/calorie_ring.dart';
import '../widgets/macro_bar.dart';

final class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final todayCals = ref.watch(todayCaloriesProvider);
    final protein = ref.watch(todayProteinProvider);
    final carbs = ref.watch(todayCarbsProvider);
    final fat = ref.watch(todayFatProvider);
    final streakAsync = ref.watch(streakProvider);
    final streak = streakAsync.valueOrNull ?? 0;

    const goal = 2200;
    const proteinGoal = 150;
    const carbsGoal = 300;
    const fatGoal = 65;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Text('Today\'s Calories', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    CalorieRing(consumed: todayCals, goal: goal),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          MacroBar(label: 'Carbs', current: carbs, goal: carbsGoal, color: Colors.blue),
                          MacroBar(label: 'Protein', current: protein, goal: proteinGoal, color: colorScheme.primary),
                          MacroBar(label: 'Fat', current: fat, goal: fatGoal, color: Colors.orange),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
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
