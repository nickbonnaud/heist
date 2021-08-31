import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'shared_list_items/logo_button/logo_button.dart';
import 'shared_list_items/logo_details/transaction_logo_details/transaction_logo_details.dart';
import 'shared_list_items/shared_sizes.dart';

class OpenTransactionsList extends StatelessWidget {
  final AnimationController _controller;
  final double _topMargin;

  final SharedSizes sharedSizes = SharedSizes();

  double get _size => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);
  double get _borderRadius => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);

  OpenTransactionsList({required AnimationController controller, required double topMargin})
    : _controller = controller,
      _topMargin = topMargin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenTransactionsBloc, OpenTransactionsState>(
      builder: (context, state) {
        final currentState = state;
        if (currentState is OpenTransactionsLoaded && currentState.transactions.length > 0) {
          return Stack(
            children: []
              ..addAll(_detailsList(context: context, state: currentState))
              ..addAll(_buttonsList(context: context, state: currentState))
          );
        }
        return Container();
      }
    );
  }
  
  List<Widget> _detailsList({required BuildContext context, required OpenTransactionsLoaded state}) {
    return List<Widget>.generate(state.openTransactions.length, (index) => _buildDetails(
      transactionResource: state.openTransactions[index],
      state: state,
      subListIndex: index
    ));
  }

  List<Widget> _buttonsList({required BuildContext context, required OpenTransactionsLoaded state}) {
    return List<Widget>.generate(state.openTransactions.length, (index) => _buildLogoButton(
      transactionResource: state.openTransactions[index],
      state: state,
      subListIndex: index
    ));
  }
  
  Widget _buildLogoButton({required TransactionResource transactionResource, required OpenTransactionsLoaded state, required int subListIndex}) {
    int index = state.openTransactions.indexOf(transactionResource);
    return LogoButton(
      keyValue: "openLogoButtonKey-$subListIndex",
      controller: _controller, 
      topMargin: _logoMarginTop(index: index),
      leftMargin: _logoLeftMargin(index: index),
      isTransaction: true,
      logoSize: _size,
      borderRadius: _borderRadius,
      transactionResource: transactionResource,
    );
  }

  Widget _buildDetails({required TransactionResource transactionResource, required OpenTransactionsLoaded state, required int subListIndex}) {
    int fullIndex = state.openTransactions.indexOf(transactionResource);
    return TransactionLogoDetails(
      keyValue: "openDetailsKey-$subListIndex",
      topMargin: _logoMarginTop(index: fullIndex), 
      leftMargin: _logoLeftMargin(index: fullIndex), 
      height: _size, 
      borderRadius: _borderRadius, 
      transactionResource: transactionResource,
      controller: _controller,
      subListIndex: subListIndex 
    );
  }

  double _logoMarginTop({required int index}) {
    return lerp(
      min: sharedSizes.startMarginTop,
      max: sharedSizes.endMarginTop + (index * (sharedSizes.verticalSpacing + sharedSizes.endSize))
    ) + _topMargin;
  }

  double _logoLeftMargin({required int index}) {
    return lerp(
      min: index == 0 ? 3.w : index * ((sharedSizes.horizontalSpacing + sharedSizes.startSize)),
      max: 8.w
    );
  }
  
  double lerp({required double min, required double max}) {
    return lerpDouble(min, max, _controller.value)!;
  }
}