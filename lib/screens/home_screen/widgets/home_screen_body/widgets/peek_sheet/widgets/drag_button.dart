import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/themes/global_colors.dart';

class DragButton extends StatelessWidget {
  final double _size;
  final double _topMargin;
  final AnimationController _controller;
  final Function _toggle;

  DragButton({required double size, required double topMargin, required AnimationController controller, required Function toggle})
    : _size = size,
      _topMargin = topMargin,
      _controller = controller,
      _toggle = toggle;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topMargin - 5,
      right: 0,
      child: Transform.rotate(
        angle: math.pi * _controller.value,
        child: GestureDetector(
          onTap: () => _toggle,
          child: Icon(
            Icons.arrow_upward,
            size: _size,
            color: Theme.of(context).colorScheme.callToAction,
          ),
        ),
      ),
    );
  }
}