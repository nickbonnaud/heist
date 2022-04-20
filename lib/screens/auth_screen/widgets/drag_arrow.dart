import 'dart:math' as math;


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../auth_screen.dart';
import 'cubit/keyboard_visible_cubit.dart';

class DragArrow extends StatefulWidget {

  const DragArrow({Key? key})
    : super(key: key);
  
  @override
  State<DragArrow> createState() => _DragArrowState();
}

class _DragArrowState extends State<DragArrow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
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
          top: topMargin(context: context) + (1 - animation.value) * (mainSquareSize(context: context) + 35.h),
          right: 25.w,
          child: Transform.rotate(
            angle: math.pi * animation.value,
            child: GestureDetector(
              key: const Key("dragArrowKey"),
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
            child: Icon(
              Icons.arrow_upward,
              size: 45.sp,
              color: Theme.of(context).colorScheme.callToAction,
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