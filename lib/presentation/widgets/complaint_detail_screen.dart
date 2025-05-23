import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/presentation/screens/admin/upload_as_post_screen.dart';
import 'package:complaints/presentation/widgets/full_screen_image_view.dart';
import 'package:complaints/services/db_services/complaint_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ComplaintDetailScreen extends StatelessWidget {
  final ComplaintModel complaint;
  final bool isAdmin;

  const ComplaintDetailScreen(
      {super.key, required this.complaint, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    const String emptyProfile = 'https://i.imgur.com/PcvwDlW.png';
    return Scaffold(
      backgroundColor: AppColors.darkest,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlueGrey,
        shadowColor: AppColors.darkest,
        elevation: 4,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 22.sp,
            color: AppColors.textColor,
          ),
        ),
        title: Text(
          "Complaint Detail",
          style: AppTextStyles.bold(22),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 28.r,
                    backgroundColor: AppColors.darkBlueGrey,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: complaint.userProfileUrl ?? emptyProfile,
                        fit: BoxFit.cover,
                        width: 56.r,
                        height: 56.r,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(
                          color: AppColors.textColor,
                          strokeWidth: 2,
                        ),
                        errorWidget: (context, url, error) =>
                            CachedNetworkImage(
                          imageUrl: emptyProfile,
                          fit: BoxFit.cover,
                          width: 56.r,
                          height: 56.r,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isAdmin ? complaint.userName : 'By You',
                        style: AppTextStyles.bold(18),
                      ),
                      SizedBox(height: 4.h),
                      isAdmin
                          ? Text(
                              complaint.userEmail,
                              style: AppTextStyles.regular(14,
                                  color: AppColors.lightGrey),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(height: 4.h),
                      Text(
                        "Submitted on: ${DateFormat('dd MMMM, yyyy').format(complaint.submittedAt)}",
                        style: AppTextStyles.regular(14,
                            color: AppColors.lightGrey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Title section with status indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      complaint.title,
                      style: AppTextStyles.bold(24),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: complaint.status == "Resolved"
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.yellow.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                        Text(
                          complaint.status,
                          style: AppTextStyles.medium(
                            14,
                            color: complaint.status == "Resolved"
                                ? Colors.green
                                : Colors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Category section
              _buildInfoSection(
                "Category",
                complaint.category,
                Icons.category,
                AppColors.textColor,
              ),

              Divider(
                  color: AppColors.lightGrey.withValues(alpha: 0.3),
                  height: 24.h),

              // Description section
              _buildInfoSection(
                "Description",
                complaint.description,
                Icons.description,
                AppColors.textColor,
                expandContent: true,
              ),

              Divider(
                  color: AppColors.lightGrey.withValues(alpha: 0.3),
                  height: 24.h),

              // Attachments section
              Text("Attachments", style: AppTextStyles.medium(20)),
              SizedBox(height: 12.h),

              complaint.attachments.isEmpty
                  ? Text("No attachments available.",
                      style: AppTextStyles.regular(14))
                  : SizedBox(
                      height: 200.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: complaint.attachments.length,
                        separatorBuilder: (_, __) => SizedBox(width: 16.w),
                        itemBuilder: (context, index) {
                          final imageUrl = complaint.attachments[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FullScreenGalleryView(
                                      imageUrls: complaint.attachments),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                width: 300.w,
                                color: AppColors.darkBlueGrey
                                    .withValues(alpha: 0.5),
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: AppColors.darkBlueGrey
                                        .withValues(alpha: 0.3),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image,
                                              size: 48.sp,
                                              color: AppColors.lightGrey),
                                          SizedBox(height: 8.h),
                                          Text("Image not found",
                                              style: AppTextStyles.regular(14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

              SizedBox(height: 32.h),

              // Action buttons
              // Action buttons or resolution message
              if (isAdmin) ...[
                complaint.status == 'Resolved'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Colors.green, size: 24.sp),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    "This issue has been resolved. You can upload it as a success story post!",
                                    style: AppTextStyles.regular(14,
                                        color: Colors.green.shade300),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _buildActionButton(
                            onTap: () {
                              // Add your upload post logic here
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UploadAsPostScreen(),
                                  ));
                            },
                            text: "Upload as Post",
                            icon: Icons.upload_rounded,
                            backgroundColor: AppColors.darkPink,
                          ),
                        ],
                      )
                    : complaint.status == "Approved"
                        ? _buildActionButton(
                            onTap: () async {
                              // mark as resolved
                              await ComplaintOperations().updateComplaintStatus(
                                  complaintId: complaint.complaintId,
                                  newStatus: 'Resolved',
                                  context: context);
                              if (context.mounted) {
                                context.pop();
                              }
                            },
                            text: 'Mark as resoslved',
                            icon: Icons.verified,
                            backgroundColor: AppColors.darkGreen)
                        : Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  onTap: () async {
                                    // Approve the complaint
                                    await ComplaintOperations()
                                        .updateComplaintStatus(
                                            complaintId: complaint.complaintId,
                                            newStatus: "Approved",
                                            context: context);
                                    if (context.mounted) {
                                      context.pop();
                                    }
                                  },
                                  text: 'Approve',
                                  icon: Icons.check_circle_outline,
                                  backgroundColor: AppColors.darkPink,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: _buildActionButton(
                                  onTap: () async {
                                    // Reject the complaint
                                    await ComplaintOperations().deleteComplaint(
                                        complaint.complaintId, context);
                                    if (context.mounted) {
                                      context.pop();
                                    }
                                  },
                                  text: 'Reject',
                                  icon: Icons.cancel_outlined,
                                  backgroundColor: AppColors.darkBlueGrey,
                                ),
                              ),
                            ],
                          ),
              ],
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    String content,
    IconData icon,
    Color iconColor, {
    bool expandContent = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
          color: AppColors.darkBlueGrey,
          borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22.sp, color: iconColor),
              SizedBox(width: 8.w),
              Text(title, style: AppTextStyles.medium(20)),
            ],
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Text(
              content,
              style: AppTextStyles.regular(16),
              textAlign: expandContent ? TextAlign.justify : TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required String text,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textColor, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              text,
              style: AppTextStyles.medium(16),
            ),
          ],
        ),
      ),
    );
  }
}
