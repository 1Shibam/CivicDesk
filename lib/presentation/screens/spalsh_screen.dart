import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:complaints/widgets/loading_animation.dart';
import 'package:complaints/routes/router_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      context.go(RouterNames.initial);
      return;
    }

    try {
      // Check ADMIN status first
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();
      if (!mounted) return;

      if (adminDoc.exists) {
        context.go(RouterNames.adminHome);
        return;
      }
      // If not admin, continue to check regular user
    } catch (e) {
      debugPrint('Admin check error: $e');
    }

    // Check REGULAR USER
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!mounted) return;

      if (userDoc.exists) {
        context.go(RouterNames.userHome);
      } else {
        context.go(RouterNames.userProfileCreation);
      }
    } catch (e) {
      debugPrint('User check error: $e');
      context.go(RouterNames.initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingAnimation(),
      ),
    );
  }
}
