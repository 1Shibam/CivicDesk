import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';

class AdminComplaintDetailScreen extends StatelessWidget {
  const AdminComplaintDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Details',
            style: AppTextStyles.bold(20, color: AppColors.textColor)),
        backgroundColor: AppColors.darkPink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Submitted by: Hemant Singh', style: AppTextStyles.medium(16)),
            const SizedBox(height: 8),
            Text('Submitted on: March 22, 2025',
                style: AppTextStyles.medium(16)),
            const SizedBox(height: 8),
            Text('Title: Service Issue', style: AppTextStyles.medium(16)),
            const SizedBox(height: 8),
            Text('Description:', style: AppTextStyles.medium(16)),
            Text('The service was delayed and the response time was slow.',
                style: AppTextStyles.regular(16, color: AppColors.lightGrey)),
            const SizedBox(height: 16),
            Text('Attachments:', style: AppTextStyles.medium(16)),
            // Placeholder for attachments
            Container(
              height: 100,
              color: AppColors.lightGrey.withValues(alpha:0.3),
              child: Center(
                  child:
                      Text('No attachments', style: AppTextStyles.regular(14))),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkPink,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Approve Complaint',
                    style: AppTextStyles.bold(16, color: AppColors.textColor)),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.darkBlueGrey,
    );
  }
}
