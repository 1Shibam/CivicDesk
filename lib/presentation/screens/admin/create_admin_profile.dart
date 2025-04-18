import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAdminProfile extends StatefulWidget {
  const CreateAdminProfile({super.key});

  @override
  State<CreateAdminProfile> createState() => _CreateAdminProfileState();
}

class _CreateAdminProfileState extends State<CreateAdminProfile> {
  final TextEditingController _fullNameController = TextEditingController();
  final FocusNode _fullNameFocus = FocusNode();

  String? selectedDepartment;
  String? selectedPost;

  final List<String> departments = ['IT', 'HR', 'Finance', 'Maintenance'];
  final List<String> posts = ['Head', 'Manager', 'Staff'];

  bool isLoading = false;

  void _submitAdminProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final email = FirebaseAuth.instance.currentUser?.email;

    if (_fullNameController.text.isEmpty ||
        selectedDepartment == null ||
        selectedPost == null ||
        uid == null ||
        email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final adminData = {
      'uid': uid,
      'name': _fullNameController.text.trim(),
      'email': email,
      'department': selectedDepartment,
      'post': selectedPost,
      'role': 'admin',
      'createdAt': DateTime.now(),
      'isActive': true,
    };

    await FirebaseFirestore.instance
        .collection('admins')
        .doc(uid)
        .set(adminData);

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      customSnackbar(
          message: 'Profile creation successfull',
          context: context,
          iconName: Icons.check,
          bgColor: Colors.green);
    }

    // Navigate or do something else after submission if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your following details',
                style: AppTextStyles.bold(20),
              ),
              SizedBox(height: 16.h),
              CustomTextFields(
                labelText: 'Full Name',
                prefixIcon: Icons.person,
                controller: _fullNameController,
                focusNode: _fullNameFocus,
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
                value: selectedDepartment,
                items: departments
                    .map((dep) => DropdownMenuItem(
                          value: dep,
                          child: Text(dep),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedDepartment = val;
                  });
                },
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Post',
                  border: OutlineInputBorder(),
                ),
                value: selectedPost,
                items: posts
                    .map((post) => DropdownMenuItem(
                          value: post,
                          child: Text(post),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedPost = val;
                  });
                },
              ),
              SizedBox(height: 24.h),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitAdminProfile,
                      child: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
