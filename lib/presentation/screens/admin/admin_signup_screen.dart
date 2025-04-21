import 'package:complaints/core/constants.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/services/firebase_auth_service.dart';
import 'package:complaints/services/firestore_services.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/widgets/custom_text_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AdminSignupScreen extends StatefulWidget {
  const AdminSignupScreen({super.key});

  @override
  State<AdminSignupScreen> createState() => _AdminSignupScreenState();
}

class _AdminSignupScreenState extends State<AdminSignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController adminKeyController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode adminKeyFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool agreeToTerms = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    adminKeyController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    adminKeyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
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
              children: [
                Text(
                  'Create Admin Account',
                  style: AppTextStyles.bold(32),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Sign up as an admin to manage complaints, ensure smooth workflow, and maintain platform integrity.',
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
                  validator: ValidationType.password,
                  focusNode: passwordFocusNode,
                ),
                SizedBox(height: 16.h),
                CustomTextFields(
                    labelText: 'Confirm Password',
                    prefixIcon: Icons.lock_outline,
                    controller: confirmPasswordController,
                    focusNode: confirmPasswordFocusNode,
                    validator: ValidationType.password),
                SizedBox(height: 16.h),
                CustomTextFields(
                  labelText: 'Admin Key',
                  prefixIcon: Icons.key,
                  controller: adminKeyController,
                  focusNode: adminKeyFocusNode,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Checkbox(
                      value: agreeToTerms,
                      onChanged: (val) {
                        setState(() {
                          agreeToTerms = val ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Show terms and conditions page or dialog
                        },
                        child: Text(
                          'I agree to the Terms and Conditions',
                          style: AppTextStyles.regular(14).copyWith(
                            decoration: TextDecoration.underline,
                            color: AppColors.darkPink,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Consumer(builder: (context, ref, child) {
                  return CustomButton(
                    imageUrl:
                        'asets/images/admin-with-cogwheels-svgrepo-com.svg',
                    buttonText: 'Sign Up',
                    onTap: () async {
                      if (!agreeToTerms) {
                        customSnackbar(
                          context: context,
                          message: 'You must agree to the Terms and Conditions',
                          iconName: Icons.warning,
                        );
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        try {
                          final isValid = await ref
                              .read(firestoreProvider)
                              .validateAdminPasskey(
                                  adminKeyController.text, context);

                          if (!isValid && context.mounted) {
                            customSnackbar(
                              context: context,
                              message: 'Invalid Admin Key',
                              iconName: Icons.error,
                            );
                            return;
                          }
                          if (!context.mounted) return;

                          final isCreated = await ref
                              .read(firebaseAuthServiceProvider)
                              .createAdminWithEmail(
                                emailController.text.trim().toLowerCase(),
                                passwordController.text.trim(),
                                context,
                              );

                          if (isCreated && context.mounted) {
                            context.go(RouterNames.adminProfileCreation);
                          }
                        } catch (e) {
                          debugPrint('Admin signup error: $e');
                        }
                      }
                    },
                  );
                }),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: AppTextStyles.regular(12),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: AppTextStyles.bold(12).copyWith(
                          color: AppColors.darkPink,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.go(RouterNames.adminLogin),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
