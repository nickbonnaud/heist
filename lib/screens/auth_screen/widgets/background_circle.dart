import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:provider/provider.dart';
import 'package:heist/themes/global_colors.dart';

import 'page_offset_notifier.dart';

class BackgroundCircle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _BackgroundCircle(),
    );
  }
}

class _BackgroundCircle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double multiplier;
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        if (animation.value == 0) {
          multiplier = math.max(0, 4 * notifier.page - 3);
        } else {
          multiplier = math.max(0, 1 - 6 * animation.value);
        }

        double size = MediaQuery.of(context).size.width * 0.5 * multiplier;
        return Container(
          margin: EdgeInsets.only(bottom: SizeConfig.getWidth(65)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.textOnDarkSubdued
          ),
          width: size,
          height: size,
        );
      }
    );
  }
}