import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void streamChatGPT(List<Map<String, String>> messages) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  final request = http.Request('POST', url);
  final openAiApi = dotenv.env['CHAT_API_KEY'];

  request.headers.addAll({
    'Authorization': 'Bearer $openAiApi',
    'Content-Type': 'application/json',
  });

  request.body = jsonEncode({
    "model": "gpt-4",
    "stream": true,
    "messages": messages,
  });

  final streamedResponse = await request.send();

  streamedResponse.stream.transform(utf8.decoder).listen((chunk) {
    // Each chunk contains multiple data lines like: data: {...}
    final lines = chunk.split('\n');
    for (var line in lines) {
      if (line.startsWith('data: ') && !line.contains('[DONE]')) {
        final data = line.substring(6).trim();
        if (data.isNotEmpty) {
          final jsonData = json.decode(data);
          final delta = jsonData['choices'][0]['delta'];
          if (delta.containsKey('content')) {
            debugPrint(delta['content']); // Show token-by-token output
          }
        }
      }
    }
  });
}
