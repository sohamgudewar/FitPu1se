import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/api_service.dart';
import '../../../app/auth_provider.dart';
import '../../../services/firestore_service.dart';

final class PhotosScreen extends ConsumerStatefulWidget {
  const PhotosScreen({super.key});

  @override
  ConsumerState<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends ConsumerState<PhotosScreen> {
  bool _uploading = false;

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

  @override
  Widget build(BuildContext context) {
    final photosAsync = ref.watch(photoUrlsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
        actions: [
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
                    Icon(Icons.photo_library_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 16),
                    Text('No photos yet', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text('Tap + to upload a progress photo', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
                itemCount: photos.length,
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(photos[i], fit: BoxFit.cover),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
