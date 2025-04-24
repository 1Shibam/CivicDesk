//? current user provider
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/models/admin_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = StreamProvider.autoDispose<AdminModel>((ref) {
  try {
    final FirebaseAuth user = FirebaseAuth.instance;
    final String currentUseId = user.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('admins')
        .doc(currentUseId)
        .snapshots()
        .map((doc) => AdminModel.fromJson(doc.data()!));
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
