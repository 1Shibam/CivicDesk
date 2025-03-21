import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  final String complaintId;
  final String title;
  final String description;
  final String category;
  final String userId;
  final String userName;
  final String userEmail;
  final List<String> attachments; 
  final String status; 
  final bool isSpam;
  final String? adminId; 
  final DateTime submittedAt;
  final DateTime updatedAt;
  final bool userNotified; 
  final bool adminNotified; 

  ComplaintModel({
    required this.complaintId,
    required this.title,
    required this.description,
    required this.category,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.attachments,
    required this.status,
    required this.isSpam,
    this.adminId,
    required this.submittedAt,
    required this.updatedAt,
    required this.userNotified,
    required this.adminNotified,
  });

  // Convert Firestore document to model
  factory ComplaintModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ComplaintModel(
      complaintId: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'Other',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      attachments: List<String>.from(data['attachments'] ?? []),
      status: data['status'] ?? 'pending',
      isSpam: data['isSpam'] ?? false,
      adminId: data['adminId'],
      submittedAt: (data['submittedAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      userNotified: data['userNotified'] ?? false,
      adminNotified: data['adminNotified'] ?? false,
    );
  }

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'attachments': attachments,
      'status': status,
      'isSpam': isSpam,
      'adminId': adminId,
      'submittedAt': submittedAt,
      'updatedAt': updatedAt,
      'userNotified': userNotified,
      'adminNotified': adminNotified,
    };
  }
}
