import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';

void customSnackbar(
    {required String message,
    required BuildContext context,
    required IconData iconName,
    int duration = 2,
    Color bgColor = AppColors.darkPinkAccent}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: ListTile(
      leading: Icon(
        iconName,
        size: 20,
      ),
      tileColor: bgColor,
      title: Text(message),
    ),
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: duration),
  ));
}
