import 'package:complaints/models/user_model.dart';
import 'package:complaints/presentation/widgets/all_profile_tile.dart';

import 'package:complaints/presentation/widgets/profile_image_section.dart';
import 'package:complaints/providers/current_user_provider.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isLoading = false;
  final String emptyProfile = 'https://i.imgur.com/PcvwDlW.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlueGrey,
        elevation: 4,
        shadowColor: AppColors.darkest,
        title: Text("My Profile", style: AppTextStyles.bold(20)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 24.sp,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final userAsync = ref.watch(currentUserProvider);

              return userAsync.when(
                // when data is available
                data: (userData) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        // Header with background gradient
                        _buildProfileHeader(userData),

                        // Profile details section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),

                              // Profile Statistics Card
                              _buildProfileStatsCard(userData),

                              SizedBox(height: 24.h),

                              // Personal Information Section
                              _buildSectionHeader("Personal Information"),
                              SizedBox(height: 12.h),
                              AllProfileTiles(
                                email: userData.email,
                                name: userData.name,
                                joinedAt: userData.joinedAt,
                                age: userData.age,
                                occupation: userData.occupation,
                              ),

                              SizedBox(height: 24.h),

                              // Account Actions Section

                              // Logout Button
                              // _buildLogoutButton(context),
                              CustomButton(
                                  onTap: () async {
                                    setState(() => isLoading = true);
                                    await FirebaseAuth.instance.signOut();
                                    setState(() => isLoading = false);

                                    if (context.mounted) {
                                      context.go(RouterNames.splash);
                                    }
                                  },
                                  buttonText: 'Log Out',
                                  imageUrl:
                                      'asets/images/logout-svgrepo-com.svg'),

                              SizedBox(height: 40.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },

                //Error state
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 64.sp,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Something went wrong',
                        style: AppTextStyles.medium(20),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          // ignore: unused_result
                          ref.refresh(currentUserProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkPink,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text("Retry", style: AppTextStyles.medium(16)),
                      ),
                    ],
                  ),
                ),

                //Loading state
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.darkPink),
                ),
              );
            },
          ),
          if (isLoading)
            Container(
              color: AppColors.darkest.withValues(alpha: 0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.darkPink,
                  strokeWidth: 3.w,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserModel userData) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.darkPinkAccent, AppColors.darkPink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkest.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 30.h),
          // Profile Image Section with enhanced styling
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ProfileImageSection(
              profileUrl: userData.profileUrl.isEmpty
                  ? emptyProfile
                  : userData.profileUrl,
              uid: userData.id,
            ),
          ),
          SizedBox(height: 16.h),
          // User name
          Text(
            userData.name,
            style: AppTextStyles.bold(24, color: Colors.white),
          ),
          SizedBox(height: 8.h),
          // User email
          Text(
            obscureEmail(userData.email),
            style: AppTextStyles.regular(16,
                color: Colors.white.withValues(alpha: 0.9)),
          ),
          // User occupation if available
          if (userData.occupation.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                userData.occupation,
                style: AppTextStyles.medium(14,
                    color: Colors.white.withValues(alpha: 0.8)),
              ),
            ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildProfileStatsCard(UserModel user) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.darkBlueGrey,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkest.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(user.totalComplaints.toString(), "Complaints"),
          _buildVerticalDivider(),
          _buildStatItem(user.resolvedComplaints.toString(), "Resolved"),
          _buildVerticalDivider(),
          _buildStatItem(user.pendingComplaints.toString(), "Pending"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: AppTextStyles.bold(24, color: AppColors.darkPink),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: AppTextStyles.medium(14, color: AppColors.lightGrey),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40.h,
      width: 1,
      color: AppColors.lightGrey.withValues(alpha: 0.3),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.bold(18, color: AppColors.textColor),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.lightGrey.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  // Widget _buildLogoutButton(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [Colors.redAccent, Colors.red],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       borderRadius: BorderRadius.circular(16.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.red.withValues(alpha: 0.3),
  //           blurRadius: 8,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Material(
  //       color: Colors.transparent,
  //       child: InkWell(
  //         onTap: () => _showLogoutDialog(context),
  //         borderRadius: BorderRadius.circular(16.r),
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(vertical: 16.h),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(Icons.logout_rounded, color: Colors.white, size: 24.sp),
  //               SizedBox(width: 12.w),
  //               Text(
  //                 "Log Out",
  //                 style: AppTextStyles.bold(18, color: Colors.white),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
