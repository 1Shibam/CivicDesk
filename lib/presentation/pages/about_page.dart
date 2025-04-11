import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:complaints/core/constants.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About CivikDesk', style: AppTextStyles.bold(20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App logo
            Center(
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.darkPinkAccent,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Icon(
                  Icons.campaign_outlined,
                  size: 60.sp,
                  color: AppColors.textColor,
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // App name and version
            Center(
              child: Column(
                children: [
                  Text('CivikDesk', style: AppTextStyles.bold(24)),
                  SizedBox(height: 8.h),
                  Text('Version 1.0.0',
                      style: AppTextStyles.regular(16,
                          color: AppColors.lightGrey)),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // App description
            Text('About', style: AppTextStyles.bold(20)),
            SizedBox(height: 12.h),
            Text(
              'CivikDesk App is designed to empower citizens to report issues in their communities, businesses, and public spaces. Our mission is to connect people with the authorities who can address these concerns efficiently.',
              style: AppTextStyles.regular(16),
            ),
            SizedBox(height: 24.h),

            // Key features
            Text('Key Features', style: AppTextStyles.bold(20)),
            SizedBox(height: 12.h),
            _buildFeatureItem(Icons.report_problem_outlined,
                'Submit complaints with location and images'),
            _buildFeatureItem(
                Icons.history, 'Track complaint status and resolution'),
            _buildFeatureItem(
                Icons.policy_outlined, 'Anonymous reporting option'),
            _buildFeatureItem(Icons.notifications_active_outlined,
                'Receive updates on your complaints'),
            _buildFeatureItem(
                Icons.people_outline, 'Connect with local authorities'),

            SizedBox(height: 24.h),

            // How it works
            Text('How It Works', style: AppTextStyles.bold(20)),
            SizedBox(height: 12.h),
            _buildNumberedItem(1, 'Create an account or sign in'),
            _buildNumberedItem(
                2, 'Submit your complaint with details and images'),
            _buildNumberedItem(
                3, 'Your complaint is directed to appropriate authorities'),
            _buildNumberedItem(4, 'Track the progress and resolution'),
            _buildNumberedItem(5, 'Rate your experience after resolution'),

            SizedBox(height: 32.h),

            // Developer info
            Center(
              child: Text(
                '© 2025 Complaints App. All rights reserved.',
                style: AppTextStyles.regular(14, color: AppColors.lightGrey),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.darkPinkAccent, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(text, style: AppTextStyles.regular(16)),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedItem(int number, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: const BoxDecoration(
              color: AppColors.darkPinkAccent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: AppTextStyles.bold(14),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(text, style: AppTextStyles.regular(16)),
          ),
        ],
      ),
    );
  }
}
