import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'image_source_selection_widget.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({
    super.key,
    required this.uid,
    required this.profileUrl,
    this.isAdmin = false,
  });

  final String uid;
  final String profileUrl;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    const String emptyProfile = 'https://i.imgur.com/PcvwDlW.png';

    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.darkBlueGrey,
          radius: 80.r,
          backgroundImage: CachedNetworkImageProvider(
            profileUrl.isNotEmpty ? profileUrl : emptyProfile,
          ),
        ),
        Positioned(
          bottom: 8.h,
          right: 2.w,
          child: ImageSelectionOptionWidget(
            uid: uid,
            profileUrl: profileUrl,
            isAdmin: isAdmin,
          ),
        ),
      ],
    );
  }
}
