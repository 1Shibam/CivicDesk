import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComplaintDetailScreen extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintDetailScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Complaint Details",
        style: AppTextStyles.bold(24),
      )),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(complaint.title, style: AppTextStyles.bold(24)),
            SizedBox(height: 8.h),
            // Row(
            //   children: [
            //     Icon(Icons.category, size: 20.sp),
            //     SizedBox(width: 8.w),
            //     Text("Category: ${complaint.category}",
            //         style: AppTextStyles.medium(18)),
            //   ],
            // ),
            ListTile(
              title: Text("Category: ", style: AppTextStyles.medium(24)),
              subtitle:
                  Text(complaint.category, style: AppTextStyles.regular(20)),
              trailing: Icon(
                Icons.category,
                size: 32.sp,
                color: AppColors.textColor,
              ),
            ),
            ListTile(
              title: Text("Status: ", style: AppTextStyles.medium(24)),
              subtitle:
                  Text(complaint.status, style: AppTextStyles.regular(20)),
              trailing: Icon(
                complaint.status == "Resolved"
                    ? Icons.check_circle
                    : Icons.pending,
                size: 32.sp,
                color: complaint.status == "Resolved"
                    ? Colors.green
                    : Colors.yellow,
              ),
            ),
            ListTile(
              title: Text("Description: ",
                  style: AppTextStyles.medium(
                    24,
                  )),
              subtitle:
                  Text(complaint.description, style: AppTextStyles.regular(20)),
              trailing: Icon(
                Icons.description,
                size: 32.sp,
                color: AppColors.textColor,
              ),
            ),
            ListTile(
              title: Text("Attachments: ",
                  style: AppTextStyles.medium(
                    24,
                  )),
              trailing: Icon(
                Icons.description,
                size: 32.sp,
                color: AppColors.textColor,
              ),
            ),
            Expanded(
                child: ListView(
              children: [
                Image.asset(
                  'asets/images/light.png',
                  width: double.infinity,
                  height: 200.h,
                ),
              ],
            )),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
