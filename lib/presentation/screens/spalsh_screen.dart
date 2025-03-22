import 'package:complaints/presentation/widgets/loading_animation.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return; // Ensure widget is still in the tree before navigating
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      context.go(RouterNames.userHome);
    } else {
      context.go(RouterNames.initial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LoadingAnimation(),
          );
        }
        final user = snapshot.data;
        if (user != null) {
          Future.microtask(() async {
            if (context.mounted) {
              context.go(RouterNames.userHome);
            }
          });
        } else {
          Future.microtask(() {
            if (context.mounted) {
              context.go(RouterNames.initial);
            }
          });
        }
        return const Center(
          child: LoadingAnimation(),
        );
      },
    ));
  }
}
