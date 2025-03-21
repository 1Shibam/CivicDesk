import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void customSnackbar(
    {required BuildContext context,
    required String messages,
    Color? bgColor,
    int? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      messages,
      style: AppTextStyles.regular(20),
    ),
    backgroundColor: bgColor ?? AppColors.darkPinkAccent,
    duration: Duration(seconds: duration ?? 2),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
  ));
}
