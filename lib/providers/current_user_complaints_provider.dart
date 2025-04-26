import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserComplaintsProvider =
    StreamProvider<List<ComplaintModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    // Return empty list if no user is logged in
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
      .collection('complaints')
      .where('userId', isEqualTo: currentUser.uid)
      .snapshots()
      .map((snapshot) {
    // For debugging, print the number of complaints fetched
    print(
        'Fetched ${snapshot.docs.length} complaints for user ${currentUser.uid}');

    return snapshot.docs
        .map((doc) => ComplaintModel.fromMap(doc.data(), doc.id))
        .toList();
  });
});
