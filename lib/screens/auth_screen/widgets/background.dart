import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'page_offset_notifier.dart';

class Background extends StatelessWidget {
  final FlareControls _controls = FlareControls();
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          left: -275.w * (notifier.offset / 375.w),
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
          height: MediaQuery.of(context).size.height * 1.2,
          width: MediaQuery.of(context).size.width * 2,
          child: FlareActor(
            'assets/auth_screen.flr',
            alignment: Alignment.center,
            animation: 'init',
            artboard: 'artboard',
            controller: _controls,
            callback: (animationName) {
              if (animationName == 'init') {
                _initAnimations();
              }
            },
          ),
        )
      ),
    );
  }

  void _initAnimations() {
    _controls.play('stars');
    _controls.play('flame');
    _controls.play('planets');
  }
}