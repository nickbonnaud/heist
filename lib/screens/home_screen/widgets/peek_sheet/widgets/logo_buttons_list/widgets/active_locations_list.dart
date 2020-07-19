import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/active_location.dart';

import 'shared_list_items/logo_button/logo_button.dart';
import 'shared_list_items/logo_details/business_logo_details.dart';
import 'shared_list_items/logo_divider.dart';
import 'shared_list_items/shared_sizes.dart';

class ActiveLocationsList extends StatelessWidget {
  final int _numberOpenTransactions;
  final AnimationController _controller;
  final double _topMargin;

  final SharedSizes sharedSizes = SharedSizes();

  double get _size => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);
  double get _borderRadius => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);

  ActiveLocationsList({@required int numberOpenTransactions, @required AnimationController controller, @required double topMargin})
    : assert(numberOpenTransactions != null && controller != null && topMargin != null),
      _numberOpenTransactions = numberOpenTransactions,
      _controller = controller,
      _topMargin = topMargin;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveLocationBloc, ActiveLocationState>(
      builder: (context, state) {
        final currentState = state;
        if (currentState is CurrentActiveLocations) {
          return Stack(
            children: <Widget>[
              if (_showDivider())
                LogoDivider(index: _numberOpenTransactions, controller: _controller, topMargin: _topMargin),
              for (ActiveLocation activeLocation in currentState.activeLocations) _buildDetails(context: context, activeLocation: activeLocation, state: currentState),
              for (ActiveLocation activeLocation in currentState.activeLocations) _buildLogoButton(context: context, activeLocation: activeLocation, state: currentState),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _buildLogoButton({@required BuildContext context, @required ActiveLocation activeLocation, @required CurrentActiveLocations state}) {
    int index = _numberOpenTransactions + state.activeLocations.indexOf(activeLocation);
    Business business = _getBusiness(context: context, activeLocation: activeLocation, state: state);

    return LogoButton(
      controller: _controller, 
      topMargin: _logoMarginTop(index: index),
      leftMargin: _logoLeftMargin(index: index),
      isTransaction: false,
      logoSize: _size,
      borderRadius: _borderRadius,
      business: business,
    );
  }

  Widget _buildDetails({@required BuildContext context, @required ActiveLocation activeLocation, @required CurrentActiveLocations state}) {
    int index = _numberOpenTransactions + state.activeLocations.indexOf(activeLocation);
    Business business = _getBusiness(context: context, activeLocation: activeLocation, state: state);
    return BusinessLogoDetails(
      topMargin: _logoMarginTop(index: index), 
      leftMargin: _logoLeftMargin(index: index), 
      height: _size, 
      controller: _controller, 
      borderRadius: _borderRadius, 
      business: business
    );
  }

  Business _getBusiness({@required BuildContext context, @required ActiveLocation activeLocation, @required CurrentActiveLocations state}) {
    return BlocProvider.of<NearbyBusinessesBloc>(context).businesses
      .firstWhere((Business business) => activeLocation.beaconIdentifier == business.location.beacon.identifier);
  }

  bool _showDivider() {
    return _numberOpenTransactions > 0;
  }

  double _logoMarginTop({@required int index}) {
    return lerp(
      min: sharedSizes.startMarginTop,
      max: sharedSizes.endMarginTop + ((index + (_showDivider() ? 1 : 0)) * (sharedSizes.verticalSpacing + sharedSizes.endSize))
    ) + _topMargin;
  }

  double _logoLeftMargin({@required int index}) {
    return lerp(
      min: index == 0 ? 8 : (index + (_showDivider() ? 1 : 0)) * ((sharedSizes.horizontalSpacing + sharedSizes.startSize)),
      max: 8
    );
  }
  
  double lerp({@required double min, @required double max}) {
    return lerpDouble(min, max, _controller.value);
  }
}