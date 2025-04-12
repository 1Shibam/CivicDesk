// open api chat service

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiChatService {
  final String apiKey = dotenv.env['CHAT_API_KEY'] ?? '';
}
