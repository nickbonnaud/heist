
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlareControls _controls = FlareControls();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FlareActor(
          'assets/splash_screen.flr',
          artboard: 'artboard',
          controller: _controls,
          fit: BoxFit.cover,
          animation: 'idle',
          callback: (name) {
            if (name == 'idle') {
              _initAnimations();
            } else if (name == 'end') {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }


  void _initAnimations() {
    _controls.play('flame');
    _controls.play('stars');
    _controls.play('earth_moon');
    _controls.play('main');
  }
}