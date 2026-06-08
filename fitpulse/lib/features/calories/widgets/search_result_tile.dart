import 'package:flutter/material.dart';

final class SearchResultTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onLog;
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
                    onPressed: onLog,
                    tooltip: 'Log this food',
                  ),
                ],
              ],
            )
          : null,
    );
  }
}
