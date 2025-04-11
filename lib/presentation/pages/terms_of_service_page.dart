import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:complaints/core/constants.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of Service', style: AppTextStyles.bold(20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: AppTextStyles.bold(24),
            ),
            SizedBox(height: 8.h),
            Text(
              'Last Updated: April 10, 2025',
              style: AppTextStyles.regular(14, color: AppColors.lightGrey),
            ),
            SizedBox(height: 24.h),
            _buildSection('1. Agreement to Terms',
                'By accessing or using the Complaints App, you agree to be bound by these Terms of Service. If you do not agree to these terms, you may not access or use the app.'),
            _buildSection('2. Description of Service',
                'The Complaints App provides a platform for users to submit complaints about various issues to relevant authorities. We act as an intermediary between users and authorities, but do not guarantee resolution of complaints.'),
            _buildSection('3. User Registration',
                'To use certain features of the app, you must register for an account. You agree to provide accurate and complete information during registration and to keep your account credentials secure. You are responsible for all activities that occur under your account.'),
            _buildSection(
                '4. User Conduct',
                'You agree not to use the app to:\n\n'
                    '• Submit false, misleading, or fraudulent complaints\n'
                    '• Harass, intimidate, or threaten others\n'
                    '• Violate any applicable laws or regulations\n'
                    '• Infringe upon the rights of others\n'
                    '• Distribute malware or other harmful code\n'
                    '• Attempt to gain unauthorized access to the app or its systems'),
            _buildSection(
                '5. Content Submission',
                'By submitting content (including complaints, comments, photos, etc.), you grant us a non-exclusive, worldwide, royalty-free license to use, store, and display the content for the purpose of operating and improving the app. You retain ownership of your content.\n\n'
                    'You are solely responsible for the content you submit. We reserve the right to remove any content that violates these terms or that we deem inappropriate.'),
            _buildSection('6. Privacy',
                'Your use of the app is subject to our Privacy Policy, which governs our collection and use of your information.'),
            _buildSection('7. Intellectual Property',
                'The app, including its content, features, and functionality, is owned by Complaints App Inc. and is protected by copyright, trademark, and other intellectual property laws. You may not reproduce, distribute, modify, create derivative works of, publicly display, or publicly perform any portion of the app without our express written consent.'),
            _buildSection('8. Disclaimer of Warranties',
                'THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. WE DO NOT WARRANT THAT THE APP WILL BE UNINTERRUPTED OR ERROR-FREE, THAT DEFECTS WILL BE CORRECTED, OR THAT THE APP IS FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS.'),
            _buildSection('9. Limitation of Liability',
                'TO THE MAXIMUM EXTENT PERMITTED BY LAW, WE SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES ARISING OUT OF OR RELATING TO YOUR USE OF THE APP.'),
            _buildSection('10. Indemnification',
                'You agree to indemnify and hold harmless Complaints App Inc. and its officers, directors, employees, and agents from any claims, damages, losses, liabilities, and expenses (including attorneys\' fees) arising out of or relating to your use of the app or violation of these terms.'),
            _buildSection('11. Termination',
                'We may terminate or suspend your account and access to the app at any time, without prior notice or liability, for any reason, including if you violate these terms.'),
            _buildSection('12. Modifications to Terms',
                'We may modify these terms at any time by posting the revised terms on the app. Your continued use of the app after the posting of revised terms constitutes your acceptance of the changes.'),
            _buildSection('13. Governing Law',
                'These terms and your use of the app shall be governed by and construed in accordance with the laws of [Jurisdiction], without regard to its conflict of law provisions.'),
            _buildSection(
                '14. Contact Information',
                'If you have any questions about these terms, please contact us at:\n\n'
                    'legal@complaintsapp.com'),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bold(18),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: AppTextStyles.regular(16),
          ),
        ],
      ),
    );
  }
}
