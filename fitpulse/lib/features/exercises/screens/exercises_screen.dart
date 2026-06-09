import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../services/cache_service.dart';
import '../data/workouts.dart';
import '../widgets/rest_timer_dialog.dart';
import '../widgets/workout_summary_dialog.dart';

final class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

final class _ExercisesScreenState extends State<ExercisesScreen> {
  final Map<int, Set<int>> _completed = {};

  @override
  void initState() {
    super.initState();
    _warmCache();
  }

  void _warmCache() {
    final cached = CacheService.getCachedExercises();
    if (cached != null) return;
    CacheService.cacheExercises(jsonEncode(workouts.map((d) => {
      'name': d.name,
      'exercises': d.exercises.map((e) => {
        'name': e.name,
        'sets': e.sets,
        'reps': e.reps,
      }).toList(),
    }).toList()));
  }

  int _completedCount(WorkoutDay day, int dayIndex) =>
      _completed[dayIndex]?.length ?? 0;

  bool _allDone(WorkoutDay day, int dayIndex) =>
      _completedCount(day, dayIndex) == day.exercises.length;

  void _toggleExercise(WorkoutDay day, int dayIndex, int exIndex) {
    final set = _completed.putIfAbsent(dayIndex, () => {});
    setState(() {
      if (set.contains(exIndex)) {
        set.remove(exIndex);
      } else {
        set.add(exIndex);
        if (!_allDone(day, dayIndex)) {
          showRestTimer(context);
        }
      }
    });

    if (_allDone(day, dayIndex)) {
      final totalSets = day.exercises.fold(0, (sum, e) => sum + e.sets);
      showDialog(
        context: context,
        builder: (_) => WorkoutSummaryDialog(
          workoutName: day.name,
          exercisesDone: day.exercises.length,
          totalSets: totalSets,
        ),
      );
    }
  }

  void showRestTimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const RestTimerDialog(),
    );
  }

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
          final done = _completedCount(day, i);
          final total = day.exercises.length;

          return Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              title: Text(day.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Text('$done/$total exercises'),
              children: day.exercises.asMap().entries.map((entry) {
                final exIndex = entry.key;
                final e = entry.value;
                final isDone = _completed[i]?.contains(exIndex) ?? false;
                return ListTile(
                  leading: Checkbox(
                    value: isDone,
                    onChanged: (_) => _toggleExercise(day, i, exIndex),
                  ),
                  title: Text(e.name, style: isDone ? TextStyle(color: theme.colorScheme.onSurfaceVariant) : null),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('${e.sets}×${e.reps}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
