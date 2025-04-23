import 'dart:math';

import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    "Where can I track my complaint?",
    "What complaints are allowed?",
    "How do I upload evidence?",
  ];

  @override
  void initState() {
    super.initState();
    final random = Random();
    messages.add(_Message(
        welcomeMessages[random.nextInt(welcomeMessages.length)],
        isUser: false));
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      messages.add(_Message(text.trim(), isUser: true));
    });
    _controller.clear();
    // You can hardcode responses based on questions here.
  }

  void _onFaqTap(String faq) {
    _sendMessage(faq);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat Help",
          style: AppTextStyles.bold(18),
        ),
        backgroundColor: AppColors.darkBlueGrey,
        shadowColor: AppColors.darkest,
        elevation: 2,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(height: 12.h),

            // 🔹 FAQ Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Quick Help", style: AppTextStyles.bold(16)),
                  SizedBox(height: 8.h),
                  ...pinnedFaqs.map((faq) => GestureDetector(
                        onTap: () => _onFaqTap(faq),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: ListTile(
                            leading: const Icon(
                              Icons.question_answer,
                              color: AppColors.textColor,
                              size: 24,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 12.w),
                            tileColor: AppColors.darkPinkAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            title: Text(faq, style: AppTextStyles.regular(14)),
                          ),
                        ),
                      )),
                ],
              ),
            ),

            // 🔹 Chat Messages
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 6.h),
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
                            : AppColors.lightGrey.withValues(alpha: .15),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          topRight: Radius.circular(16.r),
                          bottomLeft:
                              msg.isUser ? Radius.circular(16.r) : Radius.zero,
                          bottomRight:
                              msg.isUser ? Radius.zero : Radius.circular(16.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        msg.text,
                        style: AppTextStyles.medium(14,
                            color: AppColors.textColor),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10.h),

            // 🔹 Input Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: AppTextStyles.medium(14),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 14.h),
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
                      // add voice feature logic
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
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
