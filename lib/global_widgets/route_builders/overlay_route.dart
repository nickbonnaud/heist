import 'package:flutter/material.dart';

class OverlayRouteTest extends PageRoute {
  final Widget _screen;
  
  static final Offset _begin = Offset(0.0, 1.0);
  static final Offset _end = Offset.zero;
  static final Curve _curve = Curves.easeInOut; 
  
  OverlayRouteTest({required Widget screen, required String name})
    : _screen = screen,
      super(settings: RouteSettings(name: name), fullscreenDialog: true);
  
  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  bool get opaque => false;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return SlideTransition(
      position: animation.drive(Tween(begin: _begin, end: _end).chain(CurveTween(curve: _curve))),
      child: _screen,
    );
  }

}