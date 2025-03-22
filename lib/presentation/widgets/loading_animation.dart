import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoadingAnimation extends StatelessWidget {
  final double opacity;
  final double? height;
  final double? width;
  const LoadingAnimation(
      {super.key, this.opacity = 1, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'asets/images/complaint-round-svgrepo-com.svg',
              width: 200.w,
              height: 200.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Loading',
                  style: AppTextStyles.medium(24),
                ),
                AnimatedTextKit(animatedTexts: [
                  TyperAnimatedText('....',
                      textStyle: AppTextStyles.medium(24),
                      speed: const Duration(milliseconds: 500))
                ])
              ],
            )
          ],
        ),
      ),
    );
  }
}
