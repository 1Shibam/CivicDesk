import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {super.key,
      required this.onTap,
      required this.buttonText,
      required this.imageUrl,
      this.bgColor = AppColors.darkPinkAccent});
  final VoidCallback onTap;
  final String buttonText;
  final String imageUrl;
  final Color bgColor;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: _scale == 0.95
                ? widget.bgColor.withValues(alpha: 0.8)
                : widget.bgColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              const BoxShadow(
                  color: AppColors.textColor, // light hitting from top-left
                  offset: Offset(-1, -1),
                  blurRadius: 6,
                  spreadRadius: 1,
                  blurStyle: BlurStyle.inner),
              BoxShadow(
                color: AppColors.darkest
                    .withValues(alpha: 0.5), // shadow bottom-right
                offset: const Offset(4, 4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: EdgeInsets.all(10.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  widget.imageUrl,
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
                  widget.buttonText,
                  style: AppTextStyles.medium(24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
