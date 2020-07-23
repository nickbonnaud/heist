import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/auth_screen/auth_screen.dart';
import 'package:heist/screens/auth_screen/widgets/page_offset_notifier.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:provider/provider.dart';

class WelcomeLabel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return Positioned(
          top: topMargin(context: context) + (1 - animation.value) * (mainSquareSize(context: context) + 32 - 4),
          left: 24 - notifier.offset,
          child: Opacity(
            opacity: 1 - (2 * notifier.page),
            child: child,
          )
        );
      },
      child: VeryBoldText2(
        text: 'Login', 
        context: context,
        color: Theme.of(context).colorScheme.textOnDark,
      )
    );
    
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: math.max(0, 1 - 4 * notifier.page),
          child: child,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 24),
        child: PlatformText(
          "Welcome Back",
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.textOnDark
          ),
        ),
      ),
    );
  }
}