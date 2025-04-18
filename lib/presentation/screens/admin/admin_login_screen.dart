import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/widgets/custom_text_fields.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController adminKeyController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode adminKeyFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    adminKeyFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    adminKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
          child: SingleChildScrollView(
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
                CustomTextFields(
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  controller: emailController,
                  validator: ValidationType.email,
                  focusNode: emailFocusNode,
                ),
                SizedBox(height: 16.h),
                CustomTextFields(
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  validator: ValidationType.password,
                ),
                SizedBox(height: 16.h),
                CustomTextFields(
                  labelText: 'Admin Key',
                  prefixIcon: Icons.key,
                  controller: adminKeyController,
                  focusNode: adminKeyFocusNode,
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  imageUrl: 'asets/images/admin-with-cogwheels-svgrepo-com.svg',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      await Future.delayed(const Duration(seconds: 2));
                      if (context.mounted) {
                        context.go(RouterNames.adminProfileCreation);
                      }
                    }
                  },
                  buttonText: 'Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
