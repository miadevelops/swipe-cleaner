import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/file_utils.dart';
import '../../swipe/models/swipe_file.dart';

/// Service for SAF (Storage Access Framework) operations
/// Uses file_picker for directory selection, dart:io for file operations
class SAFService {
  /// Opens the SAF directory picker and returns the selected path
  Future<String?> pickFolder() async {
    final result = await FilePicker.platform.getDirectoryPath();
    return result;
  }

  /// Returns the path to the Downloads folder if accessible.
  /// Requests MANAGE_EXTERNAL_STORAGE permission on Android 11+.
  /// Returns null if permission is denied.
  Future<String?> pickDownloadsFolder() async {
    if (!Platform.isAndroid) {
      // On non-Android platforms, fall back to the regular picker
      return pickFolder();
    }

    final granted = await _requestStoragePermission();
    if (!granted) return null;

    const downloadsPath = '/storage/emulated/0/Download';
    final dir = Directory(downloadsPath);
    if (await dir.exists()) {
      return downloadsPath;
    }
    return null;
  }

  /// Requests the appropriate storage permission.
  /// Returns true if granted.
  Future<bool> _requestStoragePermission() async {
    // Android 11+ (API 30+): need MANAGE_EXTERNAL_STORAGE
    final status = await Permission.manageExternalStorage.status;
    if (status.isGranted) return true;

    final result = await Permission.manageExternalStorage.request();
    return result.isGranted;
  }

  /// Lists all files in the selected folder
  /// Returns a list of SwipeFile objects
  Future<List<SwipeFile>> listFiles(String folderPath) async {
    final directory = Directory(folderPath);

    if (!await directory.exists()) {
      return [];
    }

    final files = <SwipeFile>[];

    await for (final entity in directory.list(followLinks: false)) {
      if (entity is File) {
        final fileInfo = await getFileInfo(entity.path);
        if (fileInfo != null) {
          files.add(fileInfo);
        }
      }
    }

    // Sort by modified date, newest first
    files.sort((a, b) => b.modified.compareTo(a.modified));

    return files;
  }

  /// Gets detailed file information
  Future<SwipeFile?> getFileInfo(String path) async {
    try {
      final file = File(path);

      if (!await file.exists()) {
        return null;
      }

      final stat = await file.stat();
      final name = p.basename(path);
      final extension = FileUtils.getExtension(name);
      final type = FileUtils.detectFileType(extension);

      return SwipeFile(
        uri: path,
        name: name,
        extension: extension,
        sizeBytes: stat.size,
        modified: stat.modified,
        type: type,
      );
    } catch (e) {
      // File might not be accessible
      return null;
    }
  }

  /// Deletes files by their paths
  /// Returns the number of successfully deleted files
  Future<int> deleteFiles(List<String> filePaths) async {
    int deletedCount = 0;

    for (final path in filePaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
          deletedCount++;
        }
      } catch (e) {
        // Continue with other files if one fails
      }
    }

    return deletedCount;
  }

  /// Deletes a single file by path
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Gets the display name of a folder from its path
  String getFolderName(String folderPath) {
    return p.basename(folderPath);
  }
}
