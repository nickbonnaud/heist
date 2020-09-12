import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:provider/provider.dart';

import 'page_offset_notifier.dart';

class ExhaustPath extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          top: SizeConfig.getHeight(25),
          left: -0.85 * notifier.offset + ((SizeConfig.getWidth(45) - (animation.value * SizeConfig.getWidth(5))) - (SizeConfig.getWidth(45) * (notifier.offset / 375))),
          width: MediaQuery.of(context).size.width * 1.6,
          child: Transform.scale(
            scale: 1 - 0.1 * animation.value,
            child: Opacity(
              opacity: 1 - 0.8 * animation.value,
              child: child,
            ),
          )
        );
      },
      child: IgnorePointer(
        child: Image.asset('assets/exhaust_path.png'),
      ),
    );
  }
}