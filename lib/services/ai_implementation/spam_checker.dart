import 'dart:convert';
import 'package:flutter/rendering.dart';
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
    final prompt = '''
    Act as a spam detection system for user reports. Analyze the following report data and 
    return ONLY a JSON object with "isSpam" boolean value. 

    Spam criteria:
    - Trivial/non-serious complaints (e.g., lost pen)
    - Troll-like language (e.g., "lmao", sarcasm)
    - Irrelevant image descriptions
    - Non-constructive complaints

    Examples of spam:
    Title: "my pen got lost"
    Description: "lmao you just believe that are you serious"
    Images: [laughing emoji]

    Input data to analyze:
    {
      "title": "$title",
      "category": "$category",
      "description": "$description",
      "image_data": ${jsonEncode(imageData)}
    }

    Respond ONLY with valid JSON format: {"isSpam": true|false}
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
        debugPrint(responseBody);
        final generatedText =
            responseBody['candidates'][0]['content']['parts'][0]['text'];
        final result = jsonDecode(generatedText);
        return result['isSpam'] ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking spam: $e');
      return false;
    }
  }
}
