import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData get appTheme => ThemeData(
    scaffoldBackgroundColor: AppColors.darkBlueGrey,
    inputDecorationTheme: inputDecorationTheme,
    appBarTheme: appBarTheme);

const AppBarTheme appBarTheme = AppBarTheme(
  backgroundColor: Colors.transparent,
);
//Text field input decoraiton theme
final inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r), // Default less circular
    borderSide: const BorderSide(color: AppColors.lightGrey),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(24.r), // More circular when focused
    borderSide: const BorderSide(color: AppColors.textColor, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r), // Less circular when not focused
    borderSide: const BorderSide(color: AppColors.textColor),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.r),
    borderSide: const BorderSide(color: AppColors.darkPink, width: 1.5),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(24.r),
    borderSide: const BorderSide(color: AppColors.darkPink, width: 2),
  ),
  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
);
