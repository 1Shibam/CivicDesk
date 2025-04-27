import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  final String complaintId;
  final String title;
  final String description;
  final String category;
  final String userId;
  final String userName;
  final String userEmail;
  final String? userProfileUrl;
  final List<String> attachments;
  final List<String> attachmentsResolved;
  final String status;
  final bool isSpam;
  final String? rejectionReason;
  final DateTime submittedAt;
  final bool userNotified;
  final bool adminNotified;
  final bool isPosted;
  final List<String> likedBy; // <-- New field: userIds who liked the post
  final int viewCount; // <-- New field: number of views
  final DateTime? postedAt; // <-- New field: when it was posted publicly

  ComplaintModel({
    required this.complaintId,
    required this.title,
    required this.description,
    required this.category,
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userProfileUrl,
    required this.attachments,
    required this.attachmentsResolved,
    required this.status,
    required this.isSpam,
    this.rejectionReason = '',
    required this.submittedAt,
    required this.userNotified,
    required this.adminNotified,
    required this.isPosted,
    this.likedBy = const [],
    this.viewCount = 0,
    this.postedAt,
  });

  factory ComplaintModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ComplaintModel(
      complaintId: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'Other',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userProfileUrl: data['userProfileUrl'],
      attachments: List<String>.from(data['attachments'] ?? []),
      attachmentsResolved:
          List<String>.from(data['attachments_resolved'] ?? []),
      status: data['status'] ?? 'pending',
      isSpam: data['isSpam'] ?? false,
      submittedAt: (data['submittedAt'] as Timestamp).toDate(),
      userNotified: data['userNotified'] ?? false,
      adminNotified: data['adminNotified'] ?? false,
      isPosted: data['is_posted'] ?? false,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      viewCount: data['viewCount'] ?? 0,
      postedAt: data['postedAt'] != null
          ? (data['postedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userProfileUrl': userProfileUrl,
      'attachments': attachments,
      'attachments_resolved': attachmentsResolved,
      'status': status,
      'isSpam': isSpam,
      'submittedAt': submittedAt,
      'userNotified': userNotified,
      'adminNotified': adminNotified,
      'is_posted': isPosted,
      'likedBy': likedBy,
      'viewCount': viewCount,
      'postedAt': postedAt,
    };
  }
}
