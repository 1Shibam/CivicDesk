import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/presentation/screens/user/resolved_complaints_posts.dart';
import 'package:complaints/presentation/widgets/complaint_detail_screen.dart';
import 'package:complaints/providers/current_user_complaints_provider.dart';
import 'package:complaints/providers/current_user_provider.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final List<ComplaintModel> complaints = [];
  final String emptyProfile = 'https://i.imgur.com/PcvwDlW.png';
  int _currentIndex = 0;
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Approved',
    'Resolved',
    'Rejected'
  ];
  final Map<String, int> _statusOrder = {
    'Resolved': 0,
    'Approved': 1,
    'Pending': 2,
    'Rejected': 3
  };
  // ignore: unused_element
  int _getStatusPriority(String status) {
    return _statusOrder[status] ?? 3; // Default to Rejected if unknown status
  }

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
      body:
          _currentIndex == 0 ? _buildHomeBody() : const ComplaintsPostsScreen(),
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
          // Inside _buildHomeBody's Column children, modify the Row with "My Recent Complaints":
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: AppColors.lightGrey.withValues(alpha: 0.2)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.history_rounded,
                    color: AppColors.textColor, size: 32.sp),
                Expanded(
                  child: Text(
                    "Recent Complaints",
                    style: AppTextStyles.bold(16, color: AppColors.textColor),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: AppColors.darkBlueGrey,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.darkPink),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        icon: Icon(Icons.filter_list_rounded,
                            size: 24.sp, color: AppColors.textColor),
                        borderRadius: BorderRadius.circular(12.r),
                        dropdownColor: AppColors.darkBlueGrey,
                        style: AppTextStyles.medium(14,
                            color: AppColors.textColor),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedFilter = newValue!;
                          });
                        },
                        items: _filterOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
            data: (complaints) {
              // Apply filtering
              List<ComplaintModel> filteredComplaints = _selectedFilter == 'All'
                  ? List.from(complaints)
                  : complaints
                      .where((c) =>
                          c.status.toLowerCase() ==
                          _selectedFilter.toLowerCase())
                      .toList();

              // Apply sorting
              filteredComplaints.sort((a, b) {
                return _statusOrder[a.status]!
                    .compareTo(_statusOrder[b.status]!);
              });

              return filteredComplaints.isEmpty
                  ? _buildEmptyComplaints()
                  : _buildComplaintsListView(filteredComplaints);
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
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      itemBuilder: (context, index) {
        final complaint = complaints[index];
        final isResolved = complaint.status.toLowerCase() == "resolved";
        final isRejected = complaint.status.toLowerCase() == "rejected";

        return Padding(
          padding: EdgeInsets.only(
            bottom: 16.h,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComplaintDetailScreen(
                    complaint: complaint,
                    isAdmin: false,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkBlueGrey,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with status
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isRejected
                          ? Colors.red.withValues(alpha: 0.2)
                          : isResolved
                              ? Colors.green.withValues(alpha: 0.2)
                              : AppColors.darkPink.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isRejected
                              ? Icons.block
                              : isResolved
                                  ? Icons.check_circle
                                  : Icons.access_time,
                          color: isRejected
                              ? Colors.red
                              : isResolved
                                  ? Colors.green
                                  : Colors.orange,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            complaint.status.toUpperCase(),
                            style: AppTextStyles.bold(
                              14,
                              color: isRejected
                                  ? Colors.red
                                  : isResolved
                                      ? Colors.green
                                      : Colors.orange,
                            ),
                          ),
                        ),
                        if (complaint.isSpam)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning,
                                    size: 14.sp, color: Colors.red),
                                SizedBox(width: 4.w),
                                Text("SPAM",
                                    style: AppTextStyles.bold(12,
                                        color: Colors.red)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Main content
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                complaint.title,
                                style: AppTextStyles.bold(18,
                                    color: AppColors.textColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        // Category and date
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.darkPink.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                complaint.category,
                                style: AppTextStyles.medium(12,
                                    color: AppColors.textColor),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.calendar_today,
                                size: 14.sp, color: AppColors.lightGrey),
                            SizedBox(width: 4.w),
                            Text(
                              DateFormat('MMM dd, yyyy')
                                  .format(complaint.submittedAt),
                              style: AppTextStyles.regular(12,
                                  color: AppColors.lightGrey),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Description preview
                        Text(
                          complaint.description,
                          style: AppTextStyles.regular(14,
                              color:
                                  AppColors.textColor.withValues(alpha: 0.8)),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 16.h),

                        // Footer with attachments and view button
                        Row(
                          children: [
                            // Attachment count
                            if (complaint.attachments.isNotEmpty)
                              Row(
                                children: [
                                  Icon(Icons.photo_library,
                                      size: 16.sp, color: AppColors.lightGrey),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "${complaint.attachments.length}",
                                    style: AppTextStyles.medium(12,
                                        color: AppColors.lightGrey),
                                  ),
                                  SizedBox(width: 12.w),
                                ],
                              ),

                            const Spacer(),

                            // View button
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.darkPink,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "View Details",
                                    style: AppTextStyles.medium(12,
                                        color: Colors.white),
                                  ),
                                  SizedBox(width: 4.w),
                                  Icon(Icons.arrow_forward,
                                      size: 14.sp, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
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
                    Consumer(
                      builder: (context, ref, child) {
                        final user = ref.watch(currentUserProvider);
                        return user.when(
                          data: (data) {
                            return Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2.w),
                              ),
                              child: CircleAvatar(
                                radius: 35.r,
                                backgroundImage: CachedNetworkImageProvider(
                                  data.profileUrl == ''
                                      ? 'https://i.imgur.com/PcvwDlW.png'
                                      : data.profileUrl,
                                ),
                              ),
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
