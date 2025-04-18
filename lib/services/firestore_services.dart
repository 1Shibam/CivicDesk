import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/models/user_mode.dart';
import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/services/pick_image.dart';
import 'package:complaints/services/upload_image_to_imgur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class FirestoreServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user profile if it doesn't exist

  Future<void> createUserProfile(String role) async {
    final user = _auth.currentUser!;
    final userDocRef = firestore.collection('users').doc(user.uid);

    // Check if user already exists (avoiding an extra function call)
    final userDoc = await userDocRef.get();
    if (userDoc.exists) return;

    final userInfo = UserModel(
      id: user.uid,
      name: user.displayName ?? '', // Handle null
      email: user.email ?? '',
      role: role,

      joinedAt: Timestamp.now()
          .toDate()
          .toIso8601String()
          .split('.')[0], // Use Firestore Timestamp
      profileUrl: '',
    );

    await userDocRef.set(userInfo.toJson());
  }

  //update profile picture in firestore --

  Future<void> updateProfilePicture(
      String userId, ImageSource source, BuildContext context) async {
    File? image = await pickImage(source, context);
    if (image == null) return;
    if (!context.mounted) return;

    String? imageUrl = await uploadImageToImgur(context, image);
    if (imageUrl != null && context.mounted) {
      await updateUserData(
        userID: userId,
        context: context,
        updates: {'profile_url': imageUrl},
      );
    }
  }

  // Single method to update user Data - this method finalizes updates
  Future<void> updateUserData(
      {required String userID,
      required Map<String, dynamic> updates,
      required BuildContext context}) async {
    try {
      await firestore.collection('users').doc(userID).update(updates);
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
      if (context.mounted) {
        context.pop();
      }
    }
  }

  //match the admin pass keys to let them sign in --

  Future<bool> validateAdminPasskey(String enteredKey) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('adminPassKeys').get();

      //Extracting all pass keys from the document --
      List<String> storedPassKeys =
          snapshot.docs.map((doc) => doc.data()['passkey'].toString()).toList();

      return storedPassKeys.contains(enteredKey);
    } catch (e) {
      debugPrint('Error fetching passkeys: $e');
      return false;
    }
  }
}
