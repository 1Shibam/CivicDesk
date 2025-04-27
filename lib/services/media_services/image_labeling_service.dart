import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

Future<List<String>> labelImages(List<File> images) async {
  final ImageLabeler labeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: 0.5),
  );

  final List<String> allLabels = [];

  for (final image in images) {
    final inputImage = InputImage.fromFile(image);
    final labels = await labeler.processImage(inputImage);

    for (final label in labels) {
      if (!allLabels.contains(label.label)) {
        allLabels.add(label.label);
      }
    }
  }

  await labeler.close();
  return allLabels;
}
