import 'package:flutter/material.dart';

final class ScanResultCard extends StatefulWidget {
  final Map<String, dynamic> result;
  final void Function(double servingSize, String mealType)? onLog;
  const ScanResultCard({super.key, required this.result, this.onLog});

  @override
  State<ScanResultCard> createState() => _ScanResultCardState();
}

final class _ScanResultCardState extends State<ScanResultCard> {
  late TextEditingController _servingCtrl;
  String _mealType = 'Snack';

  @override
  void initState() {
    super.initState();
    final serving = (widget.result['serving_size'] ?? 100).toDouble();
    _servingCtrl = TextEditingController(text: serving.toInt().toString());
  }

  @override
  void dispose() {
    _servingCtrl.dispose();
    super.dispose();
  }

  double get _factor {
    final base = (widget.result['serving_size'] ?? 100).toDouble();
    final entered = double.tryParse(_servingCtrl.text) ?? base;
    return entered / base;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = widget.result['food_name'] ?? 'Unknown';
    final unit = widget.result['serving_unit'] ?? 'g';
    final baseCal = (widget.result['calories'] ?? 0).toDouble();
    final baseProtein = (widget.result['protein_g'] ?? 0).toDouble();
    final baseCarbs = (widget.result['carbs_g'] ?? 0).toDouble();
    final baseFat = (widget.result['fat_g'] ?? 0).toDouble();
    final f = _factor;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _servingCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(isDense: true, labelText: 'Qty'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Text(unit, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const Spacer(),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Breakfast', label: Text('B', style: TextStyle(fontSize: 12))),
                    ButtonSegment(value: 'Lunch', label: Text('L', style: TextStyle(fontSize: 12))),
                    ButtonSegment(value: 'Dinner', label: Text('D', style: TextStyle(fontSize: 12))),
                    ButtonSegment(value: 'Snack', label: Text('S', style: TextStyle(fontSize: 12))),
                  ],
                  selected: {_mealType},
                  onSelectionChanged: (s) => setState(() => _mealType = s.first),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('${(baseCal * f).toInt()} kcal', style: theme.textTheme.displayMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _nutrientChip(theme, 'Protein', '${(baseProtein * f).toStringAsFixed(1)}g', Colors.red),
                const SizedBox(width: 8),
                _nutrientChip(theme, 'Carbs', '${(baseCarbs * f).toStringAsFixed(1)}g', Colors.orange),
                const SizedBox(width: 8),
                _nutrientChip(theme, 'Fat', '${(baseFat * f).toStringAsFixed(1)}g', Colors.blue),
              ],
            ),
            if (widget.onLog != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  final entered = double.tryParse(_servingCtrl.text) ?? 100;
                  widget.onLog!(entered, _mealType);
                },
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
          color: color.withOpacity(0.1),
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
