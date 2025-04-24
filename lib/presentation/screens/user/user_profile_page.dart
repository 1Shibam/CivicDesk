import 'package:complaints/presentation/widgets/all_profile_tile.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/presentation/widgets/profile_image_section.dart';
import 'package:complaints/providers/current_user_provider.dart';
import 'package:complaints/routes/router_names.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.clear,
                size: 40.sp,
                color: AppColors.textColor,
              )),
        ),
        body: Stack(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final userAsync = ref.watch(currentUserProvider);

                return userAsync.when(

                    // when data is available
                    data: (data) {
                      final userData = data;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 32.w),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //Image and and image edit section --
                              ProfileImageSection(
                                profileUrl: userData.profileUrl,
                                uid: userData.id,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),

                              SizedBox(
                                height: 16.h,
                              ),

                              //profile details tiles- name , username etc..
                              AllProfileTiles(
                                email: userData.email,
                                name: userData.name,
                                joinedAt: userData.joinedAt,
                                age: data.age,
                                occupation: data.occupation,
                              ),
                              SizedBox(
                                height: 24.h,
                              ),
                              CustomButton(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: AppColors.darkPink,
                                            title: Text('Logout !? ',
                                                style: AppTextStyles.bold(24)),
                                            content: Text(
                                              'Are you sure you want to logout?',
                                              style: AppTextStyles.regular(24),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context), // Cancel
                                                child: Text(
                                                  'Cancel',
                                                  style:
                                                      AppTextStyles.regular(20),
                                                ),
                                              ),
                                              Consumer(
                                                builder: (context, ref, child) {
                                                  return TextButton(
                                                    onPressed: () async {
                                                      await FirebaseAuth
                                                          .instance
                                                          .signOut();

                                                      if (context.mounted) {
                                                        context.go(
                                                            RouterNames.splash);
                                                      }
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      style:
                                                          AppTextStyles.regular(
                                                              20),
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  buttonText: 'Log out',
                                  imageUrl:
                                      'asets/images/logout-svgrepo-com.svg')
                            ],
                          ),
                        ),
                      );
                    },

                    //Errror state -
                    error: (error, stackTrace) => Center(
                          child: Text(
                            'Something went wrong',
                            style: AppTextStyles.medium(20),
                          ),
                        ),

                    //loading state -
                    loading: () => const CircularProgressIndicator());
              },
            ),
            if (isLoading) ...[
              Container(
                  color: AppColors.darkest.withValues(alpha: 0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkPink,
                    ),
                  ))
            ]
          ],
        ));
  }
}
