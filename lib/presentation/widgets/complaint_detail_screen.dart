import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/presentation/widgets/full_screen_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ComplaintDetailScreen extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintDetailScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
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
          "Complaint Details",
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
                        separatorBuilder: (_, __) => SizedBox(width: 12.w),
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
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      onTap: () {
                        // Approve the complaint
                      },
                      text: 'Approve',
                      icon: Icons.check_circle_outline,
                      backgroundColor: AppColors.darkPink,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildActionButton(
                      onTap: () {
                        // Reject the complaint
                      },
                      text: 'Reject',
                      icon: Icons.cancel_outlined,
                      backgroundColor: AppColors.darkBlueGrey,
                    ),
                  ),
                ],
              ),
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
