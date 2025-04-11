import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_Message> messages = [];

  final List<String> welcomeMessages = [
    "Hi! How can I help you today?",
    "Hello! What's the issue you're facing?",
    "Hey there! I'm Civik Desk Assistant, how may I assist you?",
    "Hi, I’m your Civik Desk helper. Need assistance?",
    "Greetings! What can I do for you today?"
  ];

  final List<String> pinnedFaqs = [
    "How to file a complaint?",
    "Where can I track my complaint status?",
    "What type of complaints can I submit?",
  ];

  @override
  void initState() {
    super.initState();
    final random = Random();
    messages.add(_Message(
        welcomeMessages[random.nextInt(welcomeMessages.length)],
        isUser: false));
    for (var faq in pinnedFaqs) {
      messages.add(_Message("📌 $faq", isUser: false));
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      messages.add(_Message(text.trim(), isUser: true));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Help", style: AppTextStyles.bold(18)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                reverse: false,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return Align(
                    alignment: msg.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 10.h),
                      constraints: BoxConstraints(maxWidth: 280.w),
                      decoration: BoxDecoration(
                        color: msg.isUser
                            ? AppColors.darkPinkAccent
                            : AppColors.lightGrey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                          bottomLeft:
                              msg.isUser ? Radius.circular(16.r) : Radius.zero,
                          bottomRight:
                              msg.isUser ? Radius.zero : Radius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        msg.text,
                        style: AppTextStyles.medium(15,
                            color: AppColors.textColor),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: AppTextStyles.medium(15),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      suffixIcon: IconButton(
                        icon:
                            const Icon(Icons.send, color: AppColors.textColor),
                        onPressed: () => _sendMessage(_controller.text),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkPinkAccent,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.white),
                    onPressed: () {
                      // Handle voice input here lateron --
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;

  _Message(this.text, {required this.isUser});
}
