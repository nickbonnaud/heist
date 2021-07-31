import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/transaction/transaction_resource.dart';

import 'widgets/details.dart';

class TransactionLogoDetails extends StatelessWidget {
  final String _keyValue;
  final double _topMargin;
  final double _leftMargin;
  final double _height;
  final double _borderRadius;
  final TransactionResource _transactionResource;
  final AnimationController _controller;
  final int _subListIndex;

  TransactionLogoDetails({
    required String keyValue,
    required double topMargin,
    required double leftMargin,
    required double height,
    required double borderRadius,
    required TransactionResource transactionResource,
    required AnimationController controller,
    required int subListIndex
  })
    : _keyValue = keyValue,
      _topMargin = topMargin,
      _leftMargin = leftMargin,
      _height = height,
      _borderRadius = borderRadius,
      _transactionResource = transactionResource,
      _controller = controller,
      _subListIndex = subListIndex;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _topMargin,
      left: _leftMargin,
      height: _height,
      right: 16,
      child: _controller.status == AnimationStatus.completed
        ? Details(
            keyValue: _keyValue,
            height: _height, 
            borderRadius: _borderRadius, 
            transactionResource: _transactionResource, 
            controller: _controller, 
            index: _subListIndex
          )
        : Container()
    );
  }
}