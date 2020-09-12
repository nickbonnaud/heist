import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';

import 'package:provider/provider.dart';

import 'page_offset_notifier.dart';

class Planets extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          top: SizeConfig.getHeight(10),
          left: MediaQuery.of(context).size.width - notifier.offset + SizeConfig.getWidth(15),
          child: Transform.scale(
            scale: 1 - 0.1 * animation.value,
            child: Opacity(
              opacity: 1 - 0.8 * animation.value,
              child: child,
            )
          )
        );
      },
      child: IgnorePointer(
        child: Container(
          height: 350,
          width: 350,
          child: FlareActor(
            'assets/theme.flr',
            animation: 'moon_orbit',
            artboard: 'earth_moon',
          ),
        ),
      ),
    );
  }
}