import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';

class NotificaitonsScreen extends StatefulWidget {
  const NotificaitonsScreen({super.key});

  @override
  State<NotificaitonsScreen> createState() => _NotificaitonsScreenState();
}

class _NotificaitonsScreenState extends State<NotificaitonsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTextStyles.bold(20),
        ),
      ),
    );
  }
}
