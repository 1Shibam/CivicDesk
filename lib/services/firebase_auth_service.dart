import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //! signup / signin with google with google -
  Future<void> sigupWithGoogle(BuildContext context) async {
    try {
      await GoogleSignIn().signOut();
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

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (userCredential.user != null) {
        if (isNewUser) {
          // 🔥 Create a new profile for a new user
          await FirestoreServices().createUserProfile('user');
        }

        if (context.mounted) {
          customSnackbar(
            context: context,
            message: 'Welcome, ${userCredential.user!.displayName}!',
            iconName: Icons.gpp_good_sharp,
            bgColor: Colors.blue,
          );

          // 🔀 Route based on new/returning user if needed
          context.go(RouterNames.userHome);
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

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      if (context.mounted) {
        customSnackbar(
          context: context,
          message: 'Login failed: ${e.message}',
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
      await FirestoreServices().createUserProfile('admin');
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      if (context.mounted) {
        customSnackbar(
            context: context,
            message: 'Something went wrong!!',
            bgColor: Colors.red,
            iconName: Icons.error);
      }
      return false;
    }
  }
}

final firebaseAuthServiceProvider =
    Provider<FirebaseAuthServices>((ref) => FirebaseAuthServices());
