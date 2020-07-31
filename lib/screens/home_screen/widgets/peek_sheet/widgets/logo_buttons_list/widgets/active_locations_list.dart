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
        if (state.activeLocations.length > 0) {
          return Stack(
            children: <Widget>[
              if (_showDivider())
                LogoDivider(
                  numberPreviousWidgets: _numberOpenTransactions,
                  controller: _controller,
                  topMargin: _topMargin, 
                  isActiveLocationDivider: true
                ),
              for (ActiveLocation activeLocation in state.activeLocations) _buildDetails(context: context, activeLocation: activeLocation, state: state),
              for (ActiveLocation activeLocation in state.activeLocations) _buildLogoButton(context: context, activeLocation: activeLocation, state: state),
            ],
          );
        }
        return Container();
      },
    );
  }

  int _setIndex({@required ActiveLocationState state, @required ActiveLocation activeLocation}) {
    return _setPreviousIndex() + state.activeLocations.indexOf(activeLocation);
  }

  int _setPreviousIndex() {
    return _numberOpenTransactions + _numberOfDividers();
  }

  int _numberOfDividers() {
    return _numberOpenTransactions > 0
      ? 1 : 0;
  }
  
  Widget _buildLogoButton({@required BuildContext context, @required ActiveLocation activeLocation, @required ActiveLocationState state}) {
    int index = _setIndex(state: state, activeLocation: activeLocation);
    Business business = _getBusiness(context: context, activeLocation: activeLocation, state: state);

    if (business == null) return Container();

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

  Widget _buildDetails({@required BuildContext context, @required ActiveLocation activeLocation, @required ActiveLocationState state}) {
    int index = _setIndex(state: state, activeLocation: activeLocation);
    Business business = _getBusiness(context: context, activeLocation: activeLocation, state: state);
    
    if (business == null) return Container();
    
    return BusinessLogoDetails(
      topMargin: _logoMarginTop(index: index), 
      leftMargin: _logoLeftMargin(index: index), 
      height: _size, 
      controller: _controller, 
      borderRadius: _borderRadius, 
      business: business
    );
  }
  
  Business _getBusiness({@required BuildContext context, @required ActiveLocation activeLocation, @required ActiveLocationState state}) {
    return BlocProvider.of<NearbyBusinessesBloc>(context).businesses
      .firstWhere((Business business) => activeLocation.beaconIdentifier == business.location.beacon.identifier,
      orElse: null
    );
  }

  bool _showDivider() {
    return _numberOpenTransactions > 0;
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