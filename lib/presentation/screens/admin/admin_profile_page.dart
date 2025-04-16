import 'package:complaints/core/constants.dart';
import 'package:complaints/models/user_mode.dart';
import 'package:complaints/presentation/widgets/all_profile_tile.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/presentation/widgets/profile_image_section.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample admin data (Replace with actual provider later)
    final adminData = UserModel(
        id: '101',
        name: 'Hemant',
        role: 'Admin',
        email: 'hrs12345678@gmail.com',
        profileUrl: '',
        joinedAt: DateTime.now().toIso8601String().split('T')[0]);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.clear,
            size: 40.sp,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image and Image Edit Section
              ProfileImageSection(userData: adminData),
              SizedBox(height: 2.h),
              // Joined Date
              Text(
                'Joined At: ${adminData.joinedAt}',
                style: AppTextStyles.regular(24),
              ),
              SizedBox(height: 16.h),
              // Profile Details Tiles
              AllProfileTiles(userData: adminData),
              SizedBox(height: 24.h),
              CustomButton(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: AppColors.darkPink,
                        title: Text('Logout !?', style: AppTextStyles.bold(24)),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: AppTextStyles.regular(24),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.regular(20),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              // await FirebaseAuth.instance.signOut();
                              if (context.mounted) {
                                context.go(RouterNames.splash);
                              }
                            },
                            child: Text(
                              'Yes',
                              style: AppTextStyles.regular(20),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                buttonText: 'Log out',
                imageUrl: 'asets/images/logout-svgrepo-com.svg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
