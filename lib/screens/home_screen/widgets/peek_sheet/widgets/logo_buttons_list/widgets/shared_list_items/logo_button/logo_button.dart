import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/transaction/transaction_resource.dart';

import '../shared_sizes.dart';
import 'widgets/logo_business_button/bloc/logo_business_button_bloc.dart';
import 'widgets/logo_business_button/logo_business_button.dart';
import 'widgets/logo_transaction_button/bloc/logo_transaction_button_bloc.dart';
import 'widgets/logo_transaction_button/logo_transaction_button.dart';


class LogoButton extends StatelessWidget {
  final AnimationController _controller;
  final double _topMargin;
  final double _leftMargin;
  final bool _isTransaction;
  final double _logoSize;
  final double _borderRadius;
  final TransactionResource _transactionResource;
  final Business _business;

  final SharedSizes sharedSizes = SharedSizes();
  
  LogoButton({
    @required AnimationController controller,
    @required double topMargin,
    @required double leftMargin,
    @required bool isTransaction,
    @required double logoSize,
    @required double borderRadius,
    TransactionResource transactionResource,
    Business business
  })
    : assert(controller != null && topMargin != null && leftMargin != null && isTransaction != null && logoSize != null && borderRadius != null),
      _controller = controller,
      _topMargin = topMargin,
      _leftMargin = leftMargin,
      _isTransaction = isTransaction,
      _logoSize = logoSize,
      _borderRadius = borderRadius,
      _transactionResource = transactionResource,
      _business = business;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: _logoSize,
      width: _logoSize,
      top: _topMargin,
      left: _leftMargin,
      child: _isTransaction
        ? BlocProvider<LogoTransactionButtonBloc>(
            create: (_) => LogoTransactionButtonBloc(), 
            child: LogoTransactionButton(
              transactionResource: _transactionResource,
              logoBorderRadius: _borderRadius,
              warningIconSize: _logoSize / 2,
            )
          ) 
        : BlocProvider<LogoBusinessButtonBloc>(
            create: (_) => LogoBusinessButtonBloc(),
            child: LogoBusinessButton(
              business: _business,
              logoBorderRadius: _borderRadius,
            )
          )
    );
  }

  double lerp({@required double min, @required double max}) {
    return lerpDouble(min, max, _controller.value);
  }
}