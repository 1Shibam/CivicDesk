import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:complaints/core/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us', style: AppTextStyles.bold(20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.support_agent,
                size: 80.sp,
                color: AppColors.darkPinkAccent,
              ),
            ),
            SizedBox(height: 24.h),
            Center(
              child: Text(
                'We\'re Here to Help',
                style: AppTextStyles.bold(24),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                'Have questions or need assistance? Reach out to us.',
                style: AppTextStyles.regular(16),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32.h),
            _buildContactItem(
              context,
              Icons.email_outlined,
              'Email Us',
              'support@complaintsapp.com',
              () => _launchEmail('shivam55.dev@gmail.com',
                  'Question about Complaints App', ''),
            ),
            _buildContactItem(
              context,
              Icons.phone_outlined,
              'Call Us',
              '+1 (555) 123-4567',
              () => _launchPhone('+15551234567'),
            ),
            _buildContactItem(
              context,
              Icons.web_outlined,
              'Visit Our Website',
              'www.complaintsapp.com',
              () => _launchURL('https://www.complaintsapp.com'),
            ),
            SizedBox(height: 24.h),
            Text(
              'Office Address',
              style: AppTextStyles.bold(18),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: AppColors.darkBlueGrey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: AppColors.lightGrey.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complaints App Inc.',
                    style: AppTextStyles.medium(16),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '123 Main Street, Suite 456\nCity, State 12345\nUnited States',
                    style: AppTextStyles.regular(16),
                  ),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () =>
                        _launchMaps('123 Main Street, City, State 12345'),
                    child: Row(
                      children: [
                        Icon(Icons.map_outlined,
                            color: AppColors.darkPinkAccent, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'View on Map',
                          style: AppTextStyles.medium(16,
                              color: AppColors.darkPinkAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Business Hours',
              style: AppTextStyles.bold(18),
            ),
            SizedBox(height: 12.h),
            _buildBusinessHoursItem('Monday - Friday', '9:00 AM - 6:00 PM'),
            _buildBusinessHoursItem('Saturday', '10:00 AM - 4:00 PM'),
            _buildBusinessHoursItem('Sunday', 'Closed'),
            SizedBox(height: 32.h),
            Center(
              child: Text(
                'We typically respond to inquiries within 24 hours.',
                style: AppTextStyles.regular(14, color: AppColors.lightGrey),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: AppColors.darkBlueGrey.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12.r),
            border:
                Border.all(color: AppColors.lightGrey.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.darkPinkAccent, size: 28.sp),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bold(16)),
                  SizedBox(height: 4.h),
                  Text(subtitle, style: AppTextStyles.regular(14)),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios,
                  color: AppColors.lightGrey, size: 16.sp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessHoursItem(String day, String hours) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(day, style: AppTextStyles.medium(16)),
          ),
          Expanded(
            flex: 3,
            child: Text(hours, style: AppTextStyles.regular(16)),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email, String subject, String body) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchMaps(String address) async {
    final Uri mapsUri = Uri.parse('https://maps.google.com/?q=$address');

    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    }
  }
}
