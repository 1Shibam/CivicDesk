import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String userName = "User Name"; // Replace with actual user data
  final List<ComplaintModel> complaints = [
    ComplaintModel(
      complaintId: '1',
      title: 'Broken Street Light',
      description: 'The street light near my house is not working for a week.',
      category: 'Infrastructure',
      userId: 'user123',
      userName: 'John Doe',
      userEmail: 'johndoe@example.com',
      attachments: [],
      status: 'pending',
      isSpam: false,
      adminId: null,
      submittedAt: DateTime.now().subtract(Duration(days: 2)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
      userNotified: false,
      adminNotified: false,
    ),
    ComplaintModel(
      complaintId: '2',
      title: 'Garbage not collected',
      description: 'Garbage in our area has not been collected for 3 days.',
      category: 'Sanitation',
      userId: 'user456',
      userName: 'Jane Doe',
      userEmail: 'janedoe@example.com',
      attachments: [],
      status: 'in-progress',
      isSpam: false,
      adminId: null,
      submittedAt: DateTime.now().subtract(Duration(days: 5)),
      updatedAt: DateTime.now().subtract(Duration(days: 2)),
      userNotified: true,
      adminNotified: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          title: Text(userName, style: AppTextStyles.bold(24)),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: AppColors.textColor,
                size: 32.sp,
              ),
              onPressed: () {
                // Navigate to Profile Page
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.darkBlueGrey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.darkPink),
              child: Text(userName, style: AppTextStyles.bold(20)),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.textColor),
              title: Text("Home", style: AppTextStyles.medium(16)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.textColor),
              title: Text("Settings", style: AppTextStyles.medium(16)),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(16.r),
              title: Text(
                'File and Issue/Complaint',
                style: AppTextStyles.bold(20),
              ),
              subtitle: Text(
                'Enter necessary details about the situation and submit',
                style: AppTextStyles.regular(16),
              ),
              tileColor: AppColors.darkPink,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
              trailing: Icon(
                Icons.file_present,
                size: 52.sp,
                color: AppColors.textColor,
              ),
            ),
            SizedBox(height: 20.h),
            const Divider(
              color: AppColors.lightGrey,
              thickness: 2,
            ),
            SizedBox(height: 20.h),
            Text("Recent Complaints",
                style: AppTextStyles.bold(18, color: AppColors.textColor)),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: complaints.length, // Replace with complaint list
                itemBuilder: (context, index) {
                  final complaint = complaints[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(complaint.title,
                              style: AppTextStyles.bold(18)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Category: ${complaint.category}",
                                  style: AppTextStyles.medium(16)),
                              SizedBox(height: 8.h),
                              Text("Status: ${complaint.status}",
                                  style: AppTextStyles.medium(16)),
                              SizedBox(height: 8.h),
                              Text(complaint.description,
                                  style: AppTextStyles.regular(14)),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Close",
                                  style: AppTextStyles.medium(16,
                                      color: AppColors.darkPink)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Card(
                      color: AppColors.darkPinkAccent,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(complaint.title,
                                style: AppTextStyles.bold(16)),
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
          ],
        ),
      ),
    );
  }
}
