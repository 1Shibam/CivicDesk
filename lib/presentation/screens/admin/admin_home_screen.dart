import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  final List<ComplaintModel> primaryComplaints = [
    ComplaintModel(
      complaintId: '1',
      title: 'Water Leakage',
      description: 'There is a water leakage issue in the main pipe.',
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
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Primary Complaints' : 'Possible Spam',
          style: AppTextStyles.bold(20),
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.push(RouterNames.adminProfile);
              },
              icon: Icon(
                Icons.account_circle,
                size: 32.sp,
              ))
        ],
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
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
                context.push('/');
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
