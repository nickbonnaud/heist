import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DragButton extends StatelessWidget {
  final double _size;
  final double _topMargin;
  final AnimationController _controller;
  final Function _toggle;

  const DragButton({required double size, required double topMargin, required AnimationController controller, required Function toggle, Key? key})
    : _size = size,
      _topMargin = topMargin,
      _controller = controller,
      _toggle = toggle,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topMargin - 10.h,
      right: 0,
      child: Transform.rotate(
        angle: math.pi * _controller.value,
        child: IconButton(
          onPressed: () => _toggle,
          icon: Icon(
            Icons.arrow_upward,
            size: _size,
            color: Theme.of(context).colorScheme.callToAction,
          )
        )
      ),
    );
  }
}