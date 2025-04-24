import 'package:complaints/core/constants.dart';
import 'package:complaints/presentation/widgets/all_profile_tile.dart';
import 'package:complaints/providers/current_admin_provider.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/presentation/widgets/profile_image_section.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AdminProfilePage extends ConsumerWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAdmin = ref.watch(currentAdminProvider);

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
          child: currentAdmin.when(
            data: (adminData) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image and Image Edit Section
                    ProfileImageSection(
                      uid: adminData.uid,
                      profileUrl: adminData.profileUrl,
                    ),
                    SizedBox(height: 2.h),
                    // Joined Date
                    Text(
                      'Joined At: ${adminData.createdAt}',
                      style: AppTextStyles.regular(24),
                    ),
                    SizedBox(height: 16.h),
                    // Profile Details Tiles
                    AllProfileTiles(
                      email: adminData.email,
                      name: adminData.name,
                      joinedAt: adminData.createdAt,
                    ),
                    SizedBox(height: 24.h),
                    CustomButton(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: AppColors.darkPink,
                              title: Text('Logout !?',
                                  style: AppTextStyles.bold(24)),
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
              );
            },
            error: (error, stackTrace) {
              return const Center(
                child: Text('couldn\'t fetch admin details'),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.darkPink,
              ),
            ),
          )),
    );
  }
}
