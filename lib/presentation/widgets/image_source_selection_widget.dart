import 'package:complaints/core/constants.dart';
import 'package:complaints/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectionOptionWidget extends ConsumerWidget {
  const ImageSelectionOptionWidget({
    super.key,
    required this.uid,
    required this.profileUrl,
    required this.isAdmin,
  });

  final String uid;
  final String profileUrl;
  final bool isAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        _showBottomSheet(
          context: context,
          uid: uid,
          profileUrl: profileUrl,
          isAdmin: isAdmin,
        );
      },
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: AppColors.darkPinkAccent,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: const Icon(
          Icons.edit,
          color: AppColors.textColor,
        ),
      ),
    );
  }
}

//show bottom sheet on tap of the pencil icon

void _showBottomSheet({
  required BuildContext context,
  required String uid,
  required String profileUrl,
  required bool isAdmin,
}) {
  showModalBottomSheet(
    backgroundColor: AppColors.darkPinkAccent,
    elevation: 20,
    isDismissible: true,
    enableDrag: true,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Image Source',
              style: AppTextStyles.bold(18),
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.textColor),
              title: Text('Camera', style: AppTextStyles.regular(16)),
              onTap: () async {
                final firestoreService = FirestoreServices();
                await firestoreService.updateProfilePicture(
                    uid, ImageSource.camera, context, isAdmin);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo, color: AppColors.textColor),
              title: Text('Gallery', style: AppTextStyles.regular(16)),
              onTap: () async {
                final firestoreService = FirestoreServices();
                await firestoreService.updateProfilePicture(
                    uid, ImageSource.gallery, context, isAdmin);
              },
            ),
          ],
        ),
      );
    },
  );
}
