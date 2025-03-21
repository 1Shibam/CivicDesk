import 'package:complaints/core/constants.dart';
import 'package:complaints/presentation/widgets/custom_button.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DecideScreen extends StatelessWidget {
  const DecideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign Up',
                style: AppTextStyles.bold(40),
              ),
              SizedBox(
                height: 40.h,
              ),
              CustomButton(
                imageUrl: 'asets/images/user-svgrepo-com.svg',
                onTap: () {
                  context.push(RouterNames.userLogin);
                },
                buttonText: 'SignUp as User',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.lightGrey,
                        thickness: 2,
                        endIndent: 20.w,
                      ),
                    ),
                    Text(
                      'OR',
                      style: AppTextStyles.bold(24),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.lightGrey,
                        thickness: 2,
                        indent: 20.w,
                      ),
                    )
                  ],
                ),
              ),
              CustomButton(
                imageUrl: 'asets/images/admin-with-cogwheels-svgrepo-com.svg',
                onTap: () {
                  context.push(RouterNames.adminLogin);
                },
                buttonText: 'SignUp as Admin',
              )
            ],
          ),
        ),
      ),
    );
  }
}


