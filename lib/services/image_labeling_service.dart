import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

Future<Map<String, List<String>>> labelImages(List<File> images) async {
  final ImageLabeler labeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.5),
  );

  final Map<String, List<String>> results = {};

  for (int i = 0; i < images.length; i++) {
    final inputImage = InputImage.fromFile(images[i]);
    final List<ImageLabel> labels = await labeler.processImage(inputImage);

    final List<String> labelTexts = labels.map((label) => label.label).toList();
    results['image${i + 1}'] = labelTexts;
  }

  await labeler.close();
  return results;
}
