import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.buttonText,
      required this.imageUrl});
  final VoidCallback onTap;
  final String buttonText;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.darkPinkAccent,
            borderRadius: BorderRadius.circular(20.r)),
        padding: EdgeInsets.all(20.r),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                imageUrl,
                width: 32.sp,
                height: 32.sp,
              ),
              SizedBox(
                height: 40.sp,
                child: const VerticalDivider(
                  color: AppColors.lightGrey,
                ),
              ),
              Text(
                buttonText,
                style: AppTextStyles.medium(24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}