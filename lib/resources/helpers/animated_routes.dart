import 'package:flutter/material.dart';

class AnimatedRoutes {

  static Route centralIn(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween(
            begin: 0.0,
            end: 1.0
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.50,
                curve: Curves.linear
              )
            )
          ),
          child: ScaleTransition(
            scale: Tween(
              begin: 5.0,
              end: 1.0
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Interval(
                  0.50,
                  1.00,
                  curve: Curves.linear
                )
              )
            ),
            child: child,
          ),
        );
      }
    );
  }

  static Route fadeOut(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      }
    );
  }
}