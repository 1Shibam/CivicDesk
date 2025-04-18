import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String uid;
  final String name;
  final String email;
  final String department;
  final String post;
  final String role;
  final DateTime createdAt;
  final bool isActive;

  AdminModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.department,
    required this.post,
    this.isActive = true,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      department: map['department'],
      post: map['post'],
      role: map['role'] ?? 'admin',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'department': department,
      'post': post,
      'role': role,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }
}
