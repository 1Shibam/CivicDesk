import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String confirmText;
  final VoidCallback onConfirmPressed;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onConfirmPressed,
    this.confirmText = 'Confirm',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkBlueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      title: Text(
        title,
        style: AppTextStyles.bold(18),
      ),
      content: Text(
        subtitle,
        style: AppTextStyles.regular(16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: AppTextStyles.medium(14, color: AppColors.lightGrey),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkPink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          onPressed: () {
            Navigator.pop(context); // close dialog first
            onConfirmPressed(); // then execute main action
          },
          child: Text(
            confirmText,
            style: AppTextStyles.medium(14),
          ),
        ),
      ],
    );
  }
}
