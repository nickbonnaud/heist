import 'package:flutter/material.dart';
import 'package:heist/models/business/business.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/details.dart';


class BusinessLogoDetails extends StatelessWidget {
  final String _keyValue;
  final double _topMargin;
  final double _leftMargin;
  final double _height;
  final double _borderRadius;
  final Business _business;
  final AnimationController _controller;
  final int _subListIndex;

  BusinessLogoDetails({
    required String keyValue,
    required double topMargin,
    required double leftMargin,
    required double height,
    required double borderRadius,
    required Business business,
    required AnimationController controller,
    required int subListIndex
  })
    : _keyValue = keyValue,
      _topMargin = topMargin,
      _leftMargin = leftMargin,
      _height = height,
      _borderRadius = borderRadius,
      _business = business,
      _controller = controller,
      _subListIndex = subListIndex;


  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topMargin,
      left: _leftMargin,
      height: _height,
      right: 16.w,
      child: _controller.status == AnimationStatus.completed
        ? Details(
            keyValue: _keyValue,
            height: _height, 
            borderRadius: _borderRadius, 
            business: _business,
            controller: _controller,
            index: _subListIndex
          )
        : Container(),
    );
  }
}