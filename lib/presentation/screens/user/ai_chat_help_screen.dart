import 'dart:async';
import 'dart:convert';
import 'package:complaints/core/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> messages = [];
  final ScrollController _scrollController = ScrollController();
  final _groqApiKey =
      dotenv.env['GROQ_API_KEY']; // Replace with your actual key
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    setState(() {
      messages.add(const Message(
        "Hello! I'm your Civik Desk assistant. How can I help you today?",
        isUser: false,
      ));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add(Message(text.trim(), isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();
    _controller.clear();

    _getAiResponse(text.trim());
  }

  Future<void> _getAiResponse(String userInput) async {
    try {
      final response = await http
          .post(
            Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_groqApiKey',
            },
            body: jsonEncode({
              'model': 'llama3-70b-8192',
              'messages': [
                {
                  'role': 'system',
                  'content': '''
              You are an AI assistant for the Civik Desk app, which is a platform for submitting and tracking 
              complaints/issues about public services and infrastructure. Your role is to:
              
              1. Help users file complaints by asking for necessary details (title, description, category, location)
              2. Explain how to track existing complaints
              3. Provide information about complaint statuses and workflows
              4. Answer general questions about the platform
              
              When a user wants to file a complaint, guide them through the process and then return 
              a properly formatted JSON structure with all complaint details.
              
              For all responses, be concise, professional, and helpful.
              '''
                },
                {'role': 'user', 'content': userInput}
              ],
              'temperature': 0.9,
              'max_tokens': 500,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final aiResponse = responseData['choices'][0]['message']['content'];

        setState(() {
          messages.add(Message(aiResponse, isUser: false));
          _isLoading = false;
        });
        _scrollToBottom();
      } else {
        _showError('Failed to get response from server');
      }
    } catch (e) {
      _showError('Connection error. Please try again.');
    }
  }

  void _showError(String message) {
    setState(() {
      messages.add(Message(message, isUser: false));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Civik Desk Assistant",
          style: AppTextStyles.bold(20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                SizedBox(width: 8.w),
                _isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(_controller.text),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message msg) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Align(
        alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: msg.isUser
                ? AppColors.darkPinkAccent
                : AppColors.lightGrey.withValues(alpha: 0.4),
            borderRadius: msg.isUser
                ? BorderRadius.circular(12.r).copyWith(topRight: Radius.zero)
                : BorderRadius.circular(12.r).copyWith(topLeft: Radius.zero),
          ),
          child: Text(msg.text, style: AppTextStyles.regular(14)),
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  const Message(this.text, {required this.isUser});
}
