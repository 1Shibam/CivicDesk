import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/presentation/widgets/complaint_detail_screen.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String userName = "Hemant Singh"; // Replace with actual user data
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
      submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
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
      submittedAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
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
                Icons.notifications,
                color: AppColors.textColor,
                size: 32.sp,
              ),
              onPressed: () {
                context.push(RouterNames.notificationScreen);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: AppColors.textColor,
                size: 32.sp,
              ),
              onPressed: () {
                context.push(RouterNames.userProfile);
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
              decoration: BoxDecoration(
                  color: AppColors.darkPinkAccent.withOpacity(0.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: const CachedNetworkImageProvider(
                        'https://i.imgur.com/PcvwDlW.png',
                        maxHeight: 200,
                        maxWidth: 200),
                  ),
                  Text(userName, style: AppTextStyles.bold(20)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.textColor),
              title: Text("Home", style: AppTextStyles.medium(16)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.textColor),
              title: Text("About", style: AppTextStyles.medium(16)),
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
              onTap: () {
                context.push(RouterNames.complaintScreen);
              },
              contentPadding: EdgeInsets.all(16.r),
              title: Text(
                'File and Issue/Complaint',
                style: AppTextStyles.bold(20),
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
            Text("My Recent Complaints",
                style: AppTextStyles.bold(18, color: AppColors.textColor)),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: complaints.length, // Replace with complaint list
                itemBuilder: (context, index) {
                  final complaint = complaints[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ComplaintDetailScreen(complaint: complaint),
                          ));
                    },
                    child: Card(
                      color: AppColors.darkPinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          children: [
                            Icon(Icons.report_problem,
                                size: 40.sp, color: Colors.white),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    complaint.title,
                                    style: AppTextStyles.bold(16),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(Icons.category,
                                          size: 16.sp, color: Colors.white),
                                      SizedBox(width: 4.w),
                                      Text("Category: ${complaint.category}",
                                          style: AppTextStyles.medium(14)),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        complaint.status == "Resolved"
                                            ? Icons.check_circle
                                            : Icons.pending,
                                        size: 16.sp,
                                        color: complaint.status == "Resolved"
                                            ? Colors.green
                                            : Colors.yellow,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text("Status: ${complaint.status}",
                                          style: AppTextStyles.medium(14)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 16.sp, color: Colors.white),
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
