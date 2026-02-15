import 'dart:math';

/// Utility functions for file operations
class FileUtils {
  FileUtils._();

  /// Format bytes to human-readable string
  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytes) / log(1024)).floor().clamp(0, suffixes.length - 1);

    final size = bytes / pow(1024, i);

    // Show decimals only for MB and above
    if (i < 2) {
      return '${size.round()} ${suffixes[i]}';
    }

    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Detect file type from extension
  static FileType detectFileType(String extension) {
    final ext = extension.toLowerCase().replaceAll('.', '');

    return switch (ext) {
      // Images
      'jpg' || 'jpeg' || 'png' || 'gif' || 'webp' || 'bmp' || 'heic' || 'heif' => FileType.image,

      // PDF
      'pdf' => FileType.pdf,

      // Audio
      'mp3' || 'wav' || 'aac' || 'm4a' || 'ogg' || 'flac' => FileType.audio,

      // Video
      'mp4' || 'mov' || 'avi' || 'mkv' || 'webm' || '3gp' => FileType.video,

      // Archives
      'zip' || 'rar' || '7z' || 'tar' || 'gz' => FileType.archive,

      // APK
      'apk' => FileType.apk,

      // Documents
      'doc' || 'docx' || 'txt' || 'rtf' || 'odt' => FileType.document,

      // Spreadsheets
      'xls' || 'xlsx' || 'csv' || 'ods' => FileType.spreadsheet,

      // Default
      _ => FileType.unknown,
    };
  }

  /// Get extension from filename
  static String getExtension(String filename) {
    final lastDot = filename.lastIndexOf('.');
    if (lastDot == -1 || lastDot == filename.length - 1) {
      return '';
    }
    return filename.substring(lastDot + 1);
  }
}

/// File type categories
enum FileType {
  image,
  pdf,
  audio,
  video,
  archive,
  apk,
  document,
  spreadsheet,
  unknown,
}
