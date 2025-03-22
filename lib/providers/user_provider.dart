// Stream provider to fetch user
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/models/user_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




//? current user provider
final currentUserProvider = StreamProvider.autoDispose<UserModel>((ref) {
  try {
    final FirebaseAuth user = FirebaseAuth.instance;
    final String currentUseId = user.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUseId)
        .snapshots()
        .map((doc) => UserModel.fromJson(doc.data()!));
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
