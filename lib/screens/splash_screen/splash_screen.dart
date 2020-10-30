
import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/route_builders/fade_in_route.dart';
import 'package:heist/global_widgets/route_builders/slide_up_route.dart';
import 'package:heist/screens/auth_screen/auth_screen.dart';
import 'package:heist/screens/layout_screen/layout_screen.dart';
import 'package:heist/screens/onboard_screen/onboard_screen.dart';
import 'package:heist/screens/splash_screen/bloc/splash_screen_bloc.dart';

import 'widgets/splash_control.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashControl _controls = SplashControl();

  StreamSubscription _animationCompleteListener;

  @override
  void initState() {
    super.initState();
    _animationListener(context: context);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashScreenBloc, SplashScreenState>(
      listener: (context, state) {
        if (state.mainAnimationComplete && !state.endAnimationComplete && state.nextScreen != null) {

          if (state.nextScreen == NextScreen.auth) {
            BlocProvider.of<SplashScreenBloc>(context).add(EndAnimationCompleted());
          } else {
            _controls.play('end');
          }
        } else if (state.endAnimationComplete) {
          _navigateToNextScreen(context: context, nextScreen: state.nextScreen);
        }
      },
      child: Scaffold(
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
              _animationCompleted(context: context, name: name);
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationCompleteListener.cancel();
    _controls.dispose();
    super.dispose();
  }

  void _navigateToNextScreen({@required BuildContext context, @required NextScreen nextScreen}) {
    if (nextScreen == NextScreen.auth) {
      Navigator.of(context).pushReplacement(
        FadeInRoute(screen: AuthScreen(), transitionDuration: Duration(seconds: 1))
      );
    } else if (nextScreen == NextScreen.onboard) {
      Navigator.of(context).pushReplacement(
        SlideUpRoute(screen: OnboardScreen())
      );
    } else {
      Navigator.of(context).pushReplacement(
        SlideUpRoute(screen: LayoutScreen())
      );
    }
  }

  void _animationListener({@required BuildContext context}) {
    _animationCompleteListener = _controls.animationCompleted.listen((animationName) {
      _animationCompleted(context: context, name: animationName);
    });
  }

  void _animationCompleted({@required BuildContext context, @required String name}) {
    if (name == 'idle') {
      _initAnimations();
    } else if (name == 'intro') {
      BlocProvider.of<SplashScreenBloc>(context).add(MainAnimationCompleted());
    } else if (name == 'end') {
      BlocProvider.of<SplashScreenBloc>(context).add(EndAnimationCompleted());
    }
  }

  void _initAnimations() {
    _controls.play('flame');
    _controls.play('stars');
    _controls.play('intro');
  }
}