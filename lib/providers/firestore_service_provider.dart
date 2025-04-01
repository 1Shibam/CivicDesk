import 'package:complaints/presentation/widgets/custome_snackbar.dart';
import 'package:complaints/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';


final firestoreServiceProvider =
    Provider<FirestoreServices>((ref) => FirestoreServices());

class FirestoreServiceNotifier extends StateNotifier<FirestoreServices> {
  FirestoreServiceNotifier(super.services);

  Future<bool> createProfile(BuildContext context, String role) async {
    try {
      await state.createUserProfile(role);
      if (context.mounted) {
        customSnackbar(context:context, messages: 'User creation successfull');
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeProfilePicture(
      BuildContext context, String userID, ImageSource imageSource) async {
    try {
      await state.updateProfilePicture(userID, imageSource, context);
      if (context.mounted) {
        customSnackbar(context:context, messages: 'Update successfull');
      }
      return true;
    } catch (e) {
      return false;
    }
  }


  Future<bool> changeUserData(
      {required BuildContext context,
      required Map<String, dynamic> changes,
      required String userID}) async {
    try {
      await state.updateUserData(
          userID: userID, updates: changes, context: context);
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
