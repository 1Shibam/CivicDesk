import 'package:complaints/presentation/widgets/profile_tiles.dart';
import 'package:flutter/material.dart';

class AllProfileTiles extends StatelessWidget {
  const AllProfileTiles({
    super.key,
    required this.name,
    required this.email,
    this.age,
    this.gender,
    this.department,
    this.post,
    this.isAdmin = false,
  });

  final String name;
  final String email;
  final int? age;
  final String? gender;
  final String? department;
  final String? post;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ProfileTile(
            title: 'Username',
            value: name,
            disableEditing: true,
          ),
          ProfileTile(
            title: 'Email',
            value: obscureEmail(email),
            disableEditing: true,
          ),
          if (!isAdmin && age != null)
            ProfileTile(
              title: 'Age',
              value: age.toString(),
              disableEditing: true,
            ),
          if (!isAdmin && gender != null)
            ProfileTile(
              title: 'Gender',
              value: gender!,
              disableEditing: true,
            ),
          if (isAdmin && department != null)
            ProfileTile(
              title: 'Department',
              value: department!,
              disableEditing: true,
            ),
          if (isAdmin && post != null)
            ProfileTile(
              title: 'Post',
              value: post!,
              disableEditing: true,
            ),
        ],
      ),
    );
  }
}

//method for obscuring email -

String obscureEmail(String email) {
  List<String> parts = email.split('@');
  if (parts.length != 2) return email;
  String name = parts[0];
  String domain = parts[1];
  String obscuredName = name.substring(0, 2) + '*' * (name.length - 1);
  return "$obscuredName@$domain";
}
