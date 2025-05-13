import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SpamChecker {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<bool> checkSpam({
    required String title,
    required String category,
    required String description,
    required List<String> imageData,
  }) async {
    final apiKey = dotenv.env['GEMENI_API'];
    if (apiKey == null || apiKey.isEmpty) {
      return false;
    }

    final prompt = '''
    Analyze this report and determine if it's spam. 
    Respond ONLY with pure JSON format: {"isSpam": true|false} 
    without any code block or extra text.

    Spam indicators:
    - Trivial/non-serious complaints
    - Troll-like language
    - Obscene/vulgar content
    - Non-constructive reports
    - Personal issues that can be solved individually
    - be strict with the images as well but if the image data seem too off from the complaint title and description take into cosideration it may make mistake but ml model is labeling what is inside the image so the image cant be way too different hope you understand.

    Report to analyze:
    Title: "$title"
    Category: "$category"
    Description: "$description"
    Images: ${imageData.join(", ")}
    ''';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final generatedText = responseBody['candidates']?[0]['content']
                ?['parts']?[0]['text'] ??
            '';

        try {
          final cleanedText = generatedText
              .replaceAll('```json', '')
              .replaceAll('```', '')
              .trim();

          final result = jsonDecode(cleanedText);
          return result['isSpam'] == true;
        } catch (e) {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
