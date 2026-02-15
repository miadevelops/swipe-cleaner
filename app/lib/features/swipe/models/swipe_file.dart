import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/file_utils.dart';

/// Model representing a file in the swipe queue
class SwipeFile {
  /// Full path/URI to the file
  final String uri;

  /// File name with extension
  final String name;

  /// File extension (without dot)
  final String extension;

  /// File size in bytes
  final int sizeBytes;

  /// Last modified date
  final DateTime modified;

  /// Detected file type
  final FileType type;

  /// Optional thumbnail path (generated later)
  final String? thumbnailPath;

  const SwipeFile({
    required this.uri,
    required this.name,
    required this.extension,
    required this.sizeBytes,
    required this.modified,
    required this.type,
    this.thumbnailPath,
  });

  /// Human-readable file size
  String get formattedSize => FileUtils.formatBytes(sizeBytes);

  /// Human-readable date (e.g., "Dec 15, 2025")
  String get formattedDate => DateFormat.yMMMd().format(modified);

  /// Relative date (e.g., "2 days ago")
  String get relativeDate {
    final now = DateTime.now();
    final difference = now.difference(modified);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  /// Icon for file type
  IconData get typeIcon => switch (type) {
        FileType.image => Icons.image_outlined,
        FileType.pdf => Icons.picture_as_pdf_outlined,
        FileType.audio => Icons.audio_file_outlined,
        FileType.video => Icons.video_file_outlined,
        FileType.archive => Icons.folder_zip_outlined,
        FileType.apk => Icons.android_outlined,
        FileType.document => Icons.description_outlined,
        FileType.spreadsheet => Icons.table_chart_outlined,
        FileType.unknown => Icons.insert_drive_file_outlined,
      };

  /// Color for file type badge
  Color typeColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;

    return switch (type) {
      FileType.image => isLight ? const Color(0xFF10B981) : const Color(0xFF34D399),
      FileType.pdf => isLight ? const Color(0xFFEF4444) : const Color(0xFFF87171),
      FileType.audio => isLight ? const Color(0xFFF59E0B) : const Color(0xFFFBBF24),
      FileType.video => isLight ? const Color(0xFF8B5CF6) : const Color(0xFFA78BFA),
      FileType.archive => isLight ? const Color(0xFF6366F1) : const Color(0xFF818CF8),
      FileType.apk => isLight ? const Color(0xFF22C55E) : const Color(0xFF4ADE80),
      FileType.document => isLight ? const Color(0xFF3B82F6) : const Color(0xFF60A5FA),
      FileType.spreadsheet => isLight ? const Color(0xFF10B981) : const Color(0xFF34D399),
      FileType.unknown => isLight ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
    };
  }

  /// Human-readable file type label
  String get typeLabel => switch (type) {
        FileType.image => 'Image',
        FileType.pdf => 'PDF',
        FileType.audio => 'Audio',
        FileType.video => 'Video',
        FileType.archive => 'Archive',
        FileType.apk => 'APK',
        FileType.document => 'Document',
        FileType.spreadsheet => 'Spreadsheet',
        FileType.unknown => extension.toUpperCase(),
      };

  /// Whether this file type can have a thumbnail
  bool get canHaveThumbnail =>
      type == FileType.image || type == FileType.video || type == FileType.pdf;

  /// Create a copy with updated fields
  SwipeFile copyWith({
    String? uri,
    String? name,
    String? extension,
    int? sizeBytes,
    DateTime? modified,
    FileType? type,
    String? thumbnailPath,
  }) {
    return SwipeFile(
      uri: uri ?? this.uri,
      name: name ?? this.name,
      extension: extension ?? this.extension,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      modified: modified ?? this.modified,
      type: type ?? this.type,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwipeFile && runtimeType == other.runtimeType && uri == other.uri;

  @override
  int get hashCode => uri.hashCode;

  @override
  String toString() => 'SwipeFile(name: $name, size: $formattedSize, type: $type)';
}
