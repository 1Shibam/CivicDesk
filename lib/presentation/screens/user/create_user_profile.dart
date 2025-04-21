import 'package:complaints/core/constants.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CreateUserProfile extends StatefulWidget {
  const CreateUserProfile({super.key});

  @override
  State<CreateUserProfile> createState() => _CreateUserProfileState();
}

class _CreateUserProfileState extends State<CreateUserProfile> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final FocusNode fullNameFocusNode = FocusNode();

  String? selectedGender;
  DateTime? selectedDob;
  String? selectedOccupation;
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

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      if (selectedGender == null ||
          selectedDob == null ||
          selectedOccupation == null ||
          !consentGiven) {
        customSnackbar(
          message: 'Please complete all fields and accept the consent.',
          context: context,
          iconName: Icons.error,
        );
        return;
      }

      // Proceed to save this data
      debugPrint('Name: ${fullNameController.text}');
      debugPrint('Gender: $selectedGender');
      debugPrint('DOB: $selectedDob');
      debugPrint('Occupation: $selectedOccupation');
      debugPrint('Consent Given: $consentGiven');

      // Navigate or save to Firestore, etc.
      context.go(RouterNames.userHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Text('Create Profile', style: AppTextStyles.bold(20)),
                SizedBox(height: 8.h),
                Text(
                  'Please enter your details to create your profile',
                  style: AppTextStyles.regular(16),
                ),
                SizedBox(height: 16.h),
                CustomTextFields(
                  labelText: 'Full name',
                  prefixIcon: Icons.person,
                  controller: fullNameController,
                  focusNode: fullNameFocusNode,
                  validator: ValidationType.name,
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.wc),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null ? 'Please select a gender' : null,
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedGender = val),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: _selectDOB,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      selectedDob != null
                          ? "${selectedDob!.day}/${selectedDob!.month}/${selectedDob!.year}"
                          : 'Select Date',
                      style: selectedDob != null
                          ? AppTextStyles.regular(16)
                          : AppTextStyles.regular(16)
                              .copyWith(color: Colors.grey),
                    ),
                  ),
                ),
                if (selectedDob == null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, left: 12.w),
                    child: Text(
                      'Please select your date of birth',
                      style: TextStyle(color: Colors.red[700], fontSize: 12),
                    ),
                  ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  value: selectedOccupation,
                  decoration: const InputDecoration(
                    labelText: 'Occupation',
                    prefixIcon: Icon(Icons.work),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val == null ? 'Please select your occupation' : null,
                  items: occupations
                      .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedOccupation = val),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Checkbox(
                      value: consentGiven,
                      onChanged: (val) =>
                          setState(() => consentGiven = val ?? false),
                    ),
                    Expanded(
                      child: Text(
                        'I confirm that the information provided is accurate and cannot be changed later.',
                        style: AppTextStyles.regular(14),
                      ),
                    ),
                  ],
                ),
                if (!consentGiven)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'You must accept the consent',
                      style: TextStyle(color: Colors.red[700], fontSize: 12),
                    ),
                  ),
                SizedBox(height: 20.h),
                CustomButton(
                    onTap: _submitProfile,
                    buttonText: 'Submit',
                    imageUrl: 'asets/images/send-alt-1-svgrepo-com.svg')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
