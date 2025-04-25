import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/presentation/widgets/complaint_detail_screen.dart';
import 'package:complaints/providers/current_admin_provider.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  final String emptyProfile = 'https://i.imgur.com/PcvwDlW.png';

  final List<ComplaintModel> primaryComplaints = [
    ComplaintModel(
      complaintId: '1',
      title: 'Water Leakage',
      description:
          'There is a water leakage issue in the main pipe. all the people living around there went missing rumors says they drowned in that water ',
      category: 'Infrastructure',
      userId: 'user789',
      userName: 'Alice Johnson',
      userEmail: 'alice@example.com',
      attachments: [],
      status: 'pending',
      isSpam: false,
      adminId: 'admin123',
      submittedAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      userNotified: false,
      adminNotified: false,
    ),
  ];

  final List<ComplaintModel> spamComplaints = [
    ComplaintModel(
      complaintId: '2',
      title: 'Fake Report',
      description: 'This report seems to be spam.',
      category: 'Other',
      userId: 'user111',
      userName: 'Unknown',
      userEmail: 'unknown@example.com',
      attachments: [],
      status: 'review',
      isSpam: true,
      adminId: 'admin123',
      submittedAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      userNotified: false,
      adminNotified: false,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
              final adminProvider = ref.watch(currentAdminProvider);
              return adminProvider.when(
                  data: (admin) {
                    return Text(admin.name, style: AppTextStyles.bold(20));
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
                final currentUser = ref.watch(currentAdminProvider);
                return currentUser.when(
                    data: (admin) {
                      String url = admin.profileUrl == ''
                          ? emptyProfile
                          : admin.profileUrl;
                      return GestureDetector(
                        onTap: () {
                          context.push(RouterNames.adminProfile);
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
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView.builder(
          itemCount: _selectedIndex == 0
              ? primaryComplaints.length
              : spamComplaints.length,
          itemBuilder: (context, index) {
            final complaint = _selectedIndex == 0
                ? primaryComplaints[index]
                : spamComplaints[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ComplaintDetailScreen(complaint: complaint)));
              },
              child: Card(
                color: AppColors.darkPinkAccent,
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(complaint.title, style: AppTextStyles.bold(16)),
                      SizedBox(height: 4.h),
                      Text("Category: ${complaint.category}",
                          style: AppTextStyles.medium(14)),
                      SizedBox(height: 4.h),
                      Text("Status: ${complaint.status}",
                          style: AppTextStyles.medium(14)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.darkBlueGrey,
        selectedItemColor: AppColors.darkPink,
        unselectedItemColor: AppColors.lightGrey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Primary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Spam',
          ),
        ],
      ),
    );
  }
}
