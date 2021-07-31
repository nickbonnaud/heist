import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/logo_buttons_list_bloc.dart';
import 'widgets/active_locations_list.dart';
import 'widgets/nearby_businesses_list.dart';
import 'widgets/open_transactions_list.dart';
import 'widgets/shared_list_items/shared_sizes.dart';

class LogoButtonsList extends StatelessWidget {
  final AnimationController _controller;
  final double _topMargin;

  final SharedSizes sharedSizes = SharedSizes();

  LogoButtonsList({required AnimationController controller, required double topMargin})
    : _controller = controller,
      _topMargin = topMargin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogoButtonsListBloc, LogoButtonsListState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: _controller.status == AnimationStatus.completed
            ? Axis.vertical
            : Axis.horizontal,
          child: Container(
            key: Key('logosListKey'),
            height: _getContainerHeight(context: context, state: state),
            width: _getContainerWidth(context: context, state: state),
            child: Stack(
              children: <Widget>[
                if (state.numberOpenTransactions > 0)
                  OpenTransactionsList(controller: _controller, topMargin: _topMargin),
                if (state.numberActiveLocations > 0)
                  ActiveLocationsList(controller: _controller, topMargin: _topMargin, numberOpenTransactions: state.numberOpenTransactions),
                if (state.numberNearbyLocations  > 0)
                  NearbyBusinessesList(controller: _controller, topMargin: _topMargin, numberOpenTransactions: state.numberOpenTransactions, numberActiveLocations: state.numberActiveLocations,)
              ],
            ),
          ),
        );
      }
    );
  }

  double _getContainerHeight({required BuildContext context, required LogoButtonsListState state}) {
    int logosLength = state.numberOpenTransactions + state.numberActiveLocations + BlocProvider.of<LogoButtonsListBloc>(context).numberNearbySlots;
    double padding = _setPadding(logosLength: logosLength, state: state, isHeight: true);

    return sharedSizes.endMarginTop + ((logosLength + padding) * (sharedSizes.verticalSpacing + sharedSizes.endSize)) + (_topMargin * 2.5);
  }

  double _getContainerWidth({required BuildContext context, required LogoButtonsListState state}) {
    int logosLength = state.numberOpenTransactions + state.numberActiveLocations + BlocProvider.of<LogoButtonsListBloc>(context).numberNearbySlots;
    double padding = _setPadding(logosLength: logosLength, state: state, isHeight: false);

    return (logosLength + padding) * ((sharedSizes.horizontalSpacing + sharedSizes.startSize));
  }

  double _setPadding({required int logosLength, required LogoButtonsListState state, required bool isHeight}) {
    if (logosLength < 6) return isHeight ? 2 : 2.25;
    if (state.numberOpenTransactions == 0 && state.numberActiveLocations == 0) return 0;
    if (state.numberOpenTransactions > 0 && state.numberActiveLocations > 0) return isHeight ? 2 : 2.25;
    return isHeight ? 1 : 1.25;
  }

  double lerp({required double min, required double max}) {
    return lerpDouble(min, max, _controller.value)!;
  }
}