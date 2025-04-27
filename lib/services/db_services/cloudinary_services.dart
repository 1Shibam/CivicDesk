import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  final cloudinary = Cloudinary.signedConfig(
    cloudName: dotenv.env['CLOUDINARY_NAME']!,
    apiKey: dotenv.env['CLOUDINARY_API_KEY']!,
    apiSecret: dotenv.env['CLOUDINARY_API_SECRET']!,
  );

  // Upload multiple images
  Future<List<String>> uploadImages(List<String> imagePaths) async {
    List<String> urls = [];
    for (var path in imagePaths) {
      final response = await cloudinary.upload(
        file: path,
        resourceType: CloudinaryResourceType.image,
      );
      urls.add(response.secureUrl!);
    }
    return urls;
  }
}
