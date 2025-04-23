import 'dart:io';
// code for labeling images
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabelerService {
  final ImageLabeler _labeler = ImageLabeler(options: ImageLabelerOptions());

  Future<List<String>> getLabels(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final labels = await _labeler.processImage(inputImage);

    return labels.map((label) => label.label).toList();
  }
}

//scannign list of images
Future<void> scanImages() async {
  final picker = ImagePicker();
  final List<XFile>? images = await picker.pickMultiImage();

  if (images == null) return;

  final labelerService = ImageLabelerService();
  int i = 1;

  for (final image in images) {
    final file = File(image.path);
    final labels = await labelerService.getLabels(file);
    print('Image $i: ${labels.join(", ")}');
    i++;
  }
}
