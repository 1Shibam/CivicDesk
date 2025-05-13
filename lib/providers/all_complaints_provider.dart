import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allComplaintsProvider = StreamProvider<List<ComplaintModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('complaints')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => ComplaintModel.fromMap(doc.data(), doc.id))
        .toList();
  });
});
