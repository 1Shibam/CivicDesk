import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValidationType validator;
  const CustomTextFields(
      {super.key,
      required this.labelText,
      required this.prefixIcon,
      required this.controller,
      required this.focusNode,
      this.validator = ValidationType.none,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: (value) => validateInput(value, validator),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: AppColors.textColor),
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

enum ValidationType {
  none,
  email,
  password,
  name,
  phone,
  required,
}

String? validateInput(String? value, ValidationType type) {
  switch (type) {
    case ValidationType.email:
      if (value == null || value.isEmpty) return 'Email is required';
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      return emailRegex.hasMatch(value) ? null : 'Enter a valid email';
    case ValidationType.password:
      if (value == null || value.isEmpty) return 'Password is required';
      return value.length < 6 ? 'Password must be at least 6 characters' : null;
    case ValidationType.name:
      if (value == null || value.isEmpty) return 'Name is required';
      return value.length < 2 ? 'Name too short' : null;
    case ValidationType.phone:
      if (value == null || value.isEmpty) return 'Phone number is required';
      final phoneRegex = RegExp(r'^[0-9]{10}$');
      return phoneRegex.hasMatch(value)
          ? null
          : 'Enter a valid 10-digit phone number';
    case ValidationType.required:
      return (value == null || value.isEmpty) ? 'This field is required' : null;
    case ValidationType.none:
      return null;
  }
}
