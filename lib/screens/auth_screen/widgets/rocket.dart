import 'dart:math' as math;

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'page_offset_notifier.dart';

class Rocket extends StatelessWidget {
  static const _leftOffset = 25;
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          top: 0,
          left: -1.5 * notifier.offset - (_leftOffset - (_leftOffset * (notifier.offset / 375))),
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
        child: Transform.rotate(
          angle: -28 * (math.pi / 180),
          child: Container(
            height: 350,
            width: 350,
            child: FlareActor(
              'assets/theme.flr',
              alignment: Alignment.center,
              animation: 'flame',
              artboard: 'rocket',
            ),
          ),
        ),
      ),
    );
  }
}