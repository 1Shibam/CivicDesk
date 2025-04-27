import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postedComplaintsStreamProvider =
    StreamProvider<List<ComplaintModel>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final complaintsRef = firestore.collection('complaints');

  // Stream that listens to Firestore changes where 'is_posted' is true
  final stream = complaintsRef
      .where('is_posted', isEqualTo: true)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return ComplaintModel.fromMap(doc.data(), doc.id);
    }).toList();
  });

  return stream;
});
