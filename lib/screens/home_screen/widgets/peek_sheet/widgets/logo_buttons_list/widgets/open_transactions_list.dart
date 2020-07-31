import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';

import 'shared_list_items/logo_button/logo_button.dart';
import 'shared_list_items/logo_details/transaction_logo_details.dart';
import 'shared_list_items/shared_sizes.dart';

class OpenTransactionsList extends StatelessWidget {
  final AnimationController _controller;
  final double _topMargin;

  final SharedSizes sharedSizes = SharedSizes();

  double get _size => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);
  double get _borderRadius => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);

  OpenTransactionsList({@required AnimationController controller, @required double topMargin})
    : assert(controller != null && topMargin != null),
      _controller = controller,
      _topMargin = topMargin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTransactionsBloc, OpenTransactionsState>(
      builder: (context, state) {
        final currentState = state;
        if (currentState is OpenTransactionsLoaded && currentState.transactions.length > 0) {
          return Stack(
            children: <Widget>[
              for (TransactionResource transactionResource in currentState.openTransactions) _buildDetails(state: currentState, transactionResource: transactionResource),
              for (TransactionResource transactionResource in currentState.openTransactions) _buildLogoButton(state: currentState, transactionResource: transactionResource),
            ],
          );
        }
        return Container();
      }
    );
  }

  Widget _buildLogoButton({@required TransactionResource transactionResource, @required OpenTransactionsLoaded state}) {
    int index = state.openTransactions.indexOf(transactionResource);
    return LogoButton(
      controller: _controller, 
      topMargin: _logoMarginTop(index: index),
      leftMargin: _logoLeftMargin(index: index),
      isTransaction: true,
      logoSize: _size,
      borderRadius: _borderRadius,
      transactionResource: transactionResource,
    );
  }

  Widget _buildDetails({@required TransactionResource transactionResource, @required OpenTransactionsLoaded state}) {
    int index = state.openTransactions.indexOf(transactionResource);
    return TransactionLogoDetails(
      topMargin: _logoMarginTop(index: index), 
      leftMargin: _logoLeftMargin(index: index), 
      height: _size, 
      borderRadius: _borderRadius, 
      transactionResource: transactionResource,
      controller: _controller,
    );
  }

  double _logoMarginTop({@required int index}) {
    return lerp(
      min: sharedSizes.startMarginTop,
      max: sharedSizes.endMarginTop + (index * (sharedSizes.verticalSpacing + sharedSizes.endSize))
    ) + _topMargin;
  }

  double _logoLeftMargin({@required int index}) {
    return lerp(
      min: index == 0 ? 3 : index * ((sharedSizes.horizontalSpacing + sharedSizes.startSize)),
      max: 8
    );
  }
  
  double lerp({@required double min, @required double max}) {
    return lerpDouble(min, max, _controller.value);
  }
}