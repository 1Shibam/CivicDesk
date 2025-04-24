import 'package:complaints/services/firebase_auth_service.dart';
import 'package:complaints/services/firestore_services.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/widgets/custom_text_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:complaints/core/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool hidePassword = true;
  bool hideAdminKey = true;

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
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_ios_new)),
        ),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  'Civik Desk \nAdmin Login',
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
                  nextFocusNode: adminKeyFocusNode,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: hidePassword
                            ? AppColors.lightGrey
                            : AppColors.textColor,
                      )),
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
                SizedBox(height: 24.h),
                Consumer(
                  builder: (context, ref, child) {
                    return CustomButton(
                      imageUrl:
                          'asets/images/admin-with-cogwheels-svgrepo-com.svg',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            final isValid = await ref
                                .read(firestoreProvider)
                                .validateAdminPasskey(
                                    adminKeyController.text, context);

                            if (!isValid && context.mounted) {
                              customSnackbar(
                                  message: 'Wrong admin key',
                                  context: context,
                                  iconName: Icons.error);
                              return;
                            }
                            if (!context.mounted) return;

                            final isCreated = await ref
                                .read(firebaseAuthServiceProvider)
                                .loginWithEmailAndPassword(
                                    emailController.text.trim().toLowerCase(),
                                    passwordController.text.trim(),
                                    context);

                            if (!isCreated || !context.mounted) return;

                            context.go(RouterNames.adminProfileCreation);
                          } catch (e) {
                            // optional: show a generic snackbar or log
                            debugPrint('Admin login error: $e');
                          }
                        }
                      },
                      buttonText: 'Login',
                    );
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: AppTextStyles.regular(16),
                      children: [
                        TextSpan(
                            text: 'Sign Up',
                            style: AppTextStyles.bold(16)
                                .copyWith(color: AppColors.darkPinkAccent),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => context.push(RouterNames.adminSignup))
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
