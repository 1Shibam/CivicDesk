import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imageListProvider = StateNotifierProvider<ImageListNotifier, List<XFile>>(
  (ref) => ImageListNotifier(),
);

class ImageListNotifier extends StateNotifier<List<XFile>> {
  ImageListNotifier() : super([]);

  void addImages(List<XFile> newImages) {
    final remaining = 10 - state.length;
    final limitedImages = newImages.take(remaining).toList();
    state = [...state, ...limitedImages];
  }

  void removeImage(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
  }

  void clearImages() => state = [];
}
