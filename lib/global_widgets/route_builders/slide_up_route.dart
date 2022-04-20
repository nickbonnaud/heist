import 'package:flutter/material.dart';

class SlideUpRoute extends PageRouteBuilder {
  static const Offset _begin = Offset(0.0, 1.0);
  static const Offset _end = Offset.zero;
  static const Curve _curve = Curves.easeInOut; 
  
  
  SlideUpRoute({required Widget screen, required String name, Duration? transitionDuration})
    : super(
        settings: RouteSettings(name: name),
        pageBuilder: (
          context, 
          animation, 
          secondaryAnimation
        ) => screen,
        transitionsBuilder: (
          context, 
          animation, 
          secondaryAnimation, 
          child
        ) => SlideTransition(
          position: animation.drive(Tween(begin: _begin, end: _end).chain(CurveTween(curve: _curve))),
          child: child,
        ),
        transitionDuration: transitionDuration ?? const Duration(milliseconds: 800)
      );
}