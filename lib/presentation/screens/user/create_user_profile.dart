import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/widgets/custom_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CreateUserProfile extends StatefulWidget {
  const CreateUserProfile({super.key});

  @override
  State<CreateUserProfile> createState() => _CreateUserProfileState();
}

class _CreateUserProfileState extends State<CreateUserProfile> {
  final TextEditingController fullNameController = TextEditingController();
  final FocusNode fullNameFocusNode = FocusNode();

  String? selectedGender;
  DateTime? selectedDob;
  String? selectedOccupation;
  bool isLoading = false;
  bool consentGiven = false;

  final List<String> genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> occupations = [
    'Student',
    'Employee',
    'Self-employed',
    'Unemployed',
    'Other'
  ];

  Future<void> _selectDOB() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDob = picked;
      });
    }
  }

  void _submitProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final email = FirebaseAuth.instance.currentUser?.email;

    if (fullNameController.text.isEmpty ||
        selectedGender == null ||
        selectedDob == null ||
        selectedOccupation == null ||
        uid == null ||
        email == null ||
        !consentGiven) {
      customSnackbar(
        message: 'Please fill in all fields and accept the consent.',
        context: context,
        iconName: Icons.warning_amber_rounded,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final userData = {
      'uid': uid,
      'name': fullNameController.text.trim(),
      'email': email,
      'gender': selectedGender,
      'dob': selectedDob,
      'occupation': selectedOccupation,
      'role': 'user',
      'createdAt': DateTime.now(),
      'isActive': true,
    };

    await FirebaseFirestore.instance.collection('users').doc(uid).set(userData);

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      customSnackbar(
        message: 'Profile created successfully',
        context: context,
        iconName: Icons.check,
        bgColor: Colors.green,
      );
      context.go(RouterNames.userHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkest,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.darkBlueGrey,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Create User Profile', style: AppTextStyles.bold(22)),
                SizedBox(height: 12.h),
                Text('Please enter your details to create your profile',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular(16)),
                SizedBox(height: 24.h),
                CustomTextFields(
                  labelText: 'Full Name',
                  prefixIcon: Icons.person,
                  controller: fullNameController,
                  focusNode: fullNameFocusNode,
                ),
                SizedBox(height: 20.h),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  decoration: _dropdownDecoration('Gender'),
                  items: genders
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child:
                                Text(gender, style: AppTextStyles.regular(16)),
                          ))
                      .toList(),
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: _selectDOB,
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: selectedDob == null
                            ? 'Select your birth date'
                            : '${selectedDob!.day}/${selectedDob!.month}/${selectedDob!.year}',
                        prefixIcon: const Icon(Icons.cake),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                DropdownButtonFormField<String>(
                  value: selectedOccupation,
                  onChanged: (value) {
                    setState(() {
                      selectedOccupation = value;
                    });
                  },
                  decoration: _dropdownDecoration('Occupation'),
                  items: occupations
                      .map((occ) => DropdownMenuItem(
                            value: occ,
                            child: Text(occ, style: AppTextStyles.regular(16)),
                          ))
                      .toList(),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Checkbox(
                      value: consentGiven,
                      onChanged: (value) {
                        setState(() {
                          consentGiven = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'I confirm that the above information is correct.',
                        style: AppTextStyles.regular(14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onTap: _submitProfile,
                        buttonText: 'Submit',
                        imageUrl: 'asets/images/send-alt-1-svgrepo-com.svg',
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      hintText: 'Select $label',
      hintStyle: AppTextStyles.regular(16).copyWith(color: AppColors.textColor),
      labelStyle:
          AppTextStyles.regular(16).copyWith(color: AppColors.textColor),
      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.textColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.textColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.textColor),
      ),
    );
  }
}
