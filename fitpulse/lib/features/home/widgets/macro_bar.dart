import 'package:flutter/material.dart';

final class MacroBar extends StatelessWidget {
  final String label;
  final double current;
  final double goal;
  final Color color;

  const MacroBar({
    super.key,
    required this.label,
    required this.current,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fraction = (current / goal).clamp(0, 1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              Text('${current.toInt()}g / ${goal.toInt()}g', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: color,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
