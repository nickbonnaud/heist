import 'package:flutter/material.dart';

class SlideUpRoute extends PageRouteBuilder {
  static final Offset _begin = Offset(0.0, 1.0);
  static final Offset _end = Offset.zero;
  static final Curve _curve = Curves.easeInOut; 
  
  
  SlideUpRoute({@required Widget screen, Duration transitionDuration})
    : assert(screen != null),
      super(
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
        transitionDuration: transitionDuration ?? Duration(milliseconds: 800)
      );
}