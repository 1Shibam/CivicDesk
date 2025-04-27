import 'dart:async';
import 'dart:convert';
import 'package:complaints/core/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
  bool _showFAQs = true;

  final List<String> _faqs = [
    "How do I file a complaint?",
    "Track my complaint",
    "What happens after I submit?",
    "Contact support",
    "Report urgent issue"
  ];

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
      if (_showFAQs) {
        _showFAQs = false;
      }
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
              
              1. Help users file complaints by asking for necessary details (title, description, category), dont provide json format just give response like docs formatted.
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
      backgroundColor: AppColors.darkest,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlueGrey,
        elevation: 0,
        title: Text(
          "Civik Desk Assistant",
          style: AppTextStyles.bold(20),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 24.sp,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.textColor),
            onPressed: () {
              // Show help info dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.darkBlueGrey,
                  title:
                      Text('About Civik Desk', style: AppTextStyles.bold(18)),
                  content: Text(
                    'Civik Desk helps you submit and track complaints about public services and infrastructure issues.',
                    style: AppTextStyles.regular(14),
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK',
                          style: AppTextStyles.medium(14,
                              color: AppColors.darkPinkAccent)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          // FAQ Chips Section
          if (_showFAQs)
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: AppColors.darkBlueGrey.withValues(alpha: 0.7),
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.lightGrey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, bottom: 10.h),
                    child: Text(
                      "Frequently Asked Questions",
                      style: AppTextStyles.medium(16),
                    ),
                  ),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 10.h,
                    children: _faqs.map((faq) {
                      return InkWell(
                        onTap: () => _sendMessage(faq),
                        child: Chip(
                          backgroundColor: AppColors.darkBlueGrey,
                          side: const BorderSide(
                              color: AppColors.darkPinkAccent, width: 1),
                          label: Text(faq, style: AppTextStyles.regular(12)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Chat Messages
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.darkest,
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),
          ),

          // Typing indicator
          if (_isLoading)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Assistant is typing",
                    style:
                        AppTextStyles.regular(12, color: AppColors.lightGrey),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.darkPinkAccent,
                    ),
                  ),
                ],
              ),
            ),

          // Input Area
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.darkBlueGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: AppTextStyles.regular(14),
                    cursorColor: AppColors.darkPinkAccent,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle:
                          AppTextStyles.regular(14, color: AppColors.lightGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.darkest.withValues(alpha: 0.7),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  color: AppColors.lightGrey),
                              onPressed: () {
                                setState(() {
                                  _controller.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                    onSubmitted: _sendMessage,
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  decoration: BoxDecoration(
                    color: _controller.text.isEmpty
                        ? AppColors.lightGrey
                        : AppColors.darkPinkAccent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: AppColors.textColor,
                    ),
                    onPressed: _controller.text.isEmpty
                        ? null
                        : () => _sendMessage(_controller.text),
                  ),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            Container(
              width: 36.w,
              height: 36.h,
              decoration: const BoxDecoration(
                color: AppColors.successYellow,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.support_agent,
                  color: AppColors.textColor,
                  size: 20.w,
                ),
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 0.75.sw),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: msg.isUser
                    ? AppColors.darkPinkAccent
                    : AppColors.darkBlueGrey.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(18.r).copyWith(
                  bottomLeft:
                      msg.isUser ? Radius.circular(18.r) : Radius.circular(5.r),
                  bottomRight:
                      msg.isUser ? Radius.circular(5.r) : Radius.circular(18.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: msg.isUser
                  ? Text(
                      msg.text,
                      style: AppTextStyles.regular(14),
                    )
                  : _buildFormattedMessageContent(msg.text),
            ),
          ),
          if (msg.isUser) ...[
            SizedBox(width: 8.w),
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.darkPink.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: AppColors.textColor,
                  size: 20.w,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormattedMessageContent(String text) {
    // Check if message contains JSON to format it specially
    if (text.contains("{") && text.contains("}")) {
      // Try to identify JSON blocks
      final RegExp jsonPattern = RegExp(r'(\{(?:[^{}]|(?:\{[^{}]*\}))*\})');
      final matches = jsonPattern.allMatches(text);

      if (matches.isNotEmpty) {
        // If we have JSON, we'll display it with special formatting
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final part in _splitTextWithJson(text, jsonPattern))
              if (part.startsWith("{") && part.endsWith("}"))
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.darkest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color: AppColors.lightGrey.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    part,
                    style: AppTextStyles.regular(
                      12,
                      color: AppColors.textColor.withValues(alpha: 0.9),
                    ),
                  ),
                )
              else
                MarkdownBody(
                  data: part,
                  styleSheet: MarkdownStyleSheet(
                    p: AppTextStyles.regular(14),
                    strong: AppTextStyles.bold(14),
                    em: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14.sp,
                      color: AppColors.textColor,
                    ),
                    h1: AppTextStyles.bold(18),
                    h2: AppTextStyles.bold(16),
                    h3: AppTextStyles.bold(15),
                    listBullet: AppTextStyles.regular(14),
                  ),
                ),
          ],
        );
      }
    }

    // For regular text, just use Markdown
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        p: AppTextStyles.regular(14),
        strong: AppTextStyles.bold(14),
        em: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 14.sp,
          color: AppColors.textColor,
        ),
        h1: AppTextStyles.bold(18),
        h2: AppTextStyles.bold(16),
        h3: AppTextStyles.bold(15),
        listBullet: AppTextStyles.regular(14),
      ),
    );
  }

  List<String> _splitTextWithJson(String text, RegExp jsonPattern) {
    final List<String> parts = [];
    int lastEnd = 0;

    for (final match in jsonPattern.allMatches(text)) {
      // Add text before this JSON
      if (match.start > lastEnd) {
        parts.add(text.substring(lastEnd, match.start));
      }
      // Add the JSON itself
      parts.add(text.substring(match.start, match.end));
      lastEnd = match.end;
    }

    // Add any remaining text
    if (lastEnd < text.length) {
      parts.add(text.substring(lastEnd));
    }

    return parts;
  }
}

class Message {
  final String text;
  final bool isUser;

  const Message(this.text, {required this.isUser});
}
