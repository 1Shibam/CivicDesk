import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ComplaintAnalyzer {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  // List of valid categories
  static const List<String> validCategories = [
    'Billing',
    'Service',
    'Technical',
    'Product Quality',
    'Delivery',
    'Customer Support',
    'Infrastructure',
    'Cleanliness',
    'Safety',
    'Public Transport',
    'Water Supply',
    'Electricity',
    'Internet',
    'Noise Pollution',
    'Road Conditions',
    'Traffic Management',
    'Healthcare',
    'Waste Management',
    'Education',
    'Parking',
    'Environment',
    'Other'
  ];

  Future<Map<String, dynamic>> analyzeComplaint({
    required String description,
  }) async {
    final apiKey = dotenv.env['GEMENI_API'];
    if (apiKey == null || apiKey.isEmpty) {
      return _defaultResponse(description);
    }

    final prompt = '''
    Analyze this complaint description and return a structured JSON response.
    The response MUST contain exactly these fields:
    - title: A concise, 5-8 word summary of the complaint
    - category: Select from this exact list: ${validCategories.join(', ')}
    - other: Only include this field if category is "Other", with the specific category name
    - description: A well-written, grammatically correct version of the complaint that maintains the original meaning

    Respond ONLY with pure JSON format without any code block or extra text.
    Example response when category is in the list: {"title": "...", "category": "...", "description": "..."}
    Example response when category is not in the list: {"title": "...", "category": "Other", "other": "Specific Category", "description": "..."}

    Complaint to analyze:
    "$description"
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

          final result = jsonDecode(cleanedText) as Map<String, dynamic>;

          // Validate the category
          if (!validCategories.contains(result['category'])) {
            result['category'] = 'Other';
            result['other'] = result['category'] ?? 'Uncategorized';
          }

          return result;
        } catch (e) {
          return _defaultResponse(description);
        }
      } else {
        return _defaultResponse(description);
      }
    } catch (e) {
      return _defaultResponse(description);
    }
  }

  Map<String, dynamic> _defaultResponse(String description) {
    return {
      'title': 'Complaint Submission',
      'category': 'Other',
      'other': 'Uncategorized',
      'description': description,
    };
  }
}
