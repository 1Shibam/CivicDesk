import 'package:complaints/core/constants.dart';
import 'package:complaints/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ComplaintsPostsScreen extends ConsumerWidget {
  const ComplaintsPostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaintsStream = ref.watch(postedComplaintsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.darkest,
      body: complaintsStream.when(
        data: (complaints) {
          if (complaints.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.announcement_outlined,
                    size: 80.sp,
                    color: AppColors.lightGrey.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No Resolved complaints yet',
                    style: AppTextStyles.medium(16, color: AppColors.lightGrey),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Check back later for updates',
                    style: AppTextStyles.regular(14,
                        color: AppColors.lightGrey.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];

              return ComplaintPostCard(
                complaint: complaint,
                onLike: () => _handleLike(complaint),
                onShare: () => _shareComplaint(context, complaint),
                onImageTap: (imageUrl) => _showFullImage(context, imageUrl),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.darkPink),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 60.sp,
                color: AppColors.darkPink,
              ),
              SizedBox(height: 16.h),
              Text(
                'Error loading complaints',
                style: AppTextStyles.medium(16),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => ref.refresh(postedComplaintsStreamProvider),
                child: Text(
                  'Try Again',
                  style:
                      AppTextStyles.medium(14, color: AppColors.darkPinkAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLike(ComplaintModel complaint) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return;

      final complaintsRef = FirebaseFirestore.instance.collection('complaints');
      final complaintDoc = complaintsRef.doc(complaint.complaintId);

      // Check if user already liked
      if (complaint.likedBy.contains(currentUserId)) {
        // Unlike
        await complaintDoc.update({
          'likedBy': FieldValue.arrayRemove([currentUserId]),
        });
      } else {
        // Like
        await complaintDoc.update({
          'likedBy': FieldValue.arrayUnion([currentUserId]),
        });
      }
    } catch (e) {
      debugPrint('Error liking complaint: $e');
    }
  }

  void _shareComplaint(BuildContext context, ComplaintModel complaint) {
    // Implement your sharing functionality here
    // You can use packages like share_plus for sharing content
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing complaint: ${complaint.title}'),
        backgroundColor: AppColors.darkBlueGrey,
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.w),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.darkPink,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.broken_image,
                          color: AppColors.lightGrey, size: 60.sp),
                      SizedBox(height: 16.h),
                      Text('Image could not be loaded',
                          style: AppTextStyles.regular(14)),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.darkest.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.close, color: AppColors.textColor, size: 24.sp),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class ComplaintPostCard extends StatelessWidget {
  final ComplaintModel complaint;
  final VoidCallback? onLike;
  final VoidCallback? onShare;
  final Function(String)? onImageTap;

  const ComplaintPostCard({
    super.key,
    required this.complaint,
    this.onLike,
    this.onShare,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.darkBlueGrey,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info & Post Header
          _buildPostHeader(),

          // Complaint Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              complaint.title,
              style: AppTextStyles.bold(18),
            ),
          ),

          // Category & Status
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _buildCategoryChip(),
                SizedBox(width: 8.w),
                _buildStatusChip(),
              ],
            ),
          ),

          // Description
          Padding(
            padding: EdgeInsets.all(16.h),
            child: Text(
              complaint.description,
              style: AppTextStyles.regular(14),
            ),
          ),

          // Original Attachments
          if (complaint.attachments.isNotEmpty)
            _buildAttachmentsSection("Original Images", complaint.attachments),

          // Resolved Attachments
          if (complaint.attachmentsResolved.isNotEmpty)
            _buildAttachmentsSection(
                "Resolution Images", complaint.attachmentsResolved),

          // Post Stats & Interactions
          _buildInteractionsBar(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Row(
        children: [
          // User Avatar
          CircleAvatar(
            backgroundColor: AppColors.lightGrey,
            backgroundImage: complaint.userProfileUrl != null &&
                    complaint.userProfileUrl!.isNotEmpty
                ? NetworkImage(complaint.userProfileUrl!)
                : null,
            radius: 20.r,
            child: complaint.userProfileUrl == null ||
                    complaint.userProfileUrl!.isEmpty
                ? Text(
                    complaint.userName.isNotEmpty
                        ? complaint.userName[0].toUpperCase()
                        : "?",
                    style: AppTextStyles.bold(16, color: AppColors.darkest),
                  )
                : null,
          ),
          SizedBox(width: 12.w),

          // User Name & Post Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complaint.userName,
                  style: AppTextStyles.medium(14),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Posted ${_formatDate(complaint.postedAt ?? complaint.submittedAt)}',
                  style: AppTextStyles.regular(12, color: AppColors.lightGrey),
                ),
              ],
            ),
          ),

          // Options Menu
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.lightGrey),
            onPressed: () {/* Show options */},
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.darkPinkAccent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkPinkAccent, width: 1),
      ),
      child: Text(
        complaint.category,
        style: AppTextStyles.medium(12, color: AppColors.darkPinkAccent),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color statusColor;
    switch (complaint.status.toLowerCase()) {
      case 'resolved':
        statusColor = AppColors.darkGreen;
        break;
      case 'in progress':
        statusColor = AppColors.successYellow;
        break;
      case 'pending':
        statusColor = AppColors.lightGrey;
        break;
      default:
        statusColor = AppColors.lightGrey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        complaint.status.toUpperCase(),
        style: AppTextStyles.medium(12, color: statusColor),
      ),
    );
  }

  Widget _buildAttachmentsSection(String title, List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
          child: Text(
            title,
            style: AppTextStyles.medium(14, color: AppColors.lightGrey),
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 120.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onImageTap?.call(images[index]),
                child: Container(
                  width: 120.w,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color: AppColors.lightGrey.withValues(alpha: 0.3)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.darkPink,
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.darkest.withValues(alpha: 0.5),
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.lightGrey,
                              size: 30.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildInteractionsBar() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        children: [
          // Stats
          Row(
            children: [
              Text(
                '${complaint.viewCount} views',
                style: AppTextStyles.regular(12, color: AppColors.lightGrey),
              ),
              SizedBox(width: 16.w),
              Text(
                '${complaint.likedBy.length} likes',
                style: AppTextStyles.regular(12, color: AppColors.lightGrey),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Divider
          Container(
            height: 1,
            color: AppColors.lightGrey.withValues(alpha: 0.2),
          ),
          SizedBox(height: 12.h),

          // Like & Share buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: onLike,
                child: Row(
                  children: [
                    Icon(
                      complaint.likedBy.contains(
                              'currentUserId') // Replace with actual current user ID check
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: complaint.likedBy.contains('currentUserId')
                          ? AppColors.darkPink
                          : AppColors.lightGrey,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Like',
                      style:
                          AppTextStyles.medium(14, color: AppColors.lightGrey),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onShare,
                child: Row(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      color: AppColors.lightGrey,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Share',
                      style:
                          AppTextStyles.medium(14, color: AppColors.lightGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hr ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}
