import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/thumbnail_service.dart';
import '../../../core/utils/file_utils.dart';
import '../models/swipe_file.dart';

/// Provider for the singleton ThumbnailService.
final thumbnailServiceProvider = Provider((ref) => ThumbnailService.instance);

/// Provider that holds cached thumbnail paths: { fileUri → thumbnailPath }.
/// Widgets watch this to reactively display thumbnails as they become available.
final thumbnailCacheProvider =
    StateNotifierProvider<ThumbnailCacheNotifier, Map<String, String?>>(
  (ref) => ThumbnailCacheNotifier(ref),
);

/// Notifier that manages the thumbnail cache and handles background preloading.
class ThumbnailCacheNotifier extends StateNotifier<Map<String, String?>> {
  final Ref _ref;

  ThumbnailCacheNotifier(this._ref) : super({});

  /// Number of files to preload ahead of the current index.
  static const int _preloadAhead = 5;

  /// File types that support thumbnail generation.
  static const _thumbnailTypes = {FileType.video, FileType.pdf};

  /// Generates a thumbnail for a single [file] and updates the cache.
  Future<void> _generateFor(SwipeFile file) async {
    // Skip if already cached or unsupported type
    if (state.containsKey(file.uri)) return;
    if (!_thumbnailTypes.contains(file.type)) return;

    // Mark as in-progress (null value)
    state = {...state, file.uri: null};

    final service = _ref.read(thumbnailServiceProvider);
    final path = await service.generateThumbnail(file);

    if (path != null && mounted) {
      state = {...state, file.uri: path};
    }
  }

  /// Preloads thumbnails for files around [currentIndex].
  /// Call after files are loaded and after each swipe.
  Future<void> preload(List<SwipeFile> files, int currentIndex) async {
    final endIndex = min(currentIndex + _preloadAhead, files.length);

    for (var i = currentIndex; i < endIndex; i++) {
      final file = files[i];

      if (_thumbnailTypes.contains(file.type) &&
          !state.containsKey(file.uri)) {
        // Fire and forget — each thumbnail updates the cache independently
        _generateFor(file);
      }
    }
  }

  /// Precaches upcoming image files into Flutter's image cache.
  /// Must be called with a valid [BuildContext].
  Future<void> precacheImages(
    List<SwipeFile> files,
    int currentIndex,
    BuildContext context,
  ) async {
    final service = _ref.read(thumbnailServiceProvider);
    final endIndex = min(currentIndex + _preloadAhead, files.length);

    for (var i = currentIndex; i < endIndex; i++) {
      final file = files[i];
      if (file.type == FileType.image) {
        service.precacheImageFile(file.uri, context);
      }
    }
  }

  /// Clears all cached thumbnails (e.g. on folder change).
  void clear() {
    _ref.read(thumbnailServiceProvider).clearCache();
    state = {};
  }
}
