import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/admin_model.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/models/user_model.dart';
import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/services/pick_image.dart';
import 'package:complaints/services/upload_image_to_imgur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FirestoreServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user profile if it doesn't exist

  String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return DateFormat('MMMM d, yyyy – hh:mm a').format(dateTime);
  }

// Create user profile
  Future<void> createUserProfile({
    String? username,
    required int age,
    required String occupation,
    required String gender,
  }) async {
    final user = _auth.currentUser!;
    final userDocRef = firestore.collection('users').doc(user.uid);

    final userDoc = await userDocRef.get();
    if (userDoc.exists) return;

    final userInfo = UserModel(
        id: user.uid,
        name: capitalizeEachWord(username ?? user.displayName!),
        email: user.email ?? '',
        age: age,
        occupation: occupation,
        gender: gender,
        joinedAt: formatTimestamp(Timestamp.now()),
        profileUrl: '',
        totalComplaints: 0,
        pendingComplaints: 0,
        resolvedComplaints: 0);

    await userDocRef.set(userInfo.toJson());
  }

// Create admin profile
  Future<void> createAdminProfile({
    required String name,
    required String department,
    required String post,
  }) async {
    final user = _auth.currentUser!;
    final userDocRef = firestore.collection('admins').doc(user.uid);

    final userDoc = await userDocRef.get();
    if (userDoc.exists) return;

    final userInfo = AdminModel(
      uid: user.uid,
      name: capitalizeEachWord(name),
      email: user.email ?? '',
      department: department,
      post: post,
      createdAt: formatTimestamp(Timestamp.now()),
      profileUrl: '',
    );

    await userDocRef.set(userInfo.toJson());
  }

  //update profile picture in firestore --

  Future<void> updateProfilePicture(String userId, ImageSource source,
      BuildContext context, bool isAdmin) async {
    File? image = await pickImage(source, context);
    if (image == null) return;
    if (!context.mounted) return;

    String? imageUrl = await uploadImageToImgur(context, image);
    if (imageUrl != null && context.mounted) {
      await updateUserData(
        isAdmin: isAdmin,
        userID: userId,
        context: context,
        updates: isAdmin ? {'profileUrl': imageUrl} : {'profile_url': imageUrl},
      );
    }
  }

  // Single method to update user Data - this method finalizes updates
  Future<void> updateUserData(
      {required String userID,
      required bool isAdmin,
      required Map<String, dynamic> updates,
      required BuildContext context}) async {
    try {
      isAdmin
          ? await firestore.collection('admins').doc(userID).update(updates)
          : await firestore.collection('users').doc(userID).update(updates);
      if (context.mounted) {
        context.pop();
      }
    } on FirebaseException catch (error) {
      if (context.mounted) {
        customSnackbar(
            context: context,
            message: 'Error: $error',
            iconName: Icons.error,
            bgColor: Colors.red);
      }
    } catch (e) {
      debugPrint('something must be wrong!!');
    }
  }

  //match the admin pass keys to let them sign in --

  Future<bool> validateAdminPasskey(
      String enteredKey, BuildContext context) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('adminPassKeys').get();

      //Extracting all pass keys from the document --
      List<String> storedPassKeys =
          snapshot.docs.map((doc) => doc.data()['passkey'].toString()).toList();

      return storedPassKeys.contains(enteredKey);
    } on FirebaseException catch (e) {
      if (context.mounted) {
        customSnackbar(
            message: e.message!,
            context: context,
            iconName: Icons.error,
            bgColor: Colors.red);
      }
      debugPrint('Error fetching passkeys: $e');
      return false;
    }
  }

  Future<bool> checkIfProfileExists(String uid, {bool isAdmin = false}) async {
    final collection = isAdmin ? 'admins' : 'users';
    final doc =
        await FirebaseFirestore.instance.collection(collection).doc(uid).get();
    return doc.exists;
  }

  Future<void> submitComplaint(
      ComplaintModel complaint, BuildContext context) async {
    try {
      final complaintRef = FirebaseFirestore.instance
          .collection('complaints')
          .doc(complaint.complaintId);

      await complaintRef.set(complaint.toMap());

      if (context.mounted) {
        customSnackbar(
            message: 'Complaint Submitted Successfully',
            context: context,
            iconName: Icons.done,
            bgColor: AppColors.darkGreen);
      }
    } catch (e) {
      if (context.mounted) {
        customSnackbar(
            message: 'Complaint Submission failed',
            context: context,
            iconName: Icons.done,
            bgColor: Colors.red);
      }
      rethrow; // optional: rethrow if you want to handle it at the UI level
    }
  }
}

String formatTimestamp(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  return DateFormat('MMMM d, yyyy – hh:mm a').format(dateTime);
}

String capitalizeEachWord(String input) {
  return input
      .split(' ')
      .map((word) => word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '')
      .join(' ');
}

final firestoreProvider =
    Provider<FirestoreServices>((ref) => FirestoreServices());
