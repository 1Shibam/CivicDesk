import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  void _showNotificationDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.darkPinkAccent,
          title: Text('Complaint Submitted', style: AppTextStyles.bold(18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: Approved', style: AppTextStyles.medium(16)),
              const SizedBox(height: 8),
              Text('Submitted on: March 22, 2025',
                  style: AppTextStyles.medium(16)),
              const SizedBox(height: 8),
              Text('Title: Service Issue', style: AppTextStyles.medium(16)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close',
                  style: AppTextStyles.medium(16, color: AppColors.textColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',
            style: AppTextStyles.bold(20, color: AppColors.textColor)),
        backgroundColor: AppColors.darkBlueGrey,
        shadowColor: AppColors.darkest,
        elevation: 4,
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 24.sp,
            )),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            trailing: Icon(
              Icons.done,
              color: AppColors.textColor,
              size: 24.sp,
            ),
            title: Text('Thanks for submitting your complaint!',
                style: AppTextStyles.medium(16)),
            subtitle: Text('Tap to view details',
                style: AppTextStyles.regular(14,
                    color: AppColors.textColor.withValues(alpha: 0.8))),
            tileColor: AppColors.darkPinkAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r)),
            onTap: () => _showNotificationDetails(context),
          ),
        ],
      ),
      backgroundColor: AppColors.darkBlueGrey,
    );
  }
}
