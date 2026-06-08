import 'package:flutter/material.dart';

import '../data/workouts.dart';

final class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Exercises')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: workouts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final day = workouts[i];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              title: Text(day.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Text('${day.exercises.length} exercises'),
              children: day.exercises.map((e) => _exerciseTile(theme, e)).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _exerciseTile(ThemeData theme, Exercise e) {
    return ListTile(
      title: Text(e.name),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('${e.sets}×${e.reps}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
