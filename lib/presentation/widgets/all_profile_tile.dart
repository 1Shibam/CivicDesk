import 'package:complaints/models/user_mode.dart';
import 'package:complaints/presentation/widgets/profile_tiles.dart';
import 'package:flutter/material.dart';

class AllProfileTiles extends StatelessWidget {
  const AllProfileTiles({
    super.key,
    required this.userData,
  });

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ProfileTile(
            title: 'Username',
            value: userData.name,
            disableEditing: true,
          ),
          ProfileTile(
            title: 'Email',
            disableEditing: true,
            value: obscureEmail(userData.email),
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
