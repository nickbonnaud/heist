import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:collection/collection.dart';

import 'shared_list_items/logo_button/logo_button.dart';
import 'shared_list_items/logo_details/business_logo_details/business_logo_details.dart';
import 'shared_list_items/logo_divider.dart';
import 'shared_list_items/shared_sizes.dart';

class ActiveLocationsList extends StatelessWidget {
  final int _numberOpenTransactions;
  final AnimationController _controller;
  final double _topMargin;

  final SharedSizes sharedSizes = SharedSizes();

  double get _size => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);
  double get _borderRadius => lerp(min: sharedSizes.startSize, max: sharedSizes.endSize);

  ActiveLocationsList({required int numberOpenTransactions, required AnimationController controller, required double topMargin})
    : _numberOpenTransactions = numberOpenTransactions,
      _controller = controller,
      _topMargin = topMargin;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveLocationBloc, ActiveLocationState>(
      builder: (context, state) {
        if (state.activeLocations.length > 0) {
          return Stack(
            children: [_divider()]
              ..addAll(_detailsList(context: context, state: state))
              ..addAll(_buttonsList(context: context, state: state))
          );
        }
        return Container();
      },
    );
  }

  Widget _divider() {
    if (_numberOpenTransactions > 0) {
      return LogoDivider(
        numberPreviousWidgets: _numberOpenTransactions,
        controller: _controller,
        topMargin: _topMargin, 
        isActiveLocationDivider: true
      );
    }
    return Container();
  }

  List<Widget> _detailsList({required BuildContext context, required ActiveLocationState state}) {
    return List<Widget>.generate(state.activeLocations.length, (index) => _buildDetails(
      context: context,
      activeLocation: state.activeLocations[index],
      state: state,
      subListIndex: index
    ));
  }

  List<Widget> _buttonsList({required BuildContext context, required ActiveLocationState state}) {
    return List<Widget>.generate(state.activeLocations.length, (index) => _buildLogoButton(
      context: context,
      activeLocation: state.activeLocations[index],
      state: state,
      subListIndex: index
    ));
  }
  
  int _setIndex({required ActiveLocationState state, required ActiveLocation activeLocation}) {
    return _setPreviousIndex() + state.activeLocations.indexOf(activeLocation);
  }

  int _setPreviousIndex() {
    return _numberOpenTransactions + _numberOfDividers();
  }

  int _numberOfDividers() {
    return _numberOpenTransactions > 0
      ? 1 : 0;
  }
  
  Widget _buildLogoButton({required BuildContext context, required ActiveLocation activeLocation, required ActiveLocationState state, required int subListIndex}) {
    int fullIndex = _setIndex(state: state, activeLocation: activeLocation);
    Business? business = _getBusiness(context: context, activeLocation: activeLocation, state: state);

    return LogoButton(
      keyValue: "activeLogoButtonKey-$subListIndex",
      controller: _controller, 
      topMargin: _logoMarginTop(index: fullIndex),
      leftMargin: _logoLeftMargin(index: fullIndex),
      isTransaction: false,
      logoSize: _size,
      borderRadius: _borderRadius,
      business: business,
    );
  }

  Widget _buildDetails({required BuildContext context, required ActiveLocation activeLocation, required ActiveLocationState state, required int subListIndex}) {
    int fullIndex = _setIndex(state: state, activeLocation: activeLocation);
    Business? business = _getBusiness(context: context, activeLocation: activeLocation, state: state);
    
    if (business == null) return Container();
    
    return BusinessLogoDetails(
      keyValue: "activeDetailsKey-$subListIndex",
      topMargin: _logoMarginTop(index: fullIndex), 
      leftMargin: _logoLeftMargin(index: fullIndex), 
      height: _size, 
      controller: _controller, 
      borderRadius: _borderRadius, 
      business: business,
      subListIndex: subListIndex,
    );
  }
  
  Business? _getBusiness({required BuildContext context, required ActiveLocation activeLocation, required ActiveLocationState state}) {
    return BlocProvider.of<NearbyBusinessesBloc>(context).state.businesses
      .firstWhereOrNull((Business business) => activeLocation.beaconIdentifier == business.location.beacon.identifier);
  }

  double _logoMarginTop({required int index}) {
    return lerp(
      min: sharedSizes.startMarginTop,
      max: sharedSizes.endMarginTop + (index * (sharedSizes.verticalSpacing + sharedSizes.endSize))
    ) + _topMargin;
  }

  double _logoLeftMargin({required int index}) {
    return lerp(
      min: index == 0 ? 3 : index * ((sharedSizes.horizontalSpacing + sharedSizes.startSize)),
      max: 8
    );
  }
  
  double lerp({required double min, required double max}) {
    return lerpDouble(min, max, _controller.value)!;
  }
}