import 'package:flutter/material.dart';

class FadeInRoute extends PageRouteBuilder {
  
  FadeInRoute({@required Widget screen, Duration transitionDuration})
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
        ) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: transitionDuration ?? Duration(milliseconds: 800)
      );
}