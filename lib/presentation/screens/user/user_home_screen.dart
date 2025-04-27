import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/presentation/widgets/complaint_detail_screen.dart';
import 'package:complaints/providers/current_user_complaints_provider.dart';
import 'package:complaints/providers/current_user_provider.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int _currentIndex = 0;

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
                  return Text(
                    user.name,
                    style: AppTextStyles.bold(20),
                    overflow: TextOverflow.ellipsis,
                  );
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
                ),
              );
            },
          ),
          backgroundColor: AppColors.darkBlueGrey,
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: AppColors.textColor,
                size: 28.sp,
              ),
              onPressed: () {
                context.push(RouterNames.notificationScreen);
              },
            ),
            SizedBox(width: 8.w),
            Consumer(
              builder: (context, ref, child) {
                final currentUser = ref.watch(currentUserProvider);
                return currentUser.when(
                  data: (user) {
                    String url =
                        user.profileUrl == '' ? emptyProfile : user.profileUrl;
                    return GestureDetector(
                      onTap: () {
                        context.push(RouterNames.userProfile);
                      },
                      child: Hero(
                        tag: 'profile-avatar',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.darkPink,
                              width: 2.w,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 18.r,
                            backgroundImage: CachedNetworkImageProvider(url),
                          ),
                        ),
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
                  ),
                );
              },
            ),
            SizedBox(width: 12.w),
          ],
        ),
      ),
      drawer: _userHomeScreenDrawer(context),
      body: _currentIndex == 0 ? _buildHomeBody() : _buildPostsPlaceholder(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.darkest.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.darkBlueGrey,
          selectedItemColor: AppColors.darkPink,
          unselectedItemColor: AppColors.lightGrey,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTextStyles.bold(14),
          unselectedLabelStyle: AppTextStyles.medium(12),
          elevation: 8,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_rounded),
              label: 'Posts',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_rounded,
            size: 80.sp,
            color: AppColors.darkPink.withValues(alpha: 0.7),
          ),
          SizedBox(height: 16.h),
          Text(
            'Posts Placeholder',
            style: AppTextStyles.bold(24, color: AppColors.textColor),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              'This section will contain posts in the future',
              textAlign: TextAlign.center,
              style: AppTextStyles.medium(16, color: AppColors.lightGrey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeBody() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionButtons(),
          SizedBox(height: 20.h),
          const Divider(
            color: AppColors.lightGrey,
            thickness: 1.5,
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Icon(Icons.history_rounded,
                  color: AppColors.darkPink, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                "My Recent Complaints",
                style: AppTextStyles.bold(18, color: AppColors.textColor),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildComplaintsList(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Card(
          elevation: 5,
          shadowColor: AppColors.darkest.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () => context.push(RouterNames.complaintScreen),
            splashColor: AppColors.darkPink.withValues(alpha: 0.3),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.darkPinkAccent, AppColors.darkPink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.textColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkest.withValues(alpha: 0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.file_present_rounded,
                        size: 28.sp, color: AppColors.darkPink),
                  ),
                  SizedBox(width: 16.w),
                  Text("File a Complaint",
                      style: AppTextStyles.bold(18, color: Colors.white)),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward_ios,
                        size: 18.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Card(
          elevation: 5,
          shadowColor: AppColors.darkest.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () => context.push(RouterNames.aiChatScreen),
            splashColor: AppColors.darkPink.withValues(alpha: 0.3),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.darkPinkAccent.withValues(alpha: 0.9),
                    AppColors.darkPink.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkest.withValues(alpha: 0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.chat_bubble_rounded,
                        size: 28.sp, color: AppColors.darkPink),
                  ),
                  SizedBox(width: 16.w),
                  Text("Chat Help",
                      style: AppTextStyles.bold(18, color: Colors.white)),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward_ios,
                        size: 18.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComplaintsList() {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final userComplaints = ref.watch(currentUserComplaintsProvider);
          return userComplaints.when(
            data: (complaint) {
              print(complaint.length);
              return complaint.isEmpty
                  ? _buildEmptyComplaints()
                  : _buildComplaintsListView(complaint);
            },
            error: (error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: AppColors.darkPink, size: 48.sp),
                    SizedBox(height: 16.h),
                    Text(
                      'Error loading your complaints',
                      style: AppTextStyles.bold(16),
                    ),
                    SizedBox(height: 8.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkPink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        ref.refresh(currentUserComplaintsProvider);
                      },
                      child: Text('Retry', style: AppTextStyles.medium(14)),
                    ),
                  ],
                ),
              );
            },
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.darkPink,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading your complaints...',
                    style: AppTextStyles.medium(14, color: AppColors.lightGrey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyComplaints() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 64.sp,
            color: AppColors.lightGrey.withValues(alpha: 0.6),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Recent Complaints',
            style: AppTextStyles.bold(18, color: AppColors.lightGrey),
          ),
          SizedBox(height: 12.h),
          ElevatedButton.icon(
            icon: Icon(Icons.add_circle_outline, size: 20.sp),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkPink,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 4,
              shadowColor: AppColors.darkest,
            ),
            onPressed: () {
              context.push(RouterNames.complaintScreen);
            },
            label: Text(
              'Make Your First Complaint',
              style: AppTextStyles.medium(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintsListView(List<ComplaintModel> complaints) {
    return ListView.builder(
      itemCount: complaints.length,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 16.h),
      itemBuilder: (context, index) {
        final userComplaint = complaints[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Card(
            elevation: 6,
            shadowColor: AppColors.darkest.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComplaintDetailScreen(
                      complaint: userComplaint,
                      isAdmin: false,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.darkPinkAccent.withValues(alpha: 0.9),
                      AppColors.darkPink.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.report_problem_rounded,
                            size: 24.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            userComplaint.title,
                            style: AppTextStyles.bold(16, color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                userComplaint.status.toLowerCase() == "resolved"
                                    ? Colors.green.withValues(alpha: 0.2)
                                    : Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                userComplaint.status.toLowerCase() == "resolved"
                                    ? Icons.check_circle
                                    : Icons.hourglass_top,
                                size: 14.sp,
                                color: userComplaint.status.toLowerCase() ==
                                        "resolved"
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                userComplaint.status,
                                style: AppTextStyles.medium(
                                  12,
                                  color: userComplaint.status.toLowerCase() ==
                                          "resolved"
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "Category: ${userComplaint.category}",
                        style: AppTextStyles.medium(13, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Drawer _userHomeScreenDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkBlueGrey,
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.darkPinkAccent, AppColors.darkPink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.w),
                      ),
                      child: CircleAvatar(
                        radius: 35.r,
                        backgroundImage: const CachedNetworkImageProvider(
                          'https://i.imgur.com/PcvwDlW.png',
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final user = ref.watch(currentUserProvider);
                          return user.when(
                            data: (data) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name,
                                    style: AppTextStyles.bold(
                                      20,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'View Profile',
                                    style: AppTextStyles.regular(
                                      14,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
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
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              children: [
                _buildDrawerItem(
                  icon: Icons.home_rounded,
                  title: "Home",
                  onTap: () => context.pop(),
                ),
                _buildDrawerItem(
                  icon: Icons.info_rounded,
                  title: "About",
                  onTap: () {
                    context.push(RouterNames.aboutPage);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.mail_outline_rounded,
                  title: "Contact Us",
                  onTap: () {
                    context.push(RouterNames.contactUs);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.article_rounded,
                  title: "Terms of Use",
                  onTap: () {
                    context.push(RouterNames.termsOfService);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.lock_outline_rounded,
                  title: "Privacy Policy",
                  onTap: () {
                    context.push(RouterNames.privacyPolicy);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.bug_report_rounded,
                  title: "Report a bug",
                  onTap: () {
                    context.push(RouterNames.reportBugPage);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline_rounded,
                  title: "FAQ's",
                  onTap: () {
                    context.push(RouterNames.faqpage);
                  },
                ),
              ],
            ),
          ),
          Divider(
              height: 1.h, color: AppColors.lightGrey.withValues(alpha: 0.3)),
          _buildDrawerItem(
            icon: Icons.logout_rounded,
            title: "Logout",
            onTap: () {
              // Add logout functionality here
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.darkBlueGrey,
                  title: Text(
                    'Logout',
                    style: AppTextStyles.bold(18),
                  ),
                  content: Text(
                    'Are you sure you want to logout?',
                    style: AppTextStyles.regular(16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.medium(14,
                            color: AppColors.lightGrey),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkPink,
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        context.go(RouterNames.splash);
                      },
                      child: Text(
                        'Logout',
                        style: AppTextStyles.medium(14),
                      ),
                    ),
                  ],
                ),
              );
            },
            textColor: AppColors.darkPink,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.textColor, size: 24.sp),
      title: Text(
        title,
        style:
            AppTextStyles.medium(16, color: textColor ?? AppColors.textColor),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      minLeadingWidth: 24.w,
      horizontalTitleGap: 12.w,
    );
  }
}
