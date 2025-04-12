import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PageTransitionType {
  fade,
  scale,
  slide,
  rotation,
}

GoRoute customTransitionRoute(
    String path, Widget child, PageTransitionType transitionType) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 500),
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          switch (transitionType) {
            case PageTransitionType.fade:
              return FadeTransition(
                opacity: animation,
                child: child,
              );

            case PageTransitionType.scale:
              return ScaleTransition(
                scale: animation,
                child: child,
              );

            case PageTransitionType.slide:
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );

            case PageTransitionType.rotation:
              return RotationTransition(
                turns: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
          }
        },
      );
    },
  );
}
