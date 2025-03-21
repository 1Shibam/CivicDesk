import 'package:complaints/presentation/screens/admin_home_screen.dart';
import 'package:complaints/presentation/screens/admin_login_screen.dart';
import 'package:complaints/presentation/screens/decide_screen.dart';
import 'package:complaints/presentation/screens/user_home_screen.dart';
import 'package:complaints/presentation/screens/user_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter appRoutes = GoRouter(initialLocation: '/initial', routes: [
  GoRoute(
    path: '/initial',
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 500),
        key: state.pageKey,
        child: const DecideScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    },
  ),
  GoRoute(
    path: '/userLogin',
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 500),
        key: state.pageKey,
        child: const UserLoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    },
  ),
  GoRoute(
    path: '/adminLogin',
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 500),
        key: state.pageKey,
        child: const AdminLoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    },
  ),
  GoRoute(
    path: '/userHome',
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 500),
        key: state.pageKey,
        child: const UserHomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    },
  ),
  GoRoute(
    path: '/adminHome',
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 500),
        key: state.pageKey,
        child: const AdminHomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    },
  ),
]);
