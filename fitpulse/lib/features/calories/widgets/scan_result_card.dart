import 'package:flutter/material.dart';

final class ScanResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  final VoidCallback? onLog;
  const ScanResultCard({super.key, required this.result, this.onLog});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = result['food_name'] ?? 'Unknown';
    final calories = (result['calories'] ?? 0).toDouble();
    final protein = (result['protein_g'] ?? 0).toDouble();
    final carbs = (result['carbs_g'] ?? 0).toDouble();
    final fat = (result['fat_g'] ?? 0).toDouble();
    final serving = (result['serving_size'] ?? 100).toDouble();
    final unit = result['serving_unit'] ?? 'g';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Per $serving $unit', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 20),
            Text('${calories.toInt()} kcal', style: theme.textTheme.displayMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                _nutrientChip(theme, 'Protein', '${protein.toStringAsFixed(1)}g', Colors.red),
                const SizedBox(width: 8),
                _nutrientChip(theme, 'Carbs', '${carbs.toStringAsFixed(1)}g', Colors.orange),
                const SizedBox(width: 8),
                _nutrientChip(theme, 'Fat', '${fat.toStringAsFixed(1)}g', Colors.blue),
              ],
            ),
            if (onLog != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onLog,
                icon: const Icon(Icons.add),
                label: const Text('Log this food'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _nutrientChip(ThemeData theme, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
