import 'package:complaints/core/constants.dart';
import 'package:complaints/widgets/circular_loader.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/services/firebase_auth/firebase_auth_service.dart';
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to \nCivik Desk',
              style: AppTextStyles.bold(32),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              'As a user, you can submit complaints, track their progress, and get notified when they are resolved. Login now to get started!',
              style: AppTextStyles.medium(18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            CustomButton(
              imageUrl: 'asets/images/google icon.svg',
              onTap: () async {
                ciruclarLoader(context);
                await FirebaseAuthServices().signupWithGoogle(context);
                await Future.delayed(const Duration(seconds: 1));
                if (context.mounted) {
                  context.pop();
                }
              },
              buttonText: 'Google Login',
            ),
          ],
        ),
      ),
    );
  }
}
