import 'dart:io';

import 'package:complaints/core/constants.dart';
import 'package:complaints/presentation/widgets/custome_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


Future<File?> pickImage(ImageSource source, BuildContext context) async {
  try {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  } catch (e) {
    if (context.mounted) {
      customSnackbar(context:context, messages: 'Process Cancelled', bgColor: AppColors.darkPink);
    }
    rethrow;
  }
}
