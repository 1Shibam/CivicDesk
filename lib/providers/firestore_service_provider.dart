import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final firestoreServiceProvider =
    Provider<FirestoreServices>((ref) => FirestoreServices());

class FirestoreServiceNotifier extends StateNotifier<FirestoreServices> {
  FirestoreServiceNotifier(super.services);

  Future<bool> changeProfilePicture(BuildContext context, String userID,
      ImageSource imageSource, bool isAdmin) async {
    try {
      await state.updateProfilePicture(userID, imageSource, context, isAdmin);
      if (context.mounted) {
        customSnackbar(
            context: context,
            message: 'Update successfull',
            bgColor: Colors.green,
            iconName: Icons.check);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeUserData(
      {required BuildContext context,
      required Map<String, dynamic> changes,
      required String userID,
      required bool isAdmin}) async {
    try {
      await state.updateUserData(
          userID: userID, updates: changes, context: context, isAdmin: isAdmin);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final firestoreServiceStateNotifierProvider =
    StateNotifierProvider<FirestoreServiceNotifier, FirestoreServices>((ref) {
  final services = ref.watch(firestoreServiceProvider);
  return FirestoreServiceNotifier(services);
});
