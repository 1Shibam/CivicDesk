import 'package:complaints/core/constants.dart';
import 'package:complaints/models/user_model.dart';
import 'package:complaints/providers/firestore_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceOptions extends StatelessWidget {
  const ImageSourceOptions({super.key, required this.userData});
  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Container(
          height: 200.h,
          decoration: BoxDecoration(
              color: AppColors.darkPinkAccent,
              borderRadius: BorderRadius.circular(20.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Source',
                  style: AppTextStyles.bold(32),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await ref
                                .read(firestoreServiceStateNotifierProvider
                                    .notifier)
                                .changeProfilePicture(
                                    context, userData.id, ImageSource.camera);
                          },
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            size: 40.sp,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          'Camera',
                          style: AppTextStyles.regular(20),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await ref
                                .read(firestoreServiceStateNotifierProvider
                                    .notifier)
                                .changeProfilePicture(
                                    context, userData.id, ImageSource.gallery);
                          },
                          icon: Icon(
                            Icons.image,
                            size: 40.sp,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          'Gallery',
                          style: AppTextStyles.regular(20),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
