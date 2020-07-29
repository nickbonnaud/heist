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

  LogoButtonsList({@required AnimationController controller, @required double topMargin})
    : assert(controller != null && topMargin != null),
      _controller = controller,
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
            height: _getContainerHeight(state: state),
            width: _getContainerWidth(state: state),
            child: Stack(
              children: <Widget>[
                if (state.numberOpenTransactions > 0)
                  OpenTransactionsList(controller: _controller, topMargin: _topMargin),
                state.numberActiveLocations > 0
                  ? ActiveLocationsList(controller: _controller, topMargin: _topMargin, numberOpenTransactions: state.numberOpenTransactions)
                  : state.numberNearbyLocations  > 0
                    ? NearbyBusinessesList(controller: _controller, topMargin: _topMargin, numberOpenTransactions: state.numberOpenTransactions)
                    : Container()
              ],
            ),
          ),
        );
      }
    );
  }

  double _getContainerHeight({@required LogoButtonsListState state}) {
    int logosLength = state.numberOpenTransactions;
    logosLength += state.numberActiveLocations > 0 ? state.numberActiveLocations : state.numberNearbyLocations;
    return sharedSizes.endMarginTop + ((logosLength + (state.numberOpenTransactions > 0 ? 1 : 0)) * (sharedSizes.verticalSpacing + sharedSizes.endSize)) + (_topMargin * 2.5);
  }

  double _getContainerWidth({@required LogoButtonsListState state}) {
    int logosLength = state.numberOpenTransactions;
    logosLength += state.numberActiveLocations > 0 ? state.numberActiveLocations : state.numberNearbyLocations;
    return (logosLength + (state.numberOpenTransactions > 0 ? 1 : 0)) * ((1.1 * sharedSizes.horizontalSpacing + sharedSizes.startSize));
  }

  double lerp({@required double min, @required double max}) {
    return lerpDouble(min, max, _controller.value);
  }
}