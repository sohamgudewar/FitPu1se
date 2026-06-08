import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/api_service.dart';
import '../../../app/auth_provider.dart';
import '../../../models/food_log.dart';
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
    try {
      final results = await ApiService.searchFood(query.trim());
      setState(() => _searchResults = results);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Search failed: $e')));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _logScanResult() async {
    final user = ref.read(authProvider).user;
    if (user == null || _scanResult == null) return;

    final svc = ref.read(firestoreServiceProvider);
    final log = FoodLog(
      userId: user.uid,
      foodName: _scanResult!['food_name'] ?? 'Unknown',
      calories: (_scanResult!['calories'] ?? 0).toDouble(),
      proteinG: (_scanResult!['protein_g'] ?? 0).toDouble(),
      carbsG: (_scanResult!['carbs_g'] ?? 0).toDouble(),
      fatG: (_scanResult!['fat_g'] ?? 0).toDouble(),
      servingSize: (_scanResult!['serving_size'] ?? 100).toDouble(),
      servingUnit: _scanResult!['serving_unit'] ?? 'g',
    );
    await svc.logFood(log);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Food logged!')));
      setState(() => _scanResult = null);
    }
  }

  Future<void> _logSearchResult(Map<String, dynamic> item) async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    final svc = ref.read(firestoreServiceProvider);
    final log = FoodLog(
      userId: user.uid,
      foodName: item['food_name'] ?? 'Unknown',
      calories: (item['calories_per_100g'] as num?)?.toDouble() ?? 0,
      proteinG: (item['protein_g'] as num?)?.toDouble() ?? 0,
      carbsG: (item['carbs_g'] as num?)?.toDouble() ?? 0,
      fatG: (item['fat_g'] as num?)?.toDouble() ?? 0,
      servingSize: 100,
      servingUnit: 'g',
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
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scanResult != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ScanResultCard(result: _scanResult!, onLog: _logScanResult),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (_searchResults.isNotEmpty) ...[
          ..._searchResults.map((item) => SearchResultTile(
            item: item,
            onLog: () => _logSearchResult(item),
          )),
          const Divider(height: 32),
        ],
        Text('Today\'s Log', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        logsAsync.when(
          data: (logs) {
            if (logs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('No food logged today', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ),
              );
            }
            return Column(
              children: logs.map((log) => ListTile(
                dense: true,
                title: Text(log.foodName),
                trailing: Text('${log.calories.toInt()} kcal', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
              )).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
      ],
    );
  }
}
