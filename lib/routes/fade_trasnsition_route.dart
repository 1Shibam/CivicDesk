import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRoute fadeTransitionRoute(String path, Widget child) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 500),
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  );
}
