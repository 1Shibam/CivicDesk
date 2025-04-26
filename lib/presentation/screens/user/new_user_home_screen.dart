import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/presentation/widgets/complaint_detail_screen.dart';
import 'package:complaints/providers/current_user_provider.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NewUserHomeScreen extends StatefulWidget {
  const NewUserHomeScreen({super.key});

  @override
  State<NewUserHomeScreen> createState() => _NewUserHomeScreenState();
}

class _NewUserHomeScreenState extends State<NewUserHomeScreen> {
  final List<ComplaintModel> complaints = [];
  final String emptyProfile = 'https://i.imgur.com/PcvwDlW.png';
  int _selectedIndex = 0;

  // Pages for bottom navigation
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.add(_buildHomeContent());
    _pages.add(_buildPostsContent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _userHomeScreenDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => context.push(RouterNames.complaintScreen),
              backgroundColor: AppColors.darkPink,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.h),
      child: AppBar(
        elevation: 4,
        shadowColor: AppColors.darkest,
        title: Consumer(
          builder: (context, ref, child) {
            final userProvider = ref.watch(currentUserProvider);
            return userProvider.when(
              data: (user) {
                String title =
                    _selectedIndex == 0 ? user.name : "Resolved Issues";
                return Text(title, style: AppTextStyles.bold(20));
              },
              error: (error, stackTrace) {
                return Text('No user', style: AppTextStyles.bold(20));
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.darkPink),
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
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage: CachedNetworkImageProvider(url),
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Text('Error', style: AppTextStyles.bold(16)),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: CircularProgressIndicator(color: AppColors.darkPink),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkest.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.darkBlueGrey,
          selectedItemColor: AppColors.darkPink,
          unselectedItemColor: AppColors.textColor.withValues(alpha: 0.6),
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 24.sp),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_rounded, size: 24.sp),
              label: 'Posts',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickAccessCards(),
          SizedBox(height: 20.h),
          _buildSectionDivider("My Recent Complaints"),
          Expanded(
            child: _buildComplaintsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCards() {
    return Column(
      children: [
        _buildActionCard(
          title: "File a Complaint",
          icon: Icons.file_present_rounded,
          onTap: () => context.push(RouterNames.complaintScreen),
          gradient: const LinearGradient(
            colors: [AppColors.darkPinkAccent, AppColors.darkPink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        SizedBox(height: 12.h),
        _buildActionCard(
          title: "Chat Help",
          icon: Icons.chat_bubble_rounded,
          onTap: () => context.push(RouterNames.aiChatScreen),
          gradient: const LinearGradient(
            colors: [AppColors.darkPinkAccent, Color(0xFF7B2869)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkest.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.white,
                  child: Icon(icon, size: 24.sp, color: AppColors.darkPink),
                ),
                SizedBox(width: 16.w),
                Text(title, style: AppTextStyles.bold(18, color: Colors.white)),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 20.sp, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.lightGrey, thickness: 1.5),
        SizedBox(height: 16.h),
        Text(
          title,
          style: AppTextStyles.bold(20, color: AppColors.textColor),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildComplaintsList() {
    return complaints.isEmpty
        ? _buildEmptyState(
            message: 'No Recent Complaints',
            buttonText: 'Make First Complaint',
            onPressed: () => context.push(RouterNames.complaintScreen),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              return _buildComplaintCard(complaint);
            },
          );
  }

  Widget _buildComplaintCard(ComplaintModel complaint) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
        boxShadow: [
          BoxShadow(
            color: AppColors.darkest.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ComplaintDetailScreen(complaint: complaint),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      radius: 22.r,
                      child: Icon(
                        Icons.report_problem_rounded,
                        size: 24.sp,
                        color: AppColors.darkPink,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        complaint.title,
                        style: AppTextStyles.bold(18, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category: ${complaint.category}",
                        style: AppTextStyles.medium(15,
                            color: Colors.white.withValues(alpha: 0.9)),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: complaint.status.toLowerCase() == "resolved"
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              complaint.status.toLowerCase() == "resolved"
                                  ? Icons.check_circle
                                  : Icons.hourglass_top,
                              size: 16.sp,
                              color:
                                  complaint.status.toLowerCase() == "resolved"
                                      ? Colors.green
                                      : Colors.orange,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              complaint.status,
                              style: AppTextStyles.medium(
                                14,
                                color:
                                    complaint.status.toLowerCase() == "resolved"
                                        ? Colors.green
                                        : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 80.sp,
            color: AppColors.lightGrey,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: AppTextStyles.medium(18, color: AppColors.lightGrey),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkPink,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 4,
            ),
            child: Text(
              buttonText,
              style: AppTextStyles.bold(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsContent() {
    // Sample resolved complaints for demonstration
    final List<Map<String, dynamic>> resolvedPosts = [];

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionDivider("Resolved Issues"),
          Expanded(
            child: resolvedPosts.isEmpty
                ? _buildEmptyState(
                    message: 'No Resolved Issues Yet',
                    buttonText: 'Refresh',
                    onPressed: () {
                      setState(() {
                        // Refresh logic here
                      });
                    },
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: resolvedPosts.length,
                    itemBuilder: (context, index) {
                      final post = resolvedPosts[index];
                      return _buildResolvedPostCard(post);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResolvedPostCard(Map<String, dynamic> post) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.green, Color(0xFF1E9060)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 8.w),
                Text(
                  "RESOLVED",
                  style: AppTextStyles.bold(16, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'] ?? "Issue Title",
                  style: AppTextStyles.bold(18),
                ),
                SizedBox(height: 8.h),
                Text(
                  post['category'] ?? "Category",
                  style: AppTextStyles.medium(14, color: AppColors.lightGrey),
                ),
                SizedBox(height: 12.h),
                Text(
                  post['description'] ?? "Issue description goes here...",
                  style: AppTextStyles.regular(16),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Resolved on: ${post['resolvedDate'] ?? 'Today'}",
                      style:
                          AppTextStyles.regular(14, color: AppColors.lightGrey),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 20.sp,
                          color: AppColors.lightGrey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${post['likes'] ?? '0'}",
                          style: AppTextStyles.medium(14,
                              color: AppColors.lightGrey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Consumer(
      builder: (context, ref, child) {
        final userProvider = ref.watch(currentUserProvider);
        return userProvider.when(
          data: (user) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkPink.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60.r,
                      backgroundColor: AppColors.darkPink,
                      backgroundImage: CachedNetworkImageProvider(
                        user.profileUrl == '' ? emptyProfile : user.profileUrl,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    user.name,
                    style: AppTextStyles.bold(24),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    user.email,
                    style:
                        AppTextStyles.regular(16, color: AppColors.lightGrey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  _buildProfileStatsCard(user),
                  SizedBox(height: 24.h),
                  _buildProfileActionButtons(),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child:
                Text('Error loading profile', style: AppTextStyles.medium(18)),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.darkPink),
          ),
        );
      },
    );
  }

  Widget _buildProfileStatsCard(dynamic user) {
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
          _buildStatItem(complaints.length.toString(), "Complaints"),
          _buildVerticalDivider(),
          _buildStatItem(
              complaints
                  .where((c) => c.status.toLowerCase() == "resolved")
                  .length
                  .toString(),
              "Resolved"),
          _buildVerticalDivider(),
          _buildStatItem(
              complaints
                  .where((c) => c.status.toLowerCase() == "pending")
                  .length
                  .toString(),
              "Pending"),
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

  Widget _buildProfileActionButtons() {
    return Column(
      children: [
        _buildProfileButton(
          label: "Edit Profile",
          icon: Icons.edit,
          onTap: () => context.push(RouterNames.userProfile),
        ),
        SizedBox(height: 12.h),
        _buildProfileButton(
          label: "My Complaints",
          icon: Icons.list_alt,
          onTap: () {},
        ),
        SizedBox(height: 12.h),
        _buildProfileButton(
          label: "Settings",
          icon: Icons.settings,
          onTap: () {},
        ),
        SizedBox(height: 12.h),
        _buildProfileButton(
          label: "Log Out",
          icon: Icons.logout,
          onTap: () {},
          isLogout: true,
        ),
      ],
    );
  }

  Widget _buildProfileButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: isLogout
            ? const LinearGradient(
                colors: [Colors.redAccent, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [AppColors.darkPinkAccent, AppColors.darkPink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isLogout
                ? Colors.red.withValues(alpha: 0.3)
                : AppColors.darkPink.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24.sp),
                SizedBox(width: 16.w),
                Text(label,
                    style: AppTextStyles.medium(16, color: Colors.white)),
                const Spacer(),
                Icon(Icons.chevron_right, color: Colors.white, size: 24.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Drawer _userHomeScreenDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkBlueGrey,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(currentUserProvider);
              return user.when(
                data: (data) {
                  return DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.darkPinkAccent, AppColors.darkPink],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 35.r,
                            backgroundImage: CachedNetworkImageProvider(
                              data.profileUrl == ''
                                  ? emptyProfile
                                  : data.profileUrl,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.name,
                                style:
                                    AppTextStyles.bold(20, color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                data.email,
                                style: AppTextStyles.regular(14,
                                    color: Colors.white.withValues(alpha: 0.8)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return DrawerHeader(
                    decoration: const BoxDecoration(color: AppColors.darkPink),
                    child: Text('Error loading user',
                        style: AppTextStyles.bold(20)),
                  );
                },
                loading: () => DrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.darkPink),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.home_rounded,
            title: "Home",
            onTap: () {
              setState(() => _selectedIndex = 0);
              context.pop();
            },
          ),
          _buildDrawerItem(
            icon: Icons.article_rounded,
            title: "Posts",
            onTap: () {
              setState(() => _selectedIndex = 1);
              context.pop();
            },
          ),
          _buildDrawerItem(
            icon: Icons.person_rounded,
            title: "Profile",
            onTap: () {
              setState(() => _selectedIndex = 2);
              context.pop();
            },
          ),
          const Divider(color: AppColors.lightGrey, thickness: 0.5),
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
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textColor, size: 24.sp),
      title: Text(title, style: AppTextStyles.medium(16)),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
    );
  }
}
