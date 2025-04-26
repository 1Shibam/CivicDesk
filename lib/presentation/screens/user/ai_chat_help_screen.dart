import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_Message> messages = [];

  // Change this to your own key
  final openAiApiKey = dotenv.env['CHAT_API_KEY'];

  final List<String> welcomeMessages = [
    "Hi! How can I help you today?",
    "Hello! What's the issue you're facing?",
    "Hey there! I'm Civik Desk Assistant, how may I assist you?",
    "Hi, I’m your Civik Desk helper. Need assistance?",
    "Greetings! What can I do for you today?"
  ];

  final Map<String, String> faqAnswers = {
    "How to file a complaint?":
        "To file a complaint, just tell me about your issue! I'll guide you step by step.",
    "Where can I track my complaint?":
        "You can track your complaint in the 'My Complaints' section of Civik Desk app.",
    "What complaints are allowed?":
        "We accept complaints related to services, infrastructure, delivery, billing, safety, and more!",
    "How do I upload evidence?":
        "After filing a complaint, you'll get an option to upload images or documents as evidence."
  };

  final List<String> pinnedFaqs = [
    "How to file a complaint?",
    "Where can I track my complaint?",
    "What complaints are allowed?",
    "How do I upload evidence?",
  ];

  StreamSubscription<String>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    final random = Random();
    messages.add(_Message(
      welcomeMessages[random.nextInt(welcomeMessages.length)],
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add user message
    setState(() {
      messages.add(_Message(text.trim(), isUser: true));
    });

    _controller.clear();

    // Check if it's a FAQ
    if (faqAnswers.containsKey(text.trim())) {
      _showFaqAnswer(text.trim());
    } else {
      _getBotResponse(text.trim());
    }
  }

  void _showFaqAnswer(String faq) {
    final answer = faqAnswers[faq]!;

    setState(() {
      messages.add(_Message(answer, isUser: false, animated: true));
    });
  }

  void _getBotResponse(String userInput) async {
    _streamSubscription?.cancel();

    final fullMessages = [
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
      },
      ...messages.map((e) => {
            "role": e.isUser ? "user" : "assistant",
            "content": e.text,
          })
    ];

    final request = http.Request(
        'POST', Uri.parse('https://api.openai.com/v1/chat/completions'))
      ..headers.addAll({
        'Authorization': 'Bearer $openAiApiKey',
        'Content-Type': 'application/json',
      })
      ..body = jsonEncode({
        "model": "gpt-3.5-turbo", // or gpt-3.5-turbo
        "messages": fullMessages,
        "stream": true,
        "temperature": 0.2,
      });

    final response = await request.send();

    if (response.statusCode == 200) {
      String buffer = '';
      setState(() {
        messages.add(_Message('', isUser: false, isStreaming: true));
      });

      int lastIndex = messages.length - 1;
      _streamSubscription =
          response.stream.transform(utf8.decoder).listen((chunk) {
        final lines = chunk.split('\n');
        for (var line in lines) {
          if (line.startsWith('data: ') && !line.contains('[DONE]')) {
            final jsonLine = line.substring(6);
            final decoded = jsonDecode(jsonLine);
            final content = decoded['choices'][0]['delta']['content'];
            if (content != null) {
              buffer += content.toString();
              setState(() {
                messages[lastIndex] =
                    messages[lastIndex].copyWith(text: buffer);
              });
            }
          }
        }
      });
    } else {
      throw Exception('Failed to get stream: ${response.statusCode}');
    }
  }

  void _onFaqTap(String faq) {
    _sendMessage(faq);
  }

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
                color: AppColors.lightGrey.withValues(alpha: 0.1),
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
                            : AppColors.lightGrey.withValues(alpha: 0.15),
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
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: msg.animated
                          ? AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [
                                TyperAnimatedText(
                                  msg.text,
                                  textStyle: AppTextStyles.medium(14,
                                      color: AppColors.textColor),
                                  speed: const Duration(milliseconds: 40),
                                ),
                              ],
                            )
                          : Text(
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
  final bool animated;
  final bool isStreaming;

  _Message(
    this.text, {
    required this.isUser,
    this.animated = false,
    this.isStreaming = false,
  });

  _Message copyWith({String? text}) {
    return _Message(
      text ?? this.text,
      isUser: isUser,
      animated: animated,
      isStreaming: isStreaming,
    );
  }
}
