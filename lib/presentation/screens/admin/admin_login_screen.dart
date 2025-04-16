import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/routes/router_names.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppColors.textColor,
                      )),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter your email' : null,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: AppColors.textColor,
                      )),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter your password' : null,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: adminKeyController,
                  decoration: const InputDecoration(
                      labelText: 'Admin Key',
                      prefixIcon: Icon(
                        Icons.key,
                        color: AppColors.textColor,
                      )),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter admin key' : null,
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  imageUrl: 'asets/images/admin-with-cogwheels-svgrepo-com.svg',
                  onTap: () async {
                    // if (formKey.currentState!.validate()) {
                    //   // Handle login logic
                    // }
                    await Future.delayed(const Duration(seconds: 2));
                    if (context.mounted) {
                      context.go(RouterNames.adminHome);
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
