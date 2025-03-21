import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppFonts {
  static const String fontRegular = 'Sora-Regular';
  static const String fontMedium = 'Sora-Medium';
  static const String fontBold = 'Sora-Bold';
}

class AppColors {
  static const Color darkPink = Color(0xffd90429);
  static const Color darkPinkAccent = Color(0xffef233c);
  static const Color darkBlueGrey = Color(0xff2b2d42);
  static const Color lightGrey = Color(0xff8d99ae);
  static const Color textColor = Color(0xffedf2f4);
}

class AppTextStyles {
  static TextStyle regular(double size, {Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.fontRegular,
      fontSize: size.sp,
      color: color ?? AppColors.textColor,
    );
  }

  static TextStyle medium(double size, {Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.fontMedium,
      fontSize: size.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColors.textColor,
    );
  }

  static TextStyle bold(double size, {Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.fontBold,
      fontSize: size.sp,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.textColor,
    );
  }
}
