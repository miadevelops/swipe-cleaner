import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../folder_picker/providers/folder_provider.dart';
import '../../folder_picker/services/saf_service.dart';
import '../models/swipe_file.dart';

/// Provider for SAF service
final safServiceProvider = Provider((ref) => SAFService());

/// Provider for swipe files state
final swipeFilesProvider =
    StateNotifierProvider<SwipeFilesNotifier, SwipeFilesState>((ref) {
  return SwipeFilesNotifier(ref);
});

/// State for swipe files
class SwipeFilesState {
  /// All files loaded from the folder
  final List<SwipeFile> files;

  /// Files marked for deletion (swiped left)
  final List<SwipeFile> toDelete;

  /// Files marked to keep (swiped right)
  final List<SwipeFile> toKeep;

  /// Current index in the swipe stack
  final int currentIndex;

  /// Whether files are being loaded
  final bool isLoading;

  /// Error message if loading failed
  final String? error;

  const SwipeFilesState({
    this.files = const [],
    this.toDelete = const [],
    this.toKeep = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.error,
  });

  /// Whether all files have been swiped
  bool get isComplete => currentIndex >= files.length && files.isNotEmpty;

  /// Number of files remaining to swipe
  int get remainingCount => files.length - currentIndex;

  /// Current file to show (null if complete)
  SwipeFile? get currentFile =>
      currentIndex < files.length ? files[currentIndex] : null;

  /// Total size of files to delete in bytes
  int get toDeleteSizeBytes =>
      toDelete.fold(0, (sum, file) => sum + file.sizeBytes);

  /// Whether there are no files to clean
  bool get isEmpty => files.isEmpty && !isLoading;

  SwipeFilesState copyWith({
    List<SwipeFile>? files,
    List<SwipeFile>? toDelete,
    List<SwipeFile>? toKeep,
    int? currentIndex,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return SwipeFilesState(
      files: files ?? this.files,
      toDelete: toDelete ?? this.toDelete,
      toKeep: toKeep ?? this.toKeep,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Notifier for swipe files state
class SwipeFilesNotifier extends StateNotifier<SwipeFilesState> {
  final Ref _ref;

  SwipeFilesNotifier(this._ref) : super(const SwipeFilesState());

  /// Loads files from the selected folder
  Future<void> loadFiles() async {
    final folderState = _ref.read(folderProvider);

    if (folderState.folderPath == null) {
      state = state.copyWith(error: 'No folder selected');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final safService = _ref.read(safServiceProvider);
      final files = await safService.listFiles(folderState.folderPath!);

      state = SwipeFilesState(
        files: files,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load files: $e',
      );
    }
  }

  /// Swipe current file left (mark for deletion)
  void swipeLeft() {
    final currentFile = state.currentFile;
    if (currentFile == null) return;

    state = state.copyWith(
      toDelete: [...state.toDelete, currentFile],
      currentIndex: state.currentIndex + 1,
    );
  }

  /// Swipe current file right (keep)
  void swipeRight() {
    final currentFile = state.currentFile;
    if (currentFile == null) return;

    state = state.copyWith(
      toKeep: [...state.toKeep, currentFile],
      currentIndex: state.currentIndex + 1,
    );
  }

  /// Remove a file from the delete list (undo in review screen)
  void removeFromDelete(SwipeFile file) {
    state = state.copyWith(
      toDelete: state.toDelete.where((f) => f.uri != file.uri).toList(),
    );
  }

  /// Clear all files marked for deletion (after successful delete)
  void clearDeleted() {
    state = state.copyWith(toDelete: []);
  }

  /// Reset to beginning (after successful delete or folder change)
  void reset() {
    state = const SwipeFilesState();
  }

  /// Go back one swipe (undo last action)
  void undoLastSwipe() {
    if (state.currentIndex == 0) return;

    final previousIndex = state.currentIndex - 1;
    final previousFile = state.files[previousIndex];

    // Remove from whichever list it was in
    final newToDelete = state.toDelete.where((f) => f.uri != previousFile.uri).toList();
    final newToKeep = state.toKeep.where((f) => f.uri != previousFile.uri).toList();

    state = state.copyWith(
      currentIndex: previousIndex,
      toDelete: newToDelete,
      toKeep: newToKeep,
    );
  }
}
