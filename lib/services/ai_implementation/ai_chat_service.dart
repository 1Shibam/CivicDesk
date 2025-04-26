import 'dart:convert';
import 'package:http/http.dart' as http;

class CivikDeskChatService {
  final String _apiKey;

  CivikDeskChatService(this._apiKey);

  static const String _endpoint = 'https://api.openai.com/v1/chat/completions';

  final List<Map<String, String>> _chatHistory = [
    {
      "role": "system",
      "content": '''
You are CivikBot, the official assistant of Civik Desk. 
Civik Desk is a complaint and issue submission platform for organizations, workplaces, or businesses, 
helping authorities identify and fix problems based on feedback.

Strict Rules:
- Only answer queries related to Civik Desk services.
- Politely refuse unrelated questions ("I'm sorry, I can only assist with Civik Desk related queries.").
- If user mentions filing a complaint in any way, guide them to describe their issue.
- Once they describe the issue, generate a formatted JSON like:
{"title": "", "description": "", "category": ""}

Available categories:
Billing, Service, Technical, Product Quality, Delivery, Customer Support, Infrastructure, Cleanliness, Safety,
Public Transport, Water Supply, Electricity, Internet, Noise Pollution, Road Conditions, Traffic Management, 
Healthcare, Waste Management, Education, Parking, Environment, Other.

If no category matches, use "Other".
Keep all responses concise, friendly, and helpful.
      '''
    }
  ];

  /// Sends a message to the CivikBot and streams the response.
  Stream<String> sendMessage(String userMessage) async* {
    _chatHistory.add({
      "role": "user",
      "content": userMessage,
    });

    final request = http.Request('POST', Uri.parse(_endpoint))
      ..headers.addAll({
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      })
      ..body = jsonEncode({
        "model": "gpt-4", // Or "gpt-3.5-turbo" if you want
        "messages": _chatHistory,
        "stream": true,
        "temperature": 0.2, // More strict/controlled
      });

    final response = await request.send();

    if (response.statusCode == 200) {
      final stream = response.stream.transform(utf8.decoder);
      await for (final chunk in stream) {
        final lines = chunk.split('\n');
        for (var line in lines) {
          if (line.startsWith('data: ') && !line.contains('[DONE]')) {
            final jsonLine = line.substring(6);
            final decoded = jsonDecode(jsonLine);
            final content = decoded['choices'][0]['delta']['content'];
            if (content != null) {
              yield content.toString();
            }
          }
        }
      }
    } else {
      throw Exception('Failed to get stream: ${response.statusCode}');
    }
  }
}
