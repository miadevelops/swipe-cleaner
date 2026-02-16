import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../utils/file_utils.dart';
import '../../features/swipe/models/swipe_file.dart';

/// Service for generating and caching file thumbnails.
///
/// Generates video and PDF thumbnails and caches them to a temp directory.
/// Image precaching is handled separately via Flutter's [precacheImage].
class ThumbnailService {
  ThumbnailService._();
  static final instance = ThumbnailService._();

  /// Cache directory for generated thumbnails
  String? _cacheDir;

  /// In-memory map: file uri → generated thumbnail path
  final Map<String, String> _cache = {};

  /// URIs currently being generated (prevents duplicate work)
  final Set<String> _inProgress = {};

  /// Returns the cached thumbnail path for [uri], or null if not yet generated.
  String? getCachedPath(String uri) => _cache[uri];

  /// Whether a thumbnail is already cached for [uri].
  bool hasThumbnail(String uri) => _cache.containsKey(uri);

  /// Whether thumbnail generation is in progress for [uri].
  bool isGenerating(String uri) => _inProgress.contains(uri);

  /// Generates a thumbnail for [file] and caches it.
  /// Returns the path to the generated thumbnail, or null on failure.
  Future<String?> generateThumbnail(SwipeFile file) async {
    // Already cached
    if (_cache.containsKey(file.uri)) return _cache[file.uri];

    // Already in progress
    if (_inProgress.contains(file.uri)) return null;

    // Route to the right generator
    if (file.type == FileType.video) {
      return _generateVideoThumbnail(file);
    } else if (file.type == FileType.pdf) {
      return _generatePdfThumbnail(file);
    }

    return null;
  }

  /// Generates a thumbnail from the first frame of a video.
  Future<String?> _generateVideoThumbnail(SwipeFile file) async {
    _inProgress.add(file.uri);

    try {
      _cacheDir ??= (await getTemporaryDirectory()).path;

      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: file.uri,
        thumbnailPath: _cacheDir,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 600,
        quality: 75,
      );

      if (thumbnailPath != null && await File(thumbnailPath).exists()) {
        _cache[file.uri] = thumbnailPath;
        return thumbnailPath;
      }
    } catch (e) {
      debugPrint('Video thumbnail failed for ${file.name}: $e');
    } finally {
      _inProgress.remove(file.uri);
    }

    return null;
  }

  /// Renders the first page of a PDF to a JPEG thumbnail.
  Future<String?> _generatePdfThumbnail(SwipeFile file) async {
    _inProgress.add(file.uri);

    try {
      _cacheDir ??= (await getTemporaryDirectory()).path;

      final document = await PdfDocument.openFile(file.uri);
      final page = await document.getPage(1);

      final pageImage = await page.render(
        width: page.width * 2, // 2x for sharpness, capped by cacheWidth later
        height: page.height * 2,
        format: PdfPageImageFormat.jpeg,
        quality: 80,
      );

      await page.close();
      await document.close();

      if (pageImage != null) {
        // Write the rendered bytes to a temp file
        final fileName =
            'pdf_thumb_${file.uri.hashCode.toRadixString(16)}.jpg';
        final thumbFile = File('$_cacheDir/$fileName');
        await thumbFile.writeAsBytes(pageImage.bytes);

        _cache[file.uri] = thumbFile.path;
        return thumbFile.path;
      }
    } catch (e) {
      debugPrint('PDF thumbnail failed for ${file.name}: $e');
    } finally {
      _inProgress.remove(file.uri);
    }

    return null;
  }

  /// Precaches an image file into Flutter's image cache so it displays
  /// instantly when the card is shown.
  Future<void> precacheImageFile(
    String filePath,
    BuildContext context,
  ) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final provider = ResizeImage(
          FileImage(file),
          width: 600,
        );
        // ignore: use_build_context_synchronously
        await precacheImage(provider, context);
      }
    } catch (e) {
      // Non-critical — image will load when displayed
    }
  }

  /// Clears the in-memory cache (e.g. on folder change).
  void clearCache() {
    _cache.clear();
    _inProgress.clear();
  }
}
