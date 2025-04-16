import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:complaints/core/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

class ReportBugPage extends StatefulWidget {
  const ReportBugPage({super.key});

  @override
  State<ReportBugPage> createState() => _ReportBugPageState();
}

class _ReportBugPageState extends State<ReportBugPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  String _appVersion = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  Future<void> _getAppInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report a Bug', style: AppTextStyles.bold(20)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.darkPinkAccent))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.bug_report_outlined,
                      size: 64.sp,
                      color: AppColors.darkPinkAccent,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Text(
                      'Help Us Improve',
                      style: AppTextStyles.bold(24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Center(
                    child: Text(
                      'Found a bug? Let us know so we can fix it!',
                      style: AppTextStyles.regular(16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Bug Description',
                    style: AppTextStyles.bold(18),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: _descriptionController,
                    style: AppTextStyles.regular(16),
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText:
                          'What went wrong? Please be as detailed as possible.',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Steps to Reproduce',
                    style: AppTextStyles.bold(18),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(height: 24.h),
                  _buildInfoItem('App Version', _appVersion),
                  _buildInfoItem(
                      'Device', Platform.isAndroid ? 'Android' : 'iOS'),
                  _buildInfoItem('OS Version', Platform.operatingSystemVersion),
                  SizedBox(height: 32.h),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _sendBugReport,
                      icon: const Icon(Icons.send, color: AppColors.textColor),
                      label: Text('Send Bug Report',
                          style: AppTextStyles.bold(16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkPinkAccent,
                        foregroundColor: AppColors.textColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.w, vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: TextButton(
                      onPressed: _sendDirectEmail,
                      child: Text(
                        'Or email us directly',
                        style: AppTextStyles.medium(16,
                            color: AppColors.darkPinkAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: AppTextStyles.medium(16),
          ),
          Text(
            value,
            style: AppTextStyles.regular(16),
          ),
        ],
      ),
    );
  }

  Future<void> _sendBugReport() async {
    final bugDescription = _descriptionController.text.trim();
    final stepsToReproduce = _stepsController.text.trim();

    if (bugDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a bug description'),
          backgroundColor: AppColors.darkPink,
        ),
      );
      return;
    }

    final emailBody = '''
Bug Description:
$bugDescription

Steps to Reproduce:
$stepsToReproduce

App Information:
- App Version: $_appVersion
- Device: ${Platform.isAndroid ? 'Android' : 'iOS'}
- OS Version: ${Platform.operatingSystemVersion}
''';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'bugs@complaintsapp.com',
      queryParameters: {
        'subject': 'Bug Report: Complaints App',
        'body': emailBody,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        customSnackbar(
            message: 'Cannot open email app',
            context: context,
            iconName: Icons.error,
            bgColor: Colors.red);
      }
    }
  }

  Future<void> _sendDirectEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'hehe.shibam@gmail.com',
      queryParameters: {
        'subject': 'Bug Report: Complaints App',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        customSnackbar(
            message: 'Cannot open email app',
            context: context,
            iconName: Icons.error,
            bgColor: Colors.red);
      }
    }
  }
}
