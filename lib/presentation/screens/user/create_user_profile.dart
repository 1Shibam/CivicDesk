import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';

class CreateUserProfile extends StatefulWidget {
  const CreateUserProfile({super.key});

  @override
  State<CreateUserProfile> createState() => _CreateUserProfileState();
}

class _CreateUserProfileState extends State<CreateUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Create Profile',
            style: AppTextStyles.bold(20),
          ),
          Text(
            'Please enter your details to create your profile',
            style: AppTextStyles.regular(16),
          ),
          Text(
            'make sure to fill correct details as you will not be able to change them later',
            style: AppTextStyles.regular(16),
          ),
          
        ],
      ),
    );
  }
}
