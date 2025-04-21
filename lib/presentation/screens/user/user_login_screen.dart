import 'package:complaints/core/constants.dart';
import 'package:complaints/widgets/circular_loader.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.h,
            ),
            Text(
              'Welcome to Complaint Portal',
              style: AppTextStyles.bold(32),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              'As a user, you can submit complaints, track their progress, and get notified when they are resolved. Sign up now to get started!',
              style: AppTextStyles.medium(18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            CustomButton(
              imageUrl: 'asets/images/google icon.svg',
              onTap: () async {
                ciruclarLoader(context);
                await FirebaseAuthServices().sigupWithGoogle(context);
                await Future.delayed(const Duration(seconds: 2));
                if (context.mounted) {
                  context.pop();
                }
                if (context.mounted) {
                  context.go(RouterNames.userProfileCreation);
                }
              },
              buttonText: 'Google Signup',
            ),
          ],
        ),
      ),
    );
  }
}
