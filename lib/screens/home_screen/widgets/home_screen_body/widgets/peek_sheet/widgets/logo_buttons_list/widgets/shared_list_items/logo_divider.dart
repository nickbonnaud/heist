import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'shared_sizes.dart';
import '../../bloc/logo_buttons_list_bloc.dart';

class LogoDivider extends StatelessWidget {
  final int _numberPreviousWidgets;
  final AnimationController _controller;
  final double _topMargin;
  final bool _isActiveLocationDivider;

  LogoDivider({
    required int numberPreviousWidgets, 
    required AnimationController controller,
    required double topMargin,
    required bool isActiveLocationDivider
  })
    : _numberPreviousWidgets = numberPreviousWidgets,
      _controller = controller,
      _topMargin = topMargin,
      _isActiveLocationDivider = isActiveLocationDivider;

  final double _horizontalDividerSize = 100.sw;
  final SharedSizes sharedSizes = SharedSizes();

  double get _dividerHeight => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);
  double get _dividerWidth => lerp(min: sharedSizes.startSize, max: _horizontalDividerSize);
  
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: _dividerHeight,
      width: _controller.status != AnimationStatus.completed 
        ? _dividerWidth
        : MediaQuery.of(context).size.width - 16.w,
      top: _marginTop(index: _numberPreviousWidgets),
      left: _marginLeft(index: _numberPreviousWidgets),
      child: _controller.status != AnimationStatus.completed
        ? Transform.rotate(
            angle: math.pi / 2 * _controller.value + math.pi/2,
            child: Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme.onPrimaryDisabled,
            )
          )
        : BlocBuilder<LogoButtonsListBloc, LogoButtonsListState>(
            builder: (contexy, state) {
              return Text(
                _isActiveLocationDivider
                  ? "Active Locations"
                  : "Nearby Businesses",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryDisabled,
                  fontWeight: FontWeight.w900,
                  fontSize: 26.sp,
                  decoration: TextDecoration.underline
                ),
              );
            }
          )
    );
  }
  
  double _marginTop({required int index}) {
    return lerp(
      min: sharedSizes.startMarginTop,
      max: sharedSizes.endMarginTop + (index * (sharedSizes.verticalSpacing + sharedSizes.endSize))
    ) + (1.5.h *_topMargin); 
  }

  double _marginLeft({required int index}) {
    return lerp(
      min: (index) * ((sharedSizes.horizontalSpacing + sharedSizes.startSize)),
      max: 8.w
    );
  }
  
  double lerp({required double min, required double max}) {
    return lerpDouble(min, max, _controller.value)!;
  }
}