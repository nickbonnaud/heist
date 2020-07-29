import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final bool _shouldAnimate;

  SplashScreen({@required bool shouldAnimate})
    : assert(shouldAnimate != null),
      _shouldAnimate = shouldAnimate;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200)
    );

    _animation = Tween(
      begin: 0.0,
      end: 1.0
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Curves.easeInCirc
    ));
    
    if (widget._shouldAnimate) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildAnimation(),
    );
  }

  Widget _buildAnimation() {
    switch('zoom-out') {
      case 'fade-in': {
        return FadeTransition(
        opacity: _animation,
        child: Center(
          child:
            SizedBox(height: 200, child: Image.asset('assets/flutter_icon.png'))));
      }
      case 'zoom-in': {
        return ScaleTransition(
        scale: _animation,
        child: Center(
          child:
            SizedBox(height: 200, child: Image.asset('assets/flutter_icon.png'))));
      }
      case 'zoom-out': {
        return ScaleTransition(
        scale: Tween(begin: 1.5, end: 0.6).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc)),
        child: Center(
          child:
            SizedBox(height: 200, child: Image.asset('assets/flutter_icon.png'))));
      }
      case 'top-down': {
        return SizeTransition(
        sizeFactor: _animation,
        child: Center(
          child:
            SizedBox(height: 200, child: Image.asset('assets/flutter_icon.png'))));
      }
    }
    return Container();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}