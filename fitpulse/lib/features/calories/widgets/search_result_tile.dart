import 'package:flutter/material.dart';

final class SearchResultTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final void Function(double servingSize, String mealType)? onLog;
  const SearchResultTile({super.key, required this.item, this.onLog});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = item['food_name'] ?? 'Unknown';
    final brand = item['brand_name'] as String?;
    final calories = item['calories_per_100g'] as double?;

    return ListTile(
      title: Text(name),
      subtitle: brand != null ? Text(brand, style: theme.textTheme.bodySmall) : null,
      trailing: calories != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${calories.toInt()}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('kcal/100g', style: theme.textTheme.bodySmall),
                  ],
                ),
                if (onLog != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _showLogDialog(context),
                    tooltip: 'Log this food',
                  ),
                ],
              ],
            )
          : null,
    );
  }

  void _showLogDialog(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = TextEditingController(text: '100');
    String mealType = 'Snack';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: Text(item['food_name'] ?? 'Log food'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: ctrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Serving size (g)', isDense: true),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Breakfast', label: Text('Breakfast')),
                      ButtonSegment(value: 'Lunch', label: Text('Lunch')),
                      ButtonSegment(value: 'Dinner', label: Text('Dinner')),
                      ButtonSegment(value: 'Snack', label: Text('Snack')),
                    ],
                    selected: {mealType},
                    onSelectionChanged: (s) => setDialogState(() => mealType = s.first),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                FilledButton(
                  onPressed: () {
                    final size = double.tryParse(ctrl.text) ?? 100;
                    Navigator.pop(ctx);
                    onLog!(size, mealType);
                  },
                  child: const Text('Log'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
