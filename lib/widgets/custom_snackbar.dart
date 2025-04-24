import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//single snackbar widget for handling error and success messages
void customSnackbar(
    {required String message,
    required BuildContext context,
    required IconData iconName,
    int duration = 2,
    Color bgColor = AppColors.darkPinkAccent}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      leading: Icon(
        iconName,
        size: 24.sp,
        color: AppColors.textColor,
      ),
      tileColor: bgColor,
      title: Text(
        message,
        style: AppTextStyles.regular(16),
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    duration: Duration(seconds: duration),
  ));
}
