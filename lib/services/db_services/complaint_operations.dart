import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final complaintsRef = FirebaseFirestore.instance.collection('complaints');

//toggle post like of the resolved issuess ---
Future<void> toggleLike(
    {required String complaintId,
    required String userId,
    required BuildContext context}) async {
  final docRef = complaintsRef.doc(complaintId);
  final doc = await docRef.get();
  final List<dynamic> likedBy = doc.data()?['likedBy'] ?? [];

  if (likedBy.contains(userId)) {
    await docRef.update({
      'likedBy': FieldValue.arrayRemove([userId]),
    });
  } else {
    await docRef.update({
      'likedBy': FieldValue.arrayUnion([userId]),
    });
  }
}

//update the complaint status of the registered complaint to spam, resolved, approved etc..
Future<void> updateComplaintStatus(
    {required String complaintId,
    required String newStatus,
    required BuildContext context}) async {
  await complaintsRef.doc(complaintId).update({
    'status': newStatus,
  });
}

//resolved complaint post method --
Future<void> setComplaintPosted(
    {required String complaintId,
    required bool isPosted,
    required BuildContext context}) async {
  await complaintsRef.doc(complaintId).update({
    'is_posted': isPosted,
    'postedAt': isPosted ? DateTime.now() : null,
  });
}

// if there is any proof images of the resolved complaints ---
Future<void> addResolvedAttachments(
    {required String complaintId,
    required List<String> newAttachments,
    required BuildContext context}) async {
  await complaintsRef.doc(complaintId).update({
    'attachments_resolved': FieldValue.arrayUnion(newAttachments),
  });
}
