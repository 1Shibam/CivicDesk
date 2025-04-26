import 'package:complaints/core/constants.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/services/firebase_auth/firebase_auth_service.dart';
import 'package:complaints/services/db_services/firestore_services.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/widgets/custom_text_fields.dart';
import 'package:firebase_core/firebase_core.dart';
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
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool hideAdminKey = true;

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
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new)),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    'Create Admin Account',
                    style: AppTextStyles.bold(28),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Sign up as an admin to manage Civik Desk complaints and issues submitted by users, ensure smooth workflow, and maintain platform integrity.',
                    style: AppTextStyles.medium(18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  CustomTextFields(
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    controller: emailController,
                    validator: ValidationType.email,
                    focusNode: emailFocusNode,
                    nextFocusNode: passwordFocusNode,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFields(
                    labelText: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: hidePassword,
                    controller: passwordController,
                    validator: ValidationType.password,
                    focusNode: passwordFocusNode,
                    nextFocusNode: confirmPasswordFocusNode,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: hidePassword
                              ? AppColors.lightGrey
                              : AppColors.textColor,
                        )),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFields(
                    labelText: 'Confirm Password',
                    prefixIcon: Icons.lock,
                    obscureText: hideConfirmPassword,
                    controller: confirmPasswordController,
                    focusNode: confirmPasswordFocusNode,
                    nextFocusNode: adminKeyFocusNode,
                    validator: ValidationType.password,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hideConfirmPassword = !hideConfirmPassword;
                        });
                      },
                      icon: Icon(
                        hideConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: hideConfirmPassword
                            ? AppColors.lightGrey
                            : AppColors.textColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextFields(
                    labelText: 'Admin Key',
                    prefixIcon: Icons.key,
                    obscureText: hideAdminKey,
                    controller: adminKeyController,
                    focusNode: adminKeyFocusNode,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hideAdminKey = !hideAdminKey;
                        });
                      },
                      icon: Icon(
                        hideAdminKey ? Icons.visibility_off : Icons.visibility,
                        color: hideAdminKey
                            ? AppColors.lightGrey
                            : AppColors.textColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Checkbox(
                        activeColor: AppColors.darkPinkAccent,
                        checkColor: AppColors.textColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        side: const BorderSide(
                          color: AppColors.textColor,
                          width: 1,
                        ),
                        value: agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            agreeToTerms = value ?? false;
                          });
                        },
                      ),
                      SizedBox(
                          width: 12.w), // spacing between checkbox and text
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to all the ',
                            style: AppTextStyles.regular(16),
                            children: [
                              TextSpan(
                                text: 'terms and conditions',
                                style: AppTextStyles.bold(16).copyWith(
                                  color: const Color.fromARGB(255, 205, 51, 69)
                                      .withValues(),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        backgroundColor: AppColors.darkBlueGrey,
                                        title: Text(
                                          'Terms & Conditions',
                                          style: AppTextStyles.bold(20),
                                        ),
                                        content: SingleChildScrollView(
                                          child: Text(
                                            'By signing up as an admin on Civik Desk, you agree to handle user data responsibly, '
                                            'take necessary actions on complaints, maintain the integrity of the platform, and follow all '
                                            'legal and ethical guidelines set forth by the organization.',
                                            style: AppTextStyles.regular(14),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text(
                                              'Close',
                                              style: TextStyle(
                                                color: AppColors.darkPinkAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                              ),
                              TextSpan(
                                text: ' related to Civik Desk.',
                                style: AppTextStyles.regular(16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Consumer(builder: (context, ref, child) {
                    return CustomButton(
                      imageUrl:
                          'asets/images/admin-with-cogwheels-svgrepo-com.svg',
                      buttonText: 'Sign Up',
                      onTap: () async {
                        if (!agreeToTerms) {
                          customSnackbar(
                            context: context,
                            message:
                                'You must agree to the Terms and Conditions',
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
                          } on FirebaseException catch (e) {
                            if (context.mounted) {
                              customSnackbar(
                                  message: e.message.toString(),
                                  context: context,
                                  iconName: Icons.error);
                            }
                            debugPrint('Admin signup error: $e');
                          }
                        }
                      },
                    );
                  }),
                  SizedBox(
                    height: 16.h,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: AppTextStyles.regular(16),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: AppTextStyles.bold(16).copyWith(
                            color: AppColors.darkPinkAccent,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.pop(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
