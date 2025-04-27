import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/services/db_services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //! signup / signin with google with google -
  Future<void> signupWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        if (context.mounted) {
          customSnackbar(
            context: context,
            message: 'Process Cancelled',
            iconName: Icons.cancel,
            bgColor: Colors.red,
          );
        }
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      await FirebaseAuth.instance.currentUser?.reload();

      final user = userCredential.user;
      if (user != null && context.mounted) {
        final profileExists =
            await FirestoreServices().checkIfProfileExists(user.uid);

        if (!context.mounted) return;
        if (profileExists) {
          context.go(RouterNames.userHome);
        } else {
          context.go(RouterNames.userProfileCreation);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        customSnackbar(
          context: context,
          message: 'Something went wrong: ${e.message}',
          bgColor: Colors.red,
          iconName: Icons.cancel,
        );
      }
    }
  }

  //admin login with email and password --
  Future<bool> loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final user = _auth.currentUser;
      if (user != null && context.mounted) {
        final profileExists = await FirestoreServices()
            .checkIfProfileExists(user.uid, isAdmin: true);
        if (!context.mounted) return false;
        if (profileExists) {
          context.go(RouterNames.adminHome);
        } else {
          context.go(RouterNames.adminProfileCreation);
        }
      }

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      if (context.mounted) {
        customSnackbar(
          context: context,
          message: 'Failed: ${e.code}',
          bgColor: Colors.red,
          iconName: Icons.error,
        );
      }
      return false;
    }
  }

//create admin with email and password
  Future<bool> createAdminWithEmail(
      String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // await FirestoreServices().createUserProfile();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      if (context.mounted) {
        customSnackbar(
            context: context,
            message: e.message.toString(),
            bgColor: Colors.red,
            iconName: Icons.error);
      }
      return false;
    }
  }
}

final firebaseAuthServiceProvider =
    Provider<FirebaseAuthServices>((ref) => FirebaseAuthServices());
