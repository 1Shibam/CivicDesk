import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';

//custom text field for  more control over all the textfields in the application
class CustomTextFields extends StatelessWidget {
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final ValidationType validator;
  final TextInputType textType;
  final bool obscureText;
  final int maxLines;

  const CustomTextFields({
    super.key,
    required this.labelText,
    this.prefixIcon,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.maxLines = 1,
    this.obscureText = false,
    this.validator = ValidationType.none,
    this.textType = TextInputType.name,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.textColor,
      style: AppTextStyles.regular(16),
      controller: controller,
      maxLines: maxLines,
      focusNode: focusNode,
      obscureText: obscureText,
      obscuringCharacter: '*',
      keyboardType: textType,
      validator: (value) => validateInput(value, validator),
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      onFieldSubmitted: (value) {
        if (nextFocusNode != null && value.trim().isNotEmpty) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        } else {
          focusNode.unfocus();
        }
      },
      decoration: InputDecoration(
        alignLabelWithHint: true,
        errorStyle:
            AppTextStyles.regular(14).copyWith(color: AppColors.darkPinkAccent),
        labelText: labelText,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: AppColors.textColor),
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
