import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'page_offset_notifier.dart';


class FirstImage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          left: -0.85 * notifier.offset,
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
        child: Image.asset('assets/leopard.png'),
      ),
    );
  }
}