import 'package:complaints/core/constants.dart';
import 'package:complaints/models/user_mode.dart';
import 'package:complaints/presentation/widgets/image_source_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ImageSelectionOptionWidget extends ConsumerWidget {
  const ImageSelectionOptionWidget({
    super.key,
    required this.userData,
  });

  final UserModel userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        _showBottomShett(context: context, userData: userData);
      },
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
            color: AppColors.darkPinkAccent,
            borderRadius: BorderRadius.circular(40.r)),
        child: const Icon(
          Icons.edit,
          color: AppColors.textColor,
        ),
      ),
    );
  }
}

//show bottom sheet on tap of the pencil icon

void _showBottomShett(
    {required BuildContext context, required UserModel userData}) {
  showModalBottomSheet(
    backgroundColor: AppColors.darkPinkAccent,
    elevation: 20,
    isDismissible: true,
    enableDrag: true,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return ImageSourceOptions(
        userData: userData,
      );
    },
  );
}
