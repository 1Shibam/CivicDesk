import 'package:complaints/core/constants.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/services/firestore_services.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/widgets/custom_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CreateAdminProfile extends StatefulWidget {
  const CreateAdminProfile({super.key});

  @override
  State<CreateAdminProfile> createState() => _CreateAdminProfileState();
}

class _CreateAdminProfileState extends State<CreateAdminProfile> {
  final TextEditingController _fullNameController = TextEditingController();
  final FocusNode _fullNameFocus = FocusNode();

  String? selectedDepartment;
  String? selectedPost;

  final List<String> departments = ['IT', 'HR', 'Finance', 'Maintenance'];
  final List<String> posts = ['Head', 'Manager', 'Staff'];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with the first department and post as default values
  }

  void _submitAdminProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final email = FirebaseAuth.instance.currentUser?.email;

    if (_fullNameController.text.isEmpty ||
        uid == null ||
        email == null ||
        selectedDepartment == null ||
        selectedPost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Create the admin profile in Firestore
    FirestoreServices().createAdminProfile(
        name: _fullNameController.text.trim(),
        department: selectedDepartment!,
        post: selectedPost!);

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      customSnackbar(
        message: 'Profile creation successful',
        context: context,
        iconName: Icons.check,
        bgColor: Colors.green,
      );
    }
    if (mounted) {
      context.go(RouterNames.adminHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                context.go(RouterNames.splash);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      backgroundColor: AppColors.darkest,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.darkBlueGrey,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create Admin Profile',
                  style: AppTextStyles.bold(22),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                    'Make sure you fill correct information, You can\'t change it later',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular(16)),
                SizedBox(height: 24.h),
                CustomTextFields(
                  labelText: 'Full Name',
                  prefixIcon: Icons.person,
                  controller: _fullNameController,
                  focusNode: _fullNameFocus,
                ),
                SizedBox(height: 20.h),
                DropdownButtonFormField<String>(
                  borderRadius: BorderRadius.circular(20.r),
                  decoration: InputDecoration(
                    fillColor: AppColors.textColor,
                    filled: true,
                    hintText: 'Select Department',
                    alignLabelWithHint: true,
                    hintStyle: AppTextStyles.regular(16)
                        .copyWith(color: AppColors.darkest),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.textColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.textColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  dropdownColor: AppColors.lightGrey,
                  elevation: 4,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.darkest,
                  ),
                  iconSize: 28.sp,
                  value: selectedDepartment,
                  items: departments
                      .map((dep) => DropdownMenuItem(
                            value: dep,
                            child: Text(dep, style: AppTextStyles.regular(16)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      if (val != null) {
                        selectedDepartment = val;
                      }
                    });
                  },
                ),
                SizedBox(height: 20.h),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    fillColor: AppColors.textColor,
                    filled: true,
                    hintText: 'Select Post',
                    hintStyle: AppTextStyles.regular(16)
                        .copyWith(color: AppColors.darkest),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.textColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.textColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  dropdownColor: AppColors.lightGrey,
                  elevation: 4,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.darkest,
                  ),
                  iconSize: 28.sp,
                  value: selectedPost,
                  items: posts
                      .map((post) => DropdownMenuItem(
                            value: post,
                            child: Text(post, style: AppTextStyles.regular(16)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      if (val != null) {
                        selectedPost = val;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(20.r),
                ),
                SizedBox(height: 30.h),
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onTap: _submitAdminProfile,
                        buttonText: 'Submit',
                        imageUrl: 'asets/images/send-alt-1-svgrepo-com.svg')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
