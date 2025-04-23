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
import 'package:google_sign_in/google_sign_in.dart';

class CreateUserProfile extends StatefulWidget {
  const CreateUserProfile({super.key});

  @override
  State<CreateUserProfile> createState() => _CreateUserProfileState();
}

class _CreateUserProfileState extends State<CreateUserProfile> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode ageFocusNOde = FocusNode();
  final FocusNode genderFocus = FocusNode();

  final FocusNode occupationFocus = FocusNode();

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
        iconName: Icons.error,
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
  void dispose() {
    fullNameController.dispose();
    ageController.dispose();
    fullNameFocusNode.dispose();
    ageFocusNOde.dispose();
    genderFocus.dispose();

    occupationFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await GoogleSignIn().signOut(); // Sign out from Google
                await FirebaseAuth.instance.signOut(); // Sign out from Firebas
                setState(() {
                  isLoading = false;
                });
                if (context.mounted) {
                  context.go(RouterNames.initial);
                }
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
          actions: [
            TextButton(
                onPressed: () => context.go(RouterNames.userHome),
                child: const Text('S K I P'))
          ],
        ),
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
                    nextFocusNode: ageFocusNOde,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextFields(
                    labelText: 'Age',
                    prefixIcon: Icons.calendar_month,
                    controller: ageController,
                    focusNode: ageFocusNOde,
                    nextFocusNode: genderFocus,
                    textType: TextInputType.number,
                  ),
                  SizedBox(height: 20.h),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    focusNode: genderFocus,
                    style: AppTextStyles.regular(16)
                        .copyWith(color: AppColors.darkest), // force white text
                    dropdownColor: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12.r),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.black),
                    decoration: _dropdownDecoration('Gender'),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                    items: genders.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(
                          gender,
                          style: AppTextStyles.regular(16).copyWith(
                              color:
                                  AppColors.darkest), // force white inside list
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                  DropdownButtonFormField<String>(
                    value: selectedOccupation,
                    style: AppTextStyles.regular(16)
                        .copyWith(color: AppColors.darkest),
                    dropdownColor: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12.r),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.black),
                    decoration: _dropdownDecoration('Occupation'),
                    onChanged: (value) {
                      setState(() {
                        selectedOccupation = value;
                      });
                    },
                    items: occupations.map((occ) {
                      return DropdownMenuItem<String>(
                        value: occ,
                        child: Text(
                          occ,
                          style: AppTextStyles.regular(16)
                              .copyWith(color: AppColors.darkest),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          activeColor: AppColors.darkPinkAccent,
                          value: consentGiven,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r)),
                          onChanged: (value) {
                            setState(() {
                              consentGiven = value ?? false;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'I confirm that the above information is correct.',
                          style: AppTextStyles.regular(16),
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
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      hintText: 'Select $label',
      hintStyle: AppTextStyles.regular(16).copyWith(color: AppColors.darkest),
      fillColor: AppColors.textColor,
      filled: true,
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
