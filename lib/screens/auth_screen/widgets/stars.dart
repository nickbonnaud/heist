import 'dart:async';
import 'dart:math' as math;

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'page_offset_notifier.dart';

class Stars extends StatefulWidget {
  
  @override
  State<Stars> createState() => _StarsState();
}
class _StarsState extends State<Stars> {
  static const _offsetWidth =  250;
  final StarsControl _controls = StarsControl();
  final math.Random _random = math.Random();

  List<String> _currentAnimations = [];
  StreamSubscription _animationCompleteListener;
  
  @override
  void initState() {
    super.initState();
    animationCompleteListener();
    _pulseStars();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          left: -_offsetWidth * (notifier.offset / 375),
          child: Transform.scale(
            scale: 1.1 - 0.1 * animation.value,
            child: Opacity(
              opacity: 1 - 0.8 * animation.value,
              child: child,
            ),
          )
        );
      },
      child: IgnorePointer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/stars.png'),
              fit: BoxFit.contain,
              repeat: ImageRepeat.repeatY
            )
          ),
          child: FlareActor(
            'assets/theme.flr',
            alignment: Alignment.center,
            animation: 'idle',
            artboard: 'background',
            controller: _controls,
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    _controls.dispose();
    _animationCompleteListener.cancel();
    super.dispose();
  }

  void _pulseStars() {
    String animationName = _getAnimation();

    if (!_currentAnimations.contains(animationName)) {
      _currentAnimations.add(animationName);
      _controls.play(animationName);
      Future.delayed(
        Duration(milliseconds: _randomInt(min: 100, max: 500)),
        () => _pulseStars()
      );
    } else {
      _pulseStars();
    }
  }

  String _getAnimation() {
    int animationNumber = _randomInt(min: 1, max: 20);
    return 'star_$animationNumber';
  }

  int _randomInt({@required int min, @required int max}) {
    return min + _random.nextInt(max);
  }

  void animationCompleteListener() {
    _animationCompleteListener = _controls.animationCompleted.listen((animationName) { 
      _currentAnimations.remove(animationName);
    });
  }
}

class StarsControl extends FlareControls {
  StreamController<String> _controller = StreamController<String>.broadcast();

  Stream get animationCompleted => _controller.stream;

  void dispose() => _controller.close();
  
  @override
  void onCompleted(String name) {
    _controller.sink.add(name);
    super.onCompleted(name);
  }
}