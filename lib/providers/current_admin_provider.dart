//? current user provider
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/models/admin_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentAdminProvider = StreamProvider<AdminModel>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    // Return an empty stream that immediately completes (won't throw)
    return const Stream<AdminModel>.empty();
  }

  try {
    return FirebaseFirestore.instance
        .collection('admins')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
      final data = doc.data();
      if (data == null) throw Exception("Admin data is null");
      return AdminModel.fromJson(data);
    });
  } on FirebaseException catch (e, stackTrace) {
    debugPrint(e.message);
    debugPrintStack(stackTrace: stackTrace);
    rethrow;
  } catch (e, stackTrace) {
    debugPrint("Unexpected Error: $e");
    debugPrintStack(stackTrace: stackTrace);
    rethrow;
  }
});
