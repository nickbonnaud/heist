import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:provider/provider.dart';

import 'page_offset_notifier.dart';


class LastImage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          left: 1.2 * MediaQuery.of(context).size.width - 0.85 * notifier.offset,
          child: Transform.scale(
            scale: 1 - 0.1 * animation.value,
            child: Opacity(
              opacity: 1 - 0.8 * animation.value,
              child: child,
            ),
          ),
        );
      },
      child: IgnorePointer(
        child: Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.getHeight(12)),
          child: Image.asset(
            'assets/vulture.png',
            height: MediaQuery.of(context).size.height / 3,
          ),
        ),
      ),
    );
  }
}