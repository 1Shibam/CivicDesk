import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:complaints/core/constants.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'What types of complaints can I submit?',
      answer:
          'You can submit complaints about infrastructure issues, public services, business practices, safety concerns, and other matters that affect your community. If you\'re unsure whether your concern is appropriate for our app, you can always contact us for guidance.',
    ),
    FAQItem(
      question: 'Is my complaint anonymous?',
      answer:
          'By default, your basic information is included with your complaint to help authorities address the issue. However, we offer an anonymous reporting option if you prefer not to share your identity. Note that anonymous complaints may sometimes be more difficult for authorities to follow up on.',
    ),
    FAQItem(
      question: 'How long will it take for my complaint to be addressed?',
      answer:
          'Resolution times vary depending on the nature of the complaint, the responsible authority, and current workloads. Our app provides status updates as your complaint progresses through the system. Most complaints receive an initial assessment within 48-72 hours.',
    ),
    FAQItem(
      question: 'Can I track the status of my complaint?',
      answer:
          'Yes, you can track your complaint\'s status through the app. You\'ll receive notifications when there are updates, and you can view detailed progress in the "My Complaints" section.',
    ),
    FAQItem(
      question: 'Who receives my complaint?',
      answer:
          'Your complaint is directed to the appropriate authority based on its nature and location. This could be local government departments, business management, regulatory agencies, or other relevant organizations. Our system identifies the correct recipient to ensure your concern reaches the right people.',
    ),
    FAQItem(
      question: 'Can I add photos or videos to my complaint?',
      answer:
          'Yes, you can attach photos and videos to provide visual evidence of the issue you\'re reporting. This can help authorities better understand and address your concern.',
    ),
    FAQItem(
      question: 'What if I need to edit or update my complaint?',
      answer:
          'You can edit your complaint within 24 hours of submission. After that, you can add comments or additional information, but the original complaint details cannot be modified to maintain record integrity.',
    ),
    FAQItem(
      question: 'Is there a limit to how many complaints I can submit?',
      answer:
          'There is no strict limit, but we encourage responsible use of the platform. If you need to report multiple issues, please submit them as separate complaints to ensure each is properly tracked and addressed.',
    ),
    FAQItem(
      question: 'What happens if my complaint is rejected?',
      answer:
          'If your complaint is rejected, you\'ll receive an explanation. Common reasons include insufficient information, inappropriate content, or the issue falling outside the jurisdiction of available authorities. You can revise and resubmit if applicable.',
    ),
    FAQItem(
      question: 'Do I need to create an account to submit a complaint?',
      answer:
          'Yes, a basic account is required to submit and track complaints. This helps ensure accountability and allows us to provide you with updates. However, you can choose to remain anonymous to the authorities receiving your complaint.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Frequently Asked Questions', style: AppTextStyles.bold(20)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.sp),
            child: TextField(
              style: AppTextStyles.regular(16),
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onChanged: (value) {
                // Implement search functionality if needed
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.sp),
              itemCount: _faqItems.length,
              itemBuilder: (context, index) {
                return _buildFAQItem(_faqItems[index]);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: Text(
              'Still have questions? Contact our support team.',
              style: AppTextStyles.medium(14, color: AppColors.lightGrey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.darkBlueGrey.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: .3)),
      ),
      child: ExpansionTile(
        title: Text(
          item.question,
          style: AppTextStyles.medium(16),
        ),
        iconColor: AppColors.darkPinkAccent,
        collapsedIconColor: AppColors.textColor,
        childrenPadding: EdgeInsets.all(16.sp),
        children: [
          Text(
            item.answer,
            style: AppTextStyles.regular(14),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
