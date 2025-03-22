import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile(
      {super.key,
      required this.title,
      required this.value,
      this.onPressed,
      this.disableEditing = false});
  final String title;
  final String value;
  final VoidCallback? onPressed;
  final bool disableEditing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        tileColor: AppColors.darkPinkAccent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(title, style: AppTextStyles.bold(20)),
        subtitle: Text(value == '' ? 'not Mentinoned' : value,
            style: value == ''
                ? AppTextStyles.medium(16)
                : AppTextStyles.medium(16)),
        trailing: disableEditing
            ? null
            : IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.edit,
                  size: 28.sp,
                  color: AppColors.textColor,
                )),
      ),
    );
  }
}
