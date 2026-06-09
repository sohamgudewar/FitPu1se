import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/api_service.dart';
import '../../../app/auth_provider.dart';
import '../../../services/firestore_service.dart';
import '../widgets/comparison_screen.dart';

final class PhotosScreen extends ConsumerStatefulWidget {
  const PhotosScreen({super.key});

  @override
  ConsumerState<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends ConsumerState<PhotosScreen> {
  bool _uploading = false;
  final Set<int> _selected = {};

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _uploading = true);

    try {
      final url = await ApiService.uploadPhoto(image);
      final user = ref.read(authProvider).user;
      if (user != null) {
        await ref.read(firestoreServiceProvider).savePhoto(user.uid, url);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    } finally {
      setState(() => _uploading = false);
    }
  }

  void _toggleSelect(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        if (_selected.length >= 2) _selected.remove(_selected.first);
        _selected.add(index);
      }
    });
  }

  void _openComparison(List<String> photos) {
    if (_selected.length != 2) return;
    final sorted = _selected.toList()..sort();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ComparisonScreen(
        image1: photos[sorted[0]],
        image2: photos[sorted[1]],
      ),
    ));
    setState(() => _selected.clear());
  }

  @override
  Widget build(BuildContext context) {
    final photosAsync = ref.watch(photoUrlsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_selected.length == 2 ? 'Tap to compare' : 'Photos'),
        actions: [
          if (_selected.length == 2)
            IconButton(
              icon: const Icon(Icons.compare_arrows),
              onPressed: photosAsync.valueOrNull != null ? () => _openComparison(photosAsync.valueOrNull!) : null,
            ),
          IconButton(
            icon: _uploading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.add_photo_alternate),
            onPressed: _uploading ? null : _pickAndUpload,
          ),
        ],
      ),
      body: photosAsync.when(
        data: (photos) => photos.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_library_outlined, size: 64, color: theme.colorScheme.outline),
                    const SizedBox(height: 16),
                    Text('No photos yet', style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text('Tap + to upload a progress photo', style: theme.textTheme.bodySmall),
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
                itemCount: photos.length,
                itemBuilder: (_, i) {
                  final selected = _selected.contains(i);
                  return GestureDetector(
                    onLongPress: () => _toggleSelect(i),
                    onTap: selected ? () => _toggleSelect(i) : null,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(photos[i], fit: BoxFit.cover),
                        ),
                        if (selected)
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: theme.colorScheme.primary, width: 2),
                            ),
                            child: Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 28),
                          ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
