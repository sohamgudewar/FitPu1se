import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/api_service.dart';
import '../../../app/auth_provider.dart';
import '../../../models/food_log.dart';
import '../../../services/cache_service.dart';
import '../../../services/firestore_service.dart';
import '../widgets/scan_result_card.dart';
import '../widgets/search_result_tile.dart';

final class CaloriesScreen extends ConsumerStatefulWidget {
  const CaloriesScreen({super.key});

  @override
  ConsumerState<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends ConsumerState<CaloriesScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? _scanResult;
  bool _loading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickAndScan() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _loading = true;
      _scanResult = null;
    });

    try {
      final result = await ApiService.scanFood(image);
      setState(() => _scanResult = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Scan failed: $e')));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _loading = true);

    final cached = CacheService.getCachedFoodSearch(query.trim());
    if (cached != null) {
      setState(() {
        _searchResults = cached;
        _loading = false;
      });
      return;
    }

    try {
      final results = await ApiService.searchFood(query.trim());
      await CacheService.cacheFoodSearch(query.trim(), results);
      setState(() => _searchResults = results);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Search failed: $e')));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  void _logScanResult(double servingSize, String mealType) async {
    final user = ref.read(authProvider).user;
    if (user == null || _scanResult == null) return;

    final base = (_scanResult!['serving_size'] ?? 100).toDouble();
    final f = servingSize / base;
    final svc = ref.read(firestoreServiceProvider);
    final log = FoodLog(
      userId: user.uid,
      foodName: _scanResult!['food_name'] ?? 'Unknown',
      calories: ((_scanResult!['calories'] ?? 0).toDouble() * f),
      proteinG: ((_scanResult!['protein_g'] ?? 0).toDouble() * f),
      carbsG: ((_scanResult!['carbs_g'] ?? 0).toDouble() * f),
      fatG: ((_scanResult!['fat_g'] ?? 0).toDouble() * f),
      servingSize: servingSize,
      servingUnit: _scanResult!['serving_unit'] ?? 'g',
      mealType: mealType,
    );
    await svc.logFood(log);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Food logged!')));
      setState(() => _scanResult = null);
    }
  }

  void _logSearchResult(Map<String, dynamic> item, double servingSize, String mealType) async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    final f = servingSize / 100;
    final svc = ref.read(firestoreServiceProvider);
    final log = FoodLog(
      userId: user.uid,
      foodName: item['food_name'] ?? 'Unknown',
      calories: ((item['calories_per_100g'] as num?)?.toDouble() ?? 0) * f,
      proteinG: ((item['protein_g'] as num?)?.toDouble() ?? 0) * f,
      carbsG: ((item['carbs_g'] as num?)?.toDouble() ?? 0) * f,
      fatG: ((item['fat_g'] as num?)?.toDouble() ?? 0) * f,
      servingSize: servingSize,
      servingUnit: 'g',
      mealType: mealType,
    );
    await svc.logFood(log);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Food logged!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(todayFoodLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Calories')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search food...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _pickAndScan,
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                            _scanResult = null;
                          });
                        },
                      ),
                  ],
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: _search,
            ),
          ),
          Expanded(child: _buildBody(logsAsync)),
        ],
      ),
    );
  }

  Widget _buildBody(AsyncValue<List<FoodLog>> logsAsync) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scanResult != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ScanResultCard(result: _scanResult!, onLog: _logScanResult),
      );
    }

    const mealOrder = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
    final logs = logsAsync.valueOrNull ?? [];
    final grouped = <String, List<FoodLog>>{};
    for (final m in mealOrder) grouped[m] = [];
    for (final log in logs) {
      grouped.putIfAbsent(log.mealType, () => []).add(log);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (_searchResults.isNotEmpty) ...[
          ..._searchResults.map((item) => SearchResultTile(
            item: item,
            onLog: (size, meal) => _logSearchResult(item, size, meal),
          )),
          const Divider(height: 32),
        ],
        Text('Today\'s Log', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        ...mealOrder.where((m) => grouped[m]!.isNotEmpty).expand((meal) {
          final mealLogs = grouped[meal]!;
          final mealCals = mealLogs.fold(0, (sum, l) => sum + l.calories.toInt());
          return [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(meal, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  Text('${mealCals} kcal', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            ...mealLogs.map((log) => ListTile(
              dense: true,
              title: Text(log.foodName),
              trailing: Text('${log.calories.toInt()} kcal', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            )),
          ];
        }),
        if (logs.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text('No food logged today', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ),
          ),
      ],
    );
  }
}
