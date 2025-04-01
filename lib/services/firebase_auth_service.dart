import 'package:complaints/presentation/widgets/custome_snackbar.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:complaints/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //! signup / signin with google with google -
  Future<void> sigupWithGoogle(BuildContext context) async {
    try {
      //? making sure the previous accounts are signed out if the users did sign out -
      await GoogleSignIn().signOut();
      //? Starting the singUp process!!
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      //? User cancelled the signup process
      if (googleUser == null) {
        if (context.mounted) {
          customSnackbar(context: context, messages: 'Process Cancelled');
        }
        return;
      }
      //? getting google auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // If user exists, directly sign them in
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      await FirebaseAuth.instance.currentUser?.reload(); // Force refresh

      if (userCredential.user != null) {
        await FirestoreServices().createUserProfile('user');
        if (context.mounted) {
          customSnackbar(
              context: context,
              messages: 'Welcome , ${userCredential.user!.displayName}!');
          context.go(RouterNames.userHome);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        customSnackbar(
            context: context, messages: 'something went wrong : ${e.message}');
      }
    }
  }

  Future<void> createAdminWithEmail(
      String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirestoreServices().createUserProfile('admin');
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      if (context.mounted) {
        customSnackbar(context: context, messages: 'Something went wrong!!');
      }
    }
  }
}
