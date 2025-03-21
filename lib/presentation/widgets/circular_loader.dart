import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';

Future<dynamic> ciruclarLoader(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.darkPink,
        ),
      );
    },
  );
}