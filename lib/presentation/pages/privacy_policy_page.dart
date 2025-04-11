import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:complaints/core/constants.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: AppTextStyles.bold(20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: AppTextStyles.bold(24),
            ),
            SizedBox(height: 8.h),
            Text(
              'Last Updated: April 10, 2025',
              style: AppTextStyles.regular(14, color: AppColors.lightGrey),
            ),
            SizedBox(height: 24.h),
            _buildSection(
              'Information We Collect',
              'We collect the following information to provide and improve our services:\n\n'
                  '• Personal information (name, email address, phone number)\n'
                  '• Location data for geotagging complaints\n'
                  '• Photos and media uploaded with complaints\n'
                  '• Device information and app usage statistics',
            ),
            _buildSection(
              'How We Use Your Information',
              'We use your information to:\n\n'
                  '• Process and route your complaints to appropriate authorities\n'
                  '• Communicate updates about your complaints\n'
                  '• Improve our services and user experience\n'
                  '• Analyze usage patterns to enhance app functionality',
            ),
            _buildSection(
              'Data Sharing and Disclosure',
              'We may share your information with:\n\n'
                  '• Local authorities and relevant government agencies to address your complaints\n'
                  '• Service providers who assist in operating our app\n'
                  '• Law enforcement when required by law\n\n'
                  'We will not sell your personal information to third parties.',
            ),
            _buildSection(
              'Data Security',
              'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
            ),
            _buildSection(
              'Your Rights',
              'You have the right to:\n\n'
                  '• Access your personal data\n'
                  '• Request correction of inaccurate data\n'
                  '• Request deletion of your data\n'
                  '• Opt out of certain data processing activities\n'
                  '• Download a copy of your data',
            ),
            _buildSection(
              'Anonymous Reporting',
              'Our app offers an anonymous reporting option. If you choose this option, we collect only the minimum information necessary to process your complaint without identifying you personally.',
            ),
            _buildSection(
              'Children\'s Privacy',
              'Our services are not directed to individuals under 13 years of age. We do not knowingly collect personal information from children under 13.',
            ),
            _buildSection(
              'Changes to This Policy',
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.',
            ),
            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at:\n\n'
                  'privacy@complaintsapp.com',
            ),
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
