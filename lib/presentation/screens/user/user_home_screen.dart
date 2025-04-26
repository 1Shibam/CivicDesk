import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/presentation/widgets/complaint_detail_screen.dart';
import 'package:complaints/providers/current_user_complaints_provider.dart';
import 'package:complaints/providers/current_user_provider.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final List<ComplaintModel> complaints = [];
  final String emptyProfile = 'https://i.imgur.com/PcvwDlW.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          elevation: 4,
          shadowColor: AppColors.darkest,
          title: Consumer(
            builder: (context, ref, child) {
              final userProvider = ref.watch(currentUserProvider);
              return userProvider.when(
                  data: (user) {
                    return Text(user.name, style: AppTextStyles.bold(20));
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        'No user',
                        style: AppTextStyles.bold(20),
                      ),
                    );
                  },
                  loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.darkPink,
                        ),
                      ));
            },
          ),
          backgroundColor: AppColors.darkBlueGrey,
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: AppColors.textColor,
                size: 32.sp,
              ),
              onPressed: () {
                context.push(RouterNames.notificationScreen);
              },
            ),
            SizedBox(
              width: 8.w,
            ),
            Consumer(
              builder: (context, ref, child) {
                final currentUser = ref.watch(currentUserProvider);
                return currentUser.when(
                    data: (user) {
                      String url = user.profileUrl == ''
                          ? emptyProfile
                          : user.profileUrl;
                      return GestureDetector(
                        onTap: () {
                          context.push(RouterNames.userProfile);
                        },
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundImage: CachedNetworkImageProvider(url),
                        ),
                      );
                    },
                    error: (error, stackTrace) => Center(
                          child: Text(
                            'Something went wrong',
                            style: AppTextStyles.bold(16),
                          ),
                        ),
                    loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.darkPink,
                          ),
                        ));
              },
            ),
            SizedBox(
              width: 8.w,
            )
          ],
        ),
      ),
      drawer: _userHomeScreenDrawer(context),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => context.push(RouterNames.complaintScreen),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkPinkAccent,
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.textColor,
                    child: Icon(Icons.file_present_rounded,
                        size: 24.sp, color: AppColors.darkPink),
                  ),
                  SizedBox(width: 12.w),
                  Text("File a Complaint", style: AppTextStyles.bold(16)),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      size: 24.sp, color: AppColors.textColor),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () => context.push(RouterNames.aiChatScreen),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkPinkAccent,
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.chat_bubble_rounded,
                        size: 24.sp, color: AppColors.darkPink),
                  ),
                  SizedBox(width: 12.w),
                  Text("Chat Help", style: AppTextStyles.bold(16)),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      size: 24.sp, color: AppColors.textColor),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            const Divider(
              color: AppColors.lightGrey,
              thickness: 2,
            ),
            SizedBox(height: 20.h),
            Text("My Recent Complaints",
                style: AppTextStyles.bold(18, color: AppColors.textColor)),
            SizedBox(height: 10.h),
            Consumer(
              builder: (context, ref, child) {
                final userComplaints = ref.watch(currentUserComplaintsProvider);
                return userComplaints.when(
                  data: (complaint) {
                    print(complaint.length);
                    return Expanded(
                      child: complaint.isEmpty
                          ? Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No Recent Complaints',
                                    style: AppTextStyles.regular(16),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.darkPinkAccent,
                                          elevation: 4,
                                          shadowColor: AppColors.darkest,
                                          foregroundColor: AppColors.textColor,
                                          overlayColor: AppColors.textColor),
                                      onPressed: () async {
                                        context
                                            .push(RouterNames.complaintScreen);
                                      },
                                      child: Text(
                                        'Make first Complaint',
                                        style: AppTextStyles.regular(16),
                                      ))
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: complaint.length,
                              itemBuilder: (context, index) {
                                final usercomplaint = complaint[index];
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ComplaintDetailScreen(
                                                    complaint: usercomplaint),
                                          ));
                                    },
                                    child: Card(
                                      color: Colors.transparent,
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.r)),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.r)),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 12.h),
                                        tileColor: AppColors.darkPinkAccent
                                            .withValues(alpha: 0.9),
                                        leading: Icon(
                                            Icons.report_problem_rounded,
                                            size: 32.sp,
                                            color: Colors.white),
                                        title: Text(
                                          usercomplaint.title,
                                          style: AppTextStyles.bold(16),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 6.h),
                                            Text(
                                                "Category: ${usercomplaint.category}",
                                                style:
                                                    AppTextStyles.medium(13)),
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  usercomplaint.status
                                                              .toLowerCase() ==
                                                          "resolved"
                                                      ? Icons.check_circle
                                                      : Icons.hourglass_top,
                                                  size: 16.sp,
                                                  color: usercomplaint.status
                                                              .toLowerCase() ==
                                                          "resolved"
                                                      ? Colors.green
                                                      : Colors.orange,
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                    "Status: ${usercomplaint.status}",
                                                    style: AppTextStyles.medium(
                                                        13)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: Icon(Icons.arrow_forward_ios,
                                            size: 16.sp, color: Colors.white),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ComplaintDetailScreen(
                                                      complaint: usercomplaint),
                                            ),
                                          );
                                        },
                                      ),
                                    ));
                              },
                            ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        'Error loading your complaints',
                        style: AppTextStyles.bold(20),
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkPink,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // void checkSpamExample() async {
  //   final spamChecker = SpamChecker(); // Don't forget to add your key

  //   final result = await spamChecker.checkSpam(
  //     title: 'i am having trouble shitting and my cheeks hurts',
  //     category: 'health',
  //     description: 'my ass cheeks are unable to produce the shits',
  //     imageData: ['balls', 'football'],
  //   );

  //   print('Is spam: $result');
  // }

  Drawer _userHomeScreenDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkBlueGrey,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkPinkAccent, AppColors.darkPink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35.r,
                  backgroundImage: const CachedNetworkImageProvider(
                    'https://i.imgur.com/PcvwDlW.png',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final user = ref.watch(currentUserProvider);
                      return user.when(
                          data: (data) {
                            return Text(
                              data.name,
                              style:
                                  AppTextStyles.bold(20, color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                          error: (error, stackTrace) {
                            return Text(
                              'NO user',
                              style: AppTextStyles.bold(20),
                            );
                          },
                          loading: () => const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.darkPink,
                                ),
                              ));
                    },
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded, color: AppColors.textColor),
            title: Text("Home", style: AppTextStyles.medium(16)),
            onTap: () => context.pop(),
          ),
          ListTile(
            leading: const Icon(Icons.info_rounded, color: AppColors.textColor),
            title: Text("About", style: AppTextStyles.medium(16)),
            onTap: () {
              context.push(RouterNames.aboutPage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline_rounded,
                color: AppColors.textColor),
            title: Text("Contact Us", style: AppTextStyles.medium(16)),
            onTap: () {
              context.push(RouterNames.contactUs);
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.article_rounded, color: AppColors.textColor),
            title: Text("Terms of Use", style: AppTextStyles.medium(16)),
            onTap: () {
              context.push(RouterNames.termsOfService);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded,
                color: AppColors.textColor),
            title: Text("Privacy Policy", style: AppTextStyles.medium(16)),
            onTap: () {
              context.push(RouterNames.privacyPolicy);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_rounded,
                color: AppColors.textColor),
            title: Text("Report a bug", style: AppTextStyles.medium(16)),
            onTap: () {
              context.push(RouterNames.reportBugPage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline_rounded,
                color: AppColors.textColor),
            title: Text("FAQ's", style: AppTextStyles.medium(16)),
            onTap: () {
              context.push(RouterNames.faqpage);
            },
          ),
        ],
      ),
    );
  }
}
