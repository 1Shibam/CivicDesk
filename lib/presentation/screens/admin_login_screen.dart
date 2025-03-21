import 'package:complaints/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:complaints/core/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 28.sp,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Admin Panel Login',
              style: AppTextStyles.bold(32),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              'As an admin, you can review, approve, or reject complaints. Manage user complaints efficiently and keep the platform running smoothly.',
              style: AppTextStyles.medium(18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            CustomButton(
              imageUrl: 'asets/images/admin-with-cogwheels-svgrepo-com.svg',
              onTap: () {},
              buttonText: 'Admin Login',
            ),
          ],
        ),
      ),
    );
  }
}
