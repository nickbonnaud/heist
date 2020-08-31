import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:provider/provider.dart';
import 'package:heist/themes/global_colors.dart';

import '../auth_screen.dart';
import 'cubit/keyboard_visible_cubit.dart';

class DragArrow extends StatefulWidget {

  @override
  State<DragArrow> createState() => _DragArrowState();
}

class _DragArrowState extends State<DragArrow> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 10
    )..addListener(() {
      setState(() {
        
      });
    })..repeat(reverse: true);
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, child) {
        return Positioned(
          top: topMargin(context: context) + (1 - animation.value) * (mainSquareSize(context: context) + SizeConfig.getHeight(4)),
          right: SizeConfig.getWidth(6),
          child: Transform.rotate(
            angle: math.pi * animation.value,
            child: GestureDetector(
              onTap: () {
                animation.status == AnimationStatus.completed
                  ? animation.reverse()
                  : animation.forward();
              },
              child: Transform.translate(
                offset: Offset(
                  0, 
                  animation.status == AnimationStatus.dismissed
                    ? _controller.value
                    : 0
                ),
                child: child,
              ),
            ),
          )
        );
      },
      child: BlocBuilder<KeyboardVisibleCubit, bool>(
        builder: (context, keyboardVisible) {
          return Opacity(
            opacity: keyboardVisible ? 0 : 1,
            child: PlatformWidget(
              android: (_) => Icon(
                Icons.arrow_upward,
                size: SizeConfig.getWidth(8),
                color: Theme.of(context).colorScheme.callToAction,
              ),
              ios: (_) => Icon(
                IconData(
                  0xF366,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage
                ),
                color: Theme.of(context).colorScheme.callToAction,
                size: SizeConfig.getWidth(8),
              ),
            ),
          );
        },
      ) 
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}